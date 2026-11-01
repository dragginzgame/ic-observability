#!/usr/bin/env bash
set -euo pipefail
scope="$(perl scripts/ci/classify-ci-change.pl --event "$CI_EVENT" --ref "$CI_REF" \
    --base "$CI_BASE" --head "$CI_HEAD" --policy ci/docs-only-paths.txt)"
case "$scope" in docs|full) ;; *) exit 2 ;; esac
printf 'scope=%s\n' "$scope" >> "$GITHUB_OUTPUT"
