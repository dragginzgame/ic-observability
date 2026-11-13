#!/usr/bin/env bash
set -euo pipefail
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
export PATH="$root/.tools/host/bin:$PATH"
# shellcheck source=vendor/toko-tooling/scripts/ci/fixture-lifecycle.sh
source "$root/vendor/toko-tooling/scripts/ci/fixture-lifecycle.sh"
mkdir -p "$root/target/qualification"
fixture="$(fixture_create "$root/target/qualification/ci-selection.XXXXXX")"
fixture_complete=false
trap 'fixture_finish "$?" "$fixture" "CI selection fixture retained"' EXIT
yq -o json '.jobs.changes.steps' "$root/.github/workflows/ci.yml" > "$fixture/steps.json"
bash "$root/vendor/toko-tooling/scripts/ci/extract-workflow-step.sh" "$fixture/steps.json" select > "$fixture/select-step.sh"
yq -o json '.jobs' "$root/.github/workflows/ci.yml" > "$fixture/jobs.json"
# Stable product job names retain full execution when classification fails.
jq -e '
  all(.native; .needs == "changes" and
    (.if | contains("always()")) and
    (.env.CI_SCOPE | contains("needs.changes.result == '\''success'\''") and endswith("'\''full'\'' }}"))) and
  (.native.strategy.matrix.include | length == 3) and
  all(.native.steps[];
    (.if | contains("env.CI_SCOPE")))
' "$fixture/jobs.json" > /dev/null
# Security runs once even when native work selects documentation-only scope.
jq -e '
  .security as $security |
  ($security | has("needs") or has("if") or has("strategy") | not) and
  ($security.steps[0].with["fetch-depth"] == 0) and
  all($security.steps[]; has("if") or has("continue-on-error") | not) and
  ([.[] | .steps[] | select(.id == "secrets")] | length == 1) and
  (.native.steps | map(.id) |
    index("restore_downloads") < index("host_tools") and
    index("tools") < index("save_downloads") and
    index("save_downloads") < index("application_sources"))
' "$fixture/jobs.json" > /dev/null
jq '.security.steps' "$fixture/jobs.json" > "$fixture/security.json"
bash "$root/vendor/toko-tooling/scripts/ci/extract-workflow-step.sh" "$fixture/security.json" secrets > "$fixture/scan.sh"
cat > "$fixture/scanner" <<'SCANNER'
#!/usr/bin/env bash
printf '%s\n' "$@" > "$SCAN_ARGUMENTS"
exit "$SCAN_RESULT"
SCANNER
chmod +x "$fixture/scanner"
printf '%s\n' git --redact=100 --no-banner --no-color --log-level error > "$fixture/scan-expected"
for result in 0 1; do
    status=0
    GITLEAKS_BIN="$fixture/scanner" SCAN_ARGUMENTS="$fixture/scan-args" SCAN_RESULT="$result" \
        bash -e "$fixture/scan.sh" || status=$?
    [[ "$status" == "$result" ]] || exit 1
    cmp "$fixture/scan-expected" "$fixture/scan-args"
done
mkdir -p "$fixture/repo/scripts/ci" "$fixture/repo/ci" "$fixture/repo/docs/status"
bash "$root/vendor/toko-tooling/scripts/ci/prepare-script-fixture.sh" "$root" "$fixture/repo" \
    vendor/toko-tooling/scripts/ci/classify-ci-change.pl scripts/ci/select-ci.sh
cp "$root/ci/docs-only-paths.txt" "$fixture/repo/ci/"
# The actual allowlist must not admit packaged/embedded/companion inputs.
while IFS= read -r path; do
    case "$path" in ''|'#'*) continue ;; esac
    case "$path" in crates/*|README.md|AGENTS.md|TOKO-TOOLING.md|.github/*|scripts/*|ci/*|make/*|vendor/*) exit 1 ;; esac
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
printf 'exit 41;\n' > vendor/toko-tooling/scripts/ci/classify-ci-change.pl
: > "$fixture/output"
if CI_EVENT=push CI_REF=refs/heads/main CI_BASE="$base" CI_HEAD="$docs" \
    GITHUB_OUTPUT="$fixture/output" bash "$fixture/select-step.sh"; then exit 1; fi
[[ ! -s "$fixture/output" ]]
fixture_complete=true
printf 'Actual CI selector: prose, code, mixed, policy, missing history and failure passed.\n'
