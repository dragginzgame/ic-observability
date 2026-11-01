#!/usr/bin/env bash
set -euo pipefail
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
export PATH="$root/.tools/host/bin:$PATH"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
mkdir -p "$root/target/qualification"
fixture="$(fixture_create "$root/target/qualification/ci-selection.XXXXXX")"
fixture_complete=false
trap 'fixture_finish "$?" "$fixture" "CI selection fixture retained"' EXIT
yq -o json '.jobs.changes.steps' "$root/.github/workflows/ci.yml" > "$fixture/steps.json"
bash "$root/scripts/ci/extract-workflow-step.sh" "$fixture/steps.json" select > "$fixture/select-step.sh"
yq -o json '.jobs' "$root/.github/workflows/ci.yml" > "$fixture/jobs.json"
# Stable product job names retain full execution when classification fails.
jq -e '
  all(.typescript,.native,.msrv; .needs == "changes" and
    (.if | contains("always()")) and
    (.env.CI_SCOPE | contains("needs.changes.result == '\''success'\''") and endswith("'\''full'\'' }}"))) and
  (.native.strategy.matrix.include | length == 3) and
  all(.typescript.steps[],.native.steps[],.msrv.steps[];
    (.if | contains("env.CI_SCOPE")))
' "$fixture/jobs.json" > /dev/null
mkdir -p "$fixture/repo/scripts/ci" "$fixture/repo/ci" "$fixture/repo/docs/status"
cp "$root/scripts/ci/"{classify-ci-change.pl,select-ci.sh} "$fixture/repo/scripts/ci/"
cp "$root/ci/docs-only-paths.txt" "$fixture/repo/ci/"
# The actual allowlist must not admit packaged/embedded/companion inputs.
while IFS= read -r path; do
    case "$path" in ''|'#'*) continue ;; esac
    case "$path" in crates/*|README.md|AGENTS.md|DRAGGINZGAME.md|.github/*|scripts/*|ci/*|make/*) exit 1 ;; esac
    [[ -f "$root/$path" ]] || exit 1
    if rg -q 'Shared companions:' "$root/$path"; then exit 1; fi
done < "$root/ci/docs-only-paths.txt"
cd "$fixture/repo"
printf 'prose\n' > docs/status/current.md
printf '[workspace]\n' > Cargo.toml
git init -q
git config user.email fixture@example.invalid
git config user.name Fixture
git add .
git commit -qm baseline
base="$(git rev-parse HEAD)"
check() {
    local expected="$1" start="$2" head="$3" event="${4:-push}" ref="${5:-refs/heads/main}"
    : > "$fixture/output"
    CI_EVENT="$event" CI_REF="$ref" CI_BASE="$start" CI_HEAD="$head" \
        GITHUB_OUTPUT="$fixture/output" bash "$fixture/select-step.sh" 2> "$fixture/diagnostic"
    printf 'scope=%s\n' "$expected" > "$fixture/expected"
    cmp "$fixture/expected" "$fixture/output"
}
printf 'updated prose\n' >> docs/status/current.md
git add docs/status/current.md; git commit -qm prose
docs="$(git rev-parse HEAD)"
check docs "$base" "$docs"
check docs "$base" "$docs" pull_request
printf '# source change\n' >> Cargo.toml
git add Cargo.toml; git commit -qm mixed
mixed="$(git rev-parse HEAD)"
check full "$docs" "$mixed"
check full "$base" "$mixed"
printf '\n# policy change\n' >> ci/docs-only-paths.txt
git add ci/docs-only-paths.txt; git commit -qm policy
check full "$mixed" "$(git rev-parse HEAD)"
check full 1111111111111111111111111111111111111111 "$docs"
check full "$base" "$docs" push refs/tags/metrics-v0.0.1
# A broken classifier cannot publish a docs result; workflow wiring above falls back.
printf 'exit 41;\n' > scripts/ci/classify-ci-change.pl
: > "$fixture/output"
if CI_EVENT=push CI_REF=refs/heads/main CI_BASE="$base" CI_HEAD="$docs" \
    GITHUB_OUTPUT="$fixture/output" bash "$fixture/select-step.sh"; then exit 1; fi
[[ ! -s "$fixture/output" ]]
fixture_complete=true
printf 'Actual CI selector: prose, code, mixed, policy, missing history and failure passed.\n'
