#!/usr/bin/env bash
set -euo pipefail
# Parse the actual consumer and exercise its exported target overrides, stopping
# in a prerequisite before any metadata, compiler, Git or upload recipe runs.
[[ $# -le 1 ]] || exit 2
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
cd "$root"
mkdir -p target/qualification
fixture="$(mktemp -d "$root/target/qualification/setup-smoke.XXXXXX")"
printf 'Setup smoke evidence: %s\n' "$fixture"
finish() {
    local status=$?
    if [[ "$status" != 0 ]]; then
        for log in "$fixture"/*.log; do
            [[ ! -f "$log" ]] || cat "$log" >&2
        done
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
	@printf '%s\n' setup-mode-admitted
	@exit 43
MAKE
for target in publish publish-check; do
    mode=publish
    [[ "$target" != publish-check ]] || mode=check
    status=0
    SETUP_EXPECTED_MODE="$mode" "$executable" --no-print-directory -f Makefile -f "$fixture/probe.mk" \
        "$target" OBSERVABILITY_PUBLICATION_MODE=hostile > "$fixture/$target.log" 2>&1 || status=$?
    [[ "$status" == 2 ]]
    grep -Fxq setup-mode-admitted "$fixture/$target.log"
done
printf 'Actual consumer Make parsing and publication environment passed (no publication effects).\n'
