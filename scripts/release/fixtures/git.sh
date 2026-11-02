# shellcheck shell=bash
set -euo pipefail
if [[ "$STANDARD_RELEASE_PHASE" == publication && "$*" == 'rev-parse --verify HEAD' ]]; then
    printf '%040d\n' 1
else
    exec "$STANDARD_RELEASE_REAL_GIT" "$@"
fi
