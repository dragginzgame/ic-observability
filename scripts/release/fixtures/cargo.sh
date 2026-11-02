# shellcheck shell=bash
set -euo pipefail
if [[ "${REQUIRE_JOBSERVER:-0}" == 1 ]]; then
    perl "$JOBSERVER_PROBE"
fi
if [[ "$*" == 'metadata --no-deps --locked --offline --format-version 1' ]]; then
    cat "${EVENTS%/*}/publication-metadata.json"
    exit 0
fi
printf '%s\n' "$@" >> "$EVENTS"
case "$1:${CLIPPY_FAILURE:-}" in
    clippy:native) exit 37 ;;
    clippy:wasm) [[ "$*" != *' --target wasm32-unknown-unknown '* ]] || exit 37 ;;
esac
[[ "$1" != package || "${FAIL_PACKAGE:-0}" == 0 ]] || exit 38
