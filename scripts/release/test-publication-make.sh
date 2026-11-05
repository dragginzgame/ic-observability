#!/usr/bin/env bash
set -euo pipefail
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES
unset VALIDATION_REPOSITORY_ROOT VALIDATION_RUNNER_SNAPSHOT_PATH
export RELEASE_DELIVERY=direct RELEASE_GROUP=metrics
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
mkdir -p "$root/target"
fixture="$(fixture_create "${TMPDIR:-$root/target}/publication-make-entry.XXXXXX")"
fixture_complete=false
cleanup() {
    local status=$?
    if [[ "$status" != 0 ]]; then fixture_replay_logs "$fixture/output"; fi
    fixture_finish "$status" "$fixture" "publication Make fixture retained"
}
trap cleanup EXIT
assertion_fault="${METRICS_FIXTURE_ASSERTION_FAILURE:-0}"
unset METRICS_FIXTURE_ASSERTION_FAILURE
[[ "$assertion_fault" == 0 || "$assertion_fault" == 1 ]] || exit 2
# shellcheck source=scripts/ci/make-adapter-probes.sh
source "$root/scripts/ci/make-adapter-probes.sh"
# shellcheck source=scripts/release/fixtures/prepare-make.sh
source "$root/scripts/release/fixtures/prepare-make.sh"
prepare_make_fixture "$root" "$fixture"
real_make="$(command -v make)"
export JOBSERVER_PROBE="$root/scripts/ci/check-pipe-jobserver.pl"
parallel=(-j4)
if "$real_make" --help | grep -q -- --jobserver-style; then parallel+=(--jobserver-style=pipe); fi
cd "$fixture"
export STANDARD_RELEASE_PHASE=publication
PATH="$fixture/bin:$PATH" make_probe_target_admission "$real_make" "$root/Makefile" "$fixture" "$EVENTS" publish publish-check
PATH="$fixture/bin:$PATH" REQUIRE_JOBSERVER=1 make_probe_parallel_dispatch "$real_make" "$root/Makefile" "$fixture" "$EVENTS" publish publish-check
# Independent expected Cargo trace; never derived from the Make recipe.
write_expected_lints() {
    local destination="$1" last_phase="$2"
    printf 'publication-admission %s\n' "$mode" > "$destination"
    printf '%s\n' clippy -p "$lint_package" --all-targets --all-features --locked -- -D warnings >> "$destination"
    case "$last_phase" in
        native) ;;
        wasm) printf '%s\n' clippy -p "$lint_package" --lib --all-features --locked --target wasm32-unknown-unknown -- -D warnings >> "$destination" ;;
        *) return 2 ;;
    esac
}

# Shared owns selection/error permutations and actual Cargo dispatch. Retain
# this consumer's two-package roster, one override and both exact lint boundaries.
export STANDARD_RELEASE_PHASE=publication
for selection in default ic-logging; do
    lint_package=ic-metrics
    selectors=(--package ic-metrics@0.1.0)
    package_args=()
    if [[ "$selection" != default ]]; then
        lint_package=ic-logging
        selectors=(--package ic-logging@0.1.0)
        package_args=("RELEASE_GROUP=logging" "PACKAGE=$selection")
    fi
    for target in publish publish-check; do
        : > "$EVENTS"
        PATH="$fixture/bin:$PATH" "$real_make" --no-print-directory \
            -f "$root/Makefile" "$target" ${package_args[@]+"${package_args[@]}"} > "$fixture/output" 2>&1
        mode=publish
        [[ "$target" != publish-check ]] || mode=check
        write_expected_lints "$fixture/expected" wasm
        printf '%s\n' publication "$mode" crates-io "${selectors[@]}" >> "$fixture/expected"
        if [[ "$assertion_fault" == 1 ]]; then
            echo 'FIXTURE_RETENTION_INJECTED_FAILURE' >&2
            printf 'injected mismatched expectation\n' >> "$fixture/expected"
            shasum -a 256 expected events output bin/cargo bin/bash bin/git publication-metadata.json > retention-inputs.sha256
        fi
        cmp "$fixture/expected" "$EVENTS"
        for failure in native wasm; do
            : > "$EVENTS"
            status=0
            PATH="$fixture/bin:$PATH" REQUIRE_JOBSERVER=1 CLIPPY_FAILURE="$failure" "$real_make" "${parallel[@]}" --no-print-directory \
                -f "$root/Makefile" "$target" ${package_args[@]+"${package_args[@]}"} > "$fixture/output" 2>&1 || status=$?
            [[ "$status" == 2 ]] || exit 1
            write_expected_lints "$fixture/expected" "$failure"
            cmp "$fixture/expected" "$EVENTS"
        done
    done
done

# Exercise the actual verified-publication recipe, substituting only its two
# existing public children. A failed readback must not dispatch another upload.
cat > Makefile <<'MAKE'
.PHONY: publish verify-publication
publish:
	@printf 'upload\n' >> "$$EVENTS"
	@exit "$${WRAPPER_UPLOAD_STATUS:-0}"
verify-publication:
	@printf 'readback\n' >> "$$EVENTS"
	@exit "$${WRAPPER_READBACK_STATUS:-0}"
MAKE
for failure in none upload readback; do
    : > "$EVENTS"
    upload_status=0 readback_status=0 status=0
    [[ "$failure" != upload ]] || upload_status=37
    [[ "$failure" != readback ]] || readback_status=38
    WRAPPER_UPLOAD_STATUS="$upload_status" WRAPPER_READBACK_STATUS="$readback_status" \
        "$real_make" --no-print-directory -f "$root/Makefile" publish-verified > "$fixture/output" 2>&1 || status=$?
    if [[ "$failure" == none ]]; then [[ "$status" == 0 ]]; else [[ "$status" != 0 ]]; fi
    printf 'upload\n' > "$fixture/expected"
    [[ "$failure" == upload ]] || printf 'readback\n' >> "$fixture/expected"
    cmp "$fixture/expected" "$EVENTS"
done
echo 'Publication Make selection, lint failures and upload/readback ordering passed (substituted effects).'
fixture_complete=true
