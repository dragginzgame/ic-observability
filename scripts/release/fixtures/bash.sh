# shellcheck shell=bash
set -euo pipefail
# Stable dispatcher: phase is explicit data, never a replaced executable.
case "${1:-}" in
    */scripts/ci/check-make-execution.sh|*/scripts/ci/check-release-delivery.sh|scripts/ci/check-rust-compiler.sh)
        exec "$STANDARD_RELEASE_REAL_BASH" "$@" ;;
    scripts/release/metadata.sh)
        if [[ "$2" == selection ]]; then exit 0; fi
        if [[ "$2" == packages ]]; then printf 'ic-%s\n' "$RELEASE_GROUP"; exit 0; fi
        if [[ "$STANDARD_RELEASE_PHASE" == metadata ]]; then
            if [[ "${REQUIRE_RUST_CATALOG:-0}" == 1 ]]; then
                [[ "$2" == preflight && "$RUST_TOOL_VERSIONS" == "$EXPECTED_RUST_CATALOG" ]] || exit 1
                printf '%s\n' "$RUST_TOOL_VERSIONS" >> "$EVENTS"
                exit 0
            fi
            if [[ "${REQUIRE_JOBSERVER:-0}" == 1 ]]; then
                perl "$JOBSERVER_PROBE"
                printf 'metadata %s\n' "$2" >> "$EVENTS"
                exit "${FAIL_METADATA:-0}"
            fi
        fi ;;
    scripts/release/publication.sh)
        if [[ "$STANDARD_RELEASE_PHASE" == publication ]]; then
            printf 'publication-admission %s\n' "$OBSERVABILITY_PUBLICATION_MODE" >> "$EVENTS"
            exit 0
        fi ;;
    */scripts/ci/run-cargo-publication.sh)
        if [[ "$STANDARD_RELEASE_PHASE" == publication ]]; then
            if [[ "${REQUIRE_JOBSERVER:-0}" == 1 ]]; then perl "$JOBSERVER_PROBE"; fi
            printf '%s\n' publication "$2" "$5" "${@:6}" >> "$EVENTS"
            exit 0
        fi ;;
esac
if [[ "$STANDARD_RELEASE_PHASE" == metadata ]]; then
    printf 'unexpected dispatch\n' >> "$EVENTS"
    exit 0
fi
exec "$STANDARD_RELEASE_REAL_BASH" "$@"
