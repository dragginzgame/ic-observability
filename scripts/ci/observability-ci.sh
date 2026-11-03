#!/usr/bin/env bash
# Shared companions: scripts/release/validation.pl scripts/ci/run-validation-targets.sh
set -euo pipefail
[[ "${OBSERVABILITY_RELEASE_VALIDATION_SCOPE:-}" == workspace ]] || {
    echo 'Full CI requires workspace scope; use make ci' >&2; exit 2;
}
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
cd "$root"
mkdir -p target/qualification
evidence="$(mktemp -d target/qualification/full-roster.XXXXXX)"
perl scripts/release/validation.pl roster > "$evidence/stages"
stages=()
while IFS= read -r stage; do stages+=("$stage"); done < "$evidence/stages"
# workspace-ci's explicit command-line selection propagates through recursive Make.
bash scripts/ci/run-validation-targets.sh --fail-fast \
    --input ci/release-validation.json --input ci/cargo-release-groups.json \
    --input make/validation.mk --input scripts/ci/observability-ci.sh "${stages[@]}"
