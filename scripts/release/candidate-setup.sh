#!/usr/bin/env bash
set -euo pipefail
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
cd "$root"
[[ "${RELEASE_BATCH_ACTIVE:-}" == 1 ]] || { echo 'Candidate setup requires captured delivery context' >&2; exit 2; }
bash scripts/release/metadata.sh selection
bash scripts/dev/shared-tooling.sh check --consumer "$root"
mode="${RELEASE_SETUP_MODE:-}"
case "$mode" in prepare|check) ;; *) echo 'Select candidate setup mode prepare or check' >&2; exit 2 ;; esac
[[ "${HOST_TOOL_VERSIONS:-$root/ci/tool-versions.env}" == "$root/ci/tool-versions.env" &&
   "${RUST_TOOL_VERSIONS:-$root/ci/tool-versions.env}" == "$root/ci/tool-versions.env" ]] || {
    echo 'Frozen delivery requires the captured checkout catalogs; qualify external pin overrides separately' >&2; exit 2;
}
printf 'Release candidate setup: %s (%s)\n' "$mode" "$RELEASE_GROUP"
if [[ "$mode" == prepare ]]; then
    "${RELEASE_MAKE:-make}" --no-print-directory install-host-tools
    "${RELEASE_MAKE:-make}" --no-print-directory compiler-check
    # Shared owns locked fetch, pin custody and tool sequencing. Later standard
    # preflight only admits this prepared selection, rather than preparing twice.
    bash scripts/ci/cargo-release-preflight.sh "$root" 1 \
        --pin "$root/ci/tool-versions.env" --pin "$root/ci/release-tools.env" \
        --prepare install-rust-tools --prepare rust-tools-check \
        --prepare install-release-editor --prepare release-editor-check \
        --check rust-tools-check --check release-editor-check
else
    # Recovery admits the captured selection offline; it never installs against
    # partially prepared metadata or imports normal-checkout tool pointers.
    "${RELEASE_MAKE:-make}" --no-print-directory tools-check
fi
