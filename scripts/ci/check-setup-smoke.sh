#!/usr/bin/env bash
set -euo pipefail
# Parse the actual consumer before metadata, compiler or external release effects.
[[ $# -le 1 ]] || exit 2
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
cd "$root"
mkdir -p target/qualification
fixture="$(mktemp -d "$root/target/qualification/setup-smoke.XXXXXX")"
printf 'Setup smoke evidence: %s\n' "$fixture"
finish() {
    local status=$?
    if [[ "$status" != 0 ]]; then
        for log in "$fixture"/*.log; do [[ ! -f "$log" ]] || cat "$log" >&2; done
    fi
    exit "$status"
}
trap finish EXIT
executable="${1:-make}"
"$executable" --version > "$fixture/make-version.txt"
cat > "$fixture/probe.mk" <<'MAKE'
.PHONY: observability-setup-mode
release-group-check:
	@:
publish publish-check: observability-setup-mode
observability-setup-mode:
	@test "$$OBSERVABILITY_PUBLICATION_MODE" = "$$SETUP_EXPECTED_MODE"
	@test "$$OBSERVABILITY_RELEASE_VALIDATION_SCOPE" = group
	@printf '%s\n' setup-mode-admitted
	@exit 43
MAKE
for target in publish publish-check; do
    mode=publish
    [[ "$target" != publish-check ]] || mode=check
    status=0
    SETUP_EXPECTED_MODE="$mode" "$executable" --no-print-directory -f Makefile -f "$fixture/probe.mk" \
        "$target" OBSERVABILITY_PUBLICATION_MODE=hostile OBSERVABILITY_RELEASE_VALIDATION_SCOPE=hostile \
        > "$fixture/$target.log" 2>&1 || status=$?
    [[ "$status" == 2 ]]
    grep -Fxq setup-mode-admitted "$fixture/$target.log"
done
# Both possible runners are sentinels: a broken default cannot create a checkout,
# push or publish from a setup-smoke regression test.
mkdir "$fixture/bin"
export SETUP_SMOKE_ROOT="$root" SETUP_SMOKE_ARGS="$fixture/arguments"
export SETUP_SMOKE_REAL_PERL="$(command -v perl)" SETUP_SMOKE_REAL_BASH="$(command -v bash)"
cat > "$fixture/bin/perl" <<'PERL'
#!/bin/bash
if [[ "${1:-}" == "$SETUP_SMOKE_ROOT/scripts/ci/run-release-batch.pl" ]]; then
    printf '%s\0' "$@" > "$SETUP_SMOKE_ARGS"
    exit 43
fi
exec "$SETUP_SMOKE_REAL_PERL" "$@"
PERL
cat > "$fixture/bin/bash" <<'BASH'
#!/bin/bash
if [[ "${1:-}" == "$SETUP_SMOKE_ROOT/scripts/ci/run-release.sh" ]]; then
    printf 'unexpected-live-runner\n' > "$SETUP_SMOKE_ARGS"
    exit 43
fi
exec "$SETUP_SMOKE_REAL_BASH" "$@"
BASH
chmod +x "$fixture/bin/"{bash,perl}
probe_make() {
    env -u MAKEFLAGS -u MFLAGS -u MAKEOVERRIDES -u GNUMAKEFLAGS -u MAKEFILES \
        -u RELEASE_GROUPS -u RELEASE_PUBLISH_TARGET \
        PATH="$fixture/bin:$PATH" "$executable" --no-print-directory -f Makefile -f "$fixture/probe.mk" \
        "$@" RELEASE_GROUP=metrics RELEASE_REMOTE=origin RELEASE_BRANCH=main RELEASE_DELIVERY=direct RELEASE_BATCH_ACTIVE=
}
for kind in patch minor major; do
    : > "$SETUP_SMOKE_ARGS"
    status=0
    probe_make "release-$kind" > "$fixture/$kind-capture.log" 2>&1 || status=$?
    [[ "$status" == 2 ]]
    printf '%s\0' "$root/scripts/ci/run-release-batch.pl" --root "$root" --groups metrics \
        --kind "$kind" --remote origin --branch main --delivery direct --setup-target release-candidate-setup > "$fixture/expected"
    cmp "$fixture/expected" "$SETUP_SMOKE_ARGS"
done
: > "$SETUP_SMOKE_ARGS"
status=0
probe_make release-patch RELEASE_GROUPS= > "$fixture/empty-roster.log" 2>&1 || status=$?
[[ "$status" == 2 && ! -s "$SETUP_SMOKE_ARGS" ]]
grep -Fq 'A selected release group requires batch capture' "$fixture/empty-roster.log"
# Old operator settings must refuse rather than silently narrowing the roster
# or omitting publication. Exercise this actual Make boundary before any runner.
for setting in RELEASE_FROZEN_GROUPS RELEASE_FROZEN_PUBLISH_TARGET RELEASE_FROZEN_SETUP_TARGET RELEASE_FROZEN_SETUP_MODE FROZEN_RELEASE_ACTIVE; do
    : > "$SETUP_SMOKE_ARGS"
    status=0
    probe_make release-patch "$setting=" > "$fixture/retired-$setting.log" 2>&1 || status=$?
    [[ "$status" == 2 && ! -s "$SETUP_SMOKE_ARGS" ]]
    grep -Fq "Retired release settings: $setting;" "$fixture/retired-$setting.log"
done
for selection in missing unknown roster; do
    group=metrics roster=metrics
    case "$selection" in missing) group='' roster='' ;; unknown) group=unknown roster=unknown ;; roster) roster=metrics,unknown ;; esac
    : > "$SETUP_SMOKE_ARGS"
    status=0
    env -u MAKEFLAGS -u MFLAGS -u MAKEOVERRIDES -u GNUMAKEFLAGS -u MAKEFILES \
        PATH="$fixture/bin:$PATH" "$executable" --no-print-directory release-patch \
        RELEASE_GROUP="$group" RELEASE_GROUPS="$roster" RELEASE_BATCH_ACTIVE= \
        > "$fixture/$selection-admission.log" 2>&1 || status=$?
    [[ "$status" == 2 && ! -s "$SETUP_SMOKE_ARGS" ]]
    grep -Eq 'Select RELEASE_GROUP explicitly|Unknown release group' "$fixture/$selection-admission.log"
done
printf 'Actual consumer Make parsing, publication environment and automatic capture passed (runner effects substituted).\n'
