#!/usr/bin/env bash
set -euo pipefail
[[ $# == 0 ]] || exit 2
# Real consumer selector/receipts and Shared runner; substitute only Make effects.
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES RELEASE_COMMIT
unset OBSERVABILITY_RELEASE_VALIDATION_SCOPE OBSERVABILITY_RELEASE_VALIDATION_ATTEMPT
unset VALIDATION_REPOSITORY_ROOT VALIDATION_RUNNER_SNAPSHOT_PATH VALIDATION_LOG_DIR
unset VALIDATION_INPUT_ROOT VALIDATION_INPUT_BASELINE GITHUB_STEP_SUMMARY
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
export PATH="$root/.tools/host/bin:$PATH"
# shellcheck source=vendor/toko-tooling/scripts/ci/fixture-lifecycle.sh
source "$root/vendor/toko-tooling/scripts/ci/fixture-lifecycle.sh"
# shellcheck source=vendor/toko-tooling/scripts/ci/release-receipts.sh
source "$root/vendor/toko-tooling/scripts/ci/release-receipts.sh"
mkdir -p "$root/target/qualification"
fixture="$(fixture_create "$root/target/qualification/release-validation.XXXXXX")"
fixture_complete=false
trap 'fixture_finish "$?" "$fixture" "Release validation qualification retained"' EXIT
mkdir "$fixture/repo"
bash "$root/vendor/toko-tooling/scripts/ci/prepare-script-fixture.sh" "$root" "$fixture/repo" \
    make/validation.mk scripts/release/validation.pl \
    ci/release-validation.json ci/cargo-release-groups.json
cd "$fixture/repo"
# Exercise the actual consumer CI entry and roster without product compilation.
cat > Makefile <<'MAKE'
include make/validation.mk
.PHONY: ci package-check $(shell jq -r '.stages[]' ci/release-validation.json)
package-check $(shell jq -r '.stages[]' ci/release-validation.json):
	@printf '%s\t%s\n' '$@' "$${OBSERVABILITY_RELEASE_VALIDATION_SCOPE:-workspace}" >> .git/commands
	@printf '%s\n' "$${TMPDIR:-}" >> .git/scratch-roots
	@test "$${FAIL_TARGET:-}" != '$@'
	@if test "$${DRIFT_TARGET:-}" = '$@'; then printf 'drift\n' >> crates/ic-metrics/src/lib.rs; fi
MAKE
mkdir -p crates/ic-metrics/src crates/ic-logging/src releases/metrics releases/logging
for group in metrics logging; do
    printf '%s baseline\n' "$group" > "crates/ic-$group/src/lib.rs"
    printf 'version = "0.1.0"\n' > "crates/ic-$group/Cargo.toml"
    printf 'baseline\n' > "releases/$group/CHANGELOG.md"
done
printf 'lock baseline\n' > Cargo.lock
printf '/target/\n' > .gitignore
git init -q -b main
git config user.name Fixture
git config user.email fixture@example.invalid
git config core.hooksPath /dev/null
git add .
git commit -qm baseline
baseline="$(git rev-parse HEAD)"
export RELEASE_PREVIOUS=0.1.0
select_plan() {
    attempt="target/release-validation/$1"
    RELEASE_SOURCE="$(git rev-parse HEAD)"
    export RELEASE_SOURCE
    perl scripts/release/validation.pl select "$attempt" > "$fixture/$1-selection.log" 2>&1
}
run_plan() {
    VALIDATION_REPOSITORY_ROOT="$PWD" OBSERVABILITY_RELEASE_VALIDATION_SCOPE="$(jq -r .scope "$attempt/plan.json")" \
        VALIDATION_LOG_DIR="$attempt/logs" VALIDATION_FAILURE_LOG_DIR="$fixture/failures" \
        bash vendor/toko-tooling/scripts/ci/run-validation-targets.sh --plan "$attempt/plan.json" > "$fixture/${attempt##*/}-run.log" 2>&1
}
refuse() {
    if "$@" > "$fixture/refusal.log" 2>&1; then echo "unexpected acceptance: $*" >&2; exit 1; fi
}
seal() {
    release_receipt_write "$attempt/proof.json" perl scripts/release/validation.pl seal "$attempt"
    # Retain comparable successful dispatch counts/timings in the caller's log.
    # These are substituted Make effects, not product build latency.
    awk -F '\t' -v name="${attempt##*/}" 'NR > 1 { count++; seconds += $3 }
        END { printf "dispatch %s: %d stages, %d runner seconds (substitutes)\n", name, count, seconds }' \
        "$attempt"/logs/validation.*/timings.tsv
}
for group in metrics logging; do
    export RELEASE_GROUP="$group"
    other=metrics; [[ "$group" != metrics ]] || other=logging
    git reset -q --hard "$baseline"
    printf 'selected implementation\n' >> "crates/ic-$group/src/lib.rs"
    git add .; git commit -qm "$group-only"
    select_plan "$group"
    jq -e --arg group "$group" '.scope == "group" and .group == $group' "$attempt/plan.json" > /dev/null
    perl scripts/release/validation.pl admit "$attempt" group "$group"
    refuse perl scripts/release/validation.pl admit "$attempt" workspace "$group"
    refuse perl scripts/release/validation.pl admit "$attempt" group "$other"
    cp "crates/ic-$other/Cargo.toml" "$fixture/$group-other-manifest"
    cp "releases/$other/CHANGELOG.md" "$fixture/$group-other-ledger"
    run_plan
    seal
    perl scripts/release/validation.pl check "$attempt"
    if [[ "$group" == metrics ]]; then
        cp -R "$fixture/repo" "$fixture/relocated"
        if (cd "$fixture/relocated" && perl scripts/release/validation.pl check "$attempt") \
            > "$fixture/relocation.log" 2>&1; then exit 1; fi
    fi
    # Late admission retains sealed source evidence after allowed version edits.
    cp "crates/ic-$group/Cargo.toml" "$fixture/$group-original-manifest"
    cp Cargo.lock "$fixture/$group-original-lock"
    printf '\nprepared version metadata\n' >> "crates/ic-$group/Cargo.toml"
    printf '\nprepared lock metadata\n' >> Cargo.lock
    perl scripts/release/validation.pl check "$attempt"
    cp "$fixture/$group-original-manifest" "crates/ic-$group/Cargo.toml"
    cp "$fixture/$group-original-lock" Cargo.lock
    run="$(printf '%s\n' "$attempt"/logs/validation.*)"
    cp "$run/plan-events.tsv" "$fixture/events"
    printf 'interrupted\n' >> "$run/plan-events.tsv"
    refuse perl scripts/release/validation.pl check "$attempt"
    cp "$fixture/events" "$run/plan-events.tsv"
    cp "$run/0-after-inputs.json" "$fixture/observation"
    rm "$run/0-after-inputs.json"
    refuse perl scripts/release/validation.pl check "$attempt"
    cp "$fixture/observation" "$run/0-after-inputs.json"
    cp "$attempt/plan.json" "$fixture/plan"
    jq -cS '.scope="workspace"' "$fixture/plan" > "$attempt/plan.json"
    refuse perl scripts/release/validation.pl check "$attempt"
    cp "$fixture/plan" "$attempt/plan.json"
    # Exact same evidence recovers; compiler/configuration drift refuses.
    refuse env RUSTFLAGS=--cfg=changed perl scripts/release/validation.pl check "$attempt"
    perl scripts/release/validation.pl check "$attempt"
    cmp "crates/ic-$other/Cargo.toml" "$fixture/$group-other-manifest"
    cmp "releases/$other/CHANGELOG.md" "$fixture/$group-other-ledger"
    select_plan "$group-failure"
    export FAIL_TARGET=product-check
    refuse run_plan
    unset FAIL_TARGET
    refuse perl scripts/release/validation.pl seal "$attempt"
done
export RELEASE_GROUP=metrics
git reset -q --hard "$baseline"
printf 'shared lock change\n' >> Cargo.lock
git add Cargo.lock; git commit -qm shared
select_plan shared
jq -e '.scope == "group" and all(.stages[]; .required)' "$attempt/plan.json" > /dev/null
run_plan
seal
# Full CI always selects both independent products, even with a release group in
# the environment. Archive verification follows the common/product stages.
: > .git/commands
make --no-print-directory ci OBSERVABILITY_RELEASE_VALIDATION_SCOPE=group > "$fixture/ci.log" 2>&1
printf 'source-check\tworkspace\nclippy\tworkspace\nproduct-check\tworkspace\npackage-check\tworkspace\n' > "$fixture/ci-expected"
cmp .git/commands "$fixture/ci-expected"
refuse env OBSERVABILITY_RELEASE_VALIDATION_SCOPE=group bash scripts/ci/observability-ci.sh
: > .git/commands
export FAIL_TARGET=clippy
refuse make --no-print-directory ci
unset FAIL_TARGET
printf 'source-check\tworkspace\nclippy\tworkspace\n' > "$fixture/failed-expected"
cmp .git/commands "$fixture/failed-expected"
# Stale source, input drift and unknown product groups refuse.
select_plan drift
: > .git/commands
export DRIFT_TARGET=source-check
refuse run_plan
unset DRIFT_TARGET
printf 'source-check\tgroup\n' > "$fixture/drift-expected"
cmp .git/commands "$fixture/drift-expected"
git restore crates/ic-metrics/src/lib.rs
refuse perl scripts/release/validation.pl seal "$attempt"
select_plan missing-input
mv crates/ic-metrics/src/lib.rs "$fixture/missing-source"
refuse run_plan
mv "$fixture/missing-source" crates/ic-metrics/src/lib.rs
refuse perl scripts/release/validation.pl seal "$attempt"
select_plan stale
git commit --allow-empty -qm moved
refuse run_plan
refuse env RELEASE_GROUP=unknown perl scripts/release/validation.pl select target/release-validation/unknown
refuse env -u RELEASE_GROUP perl scripts/release/validation.pl select target/release-validation/missing
# New stages have one owner and become required in the full and selected roster.
cp ci/release-validation.json "$fixture/policy"
jq -cS '.stages += ["new-common-stage"]' "$fixture/policy" > ci/release-validation.json
git add ci/release-validation.json; git commit -qm new-common-stage
select_plan new-stage
jq -e '.stages[-1] | .target == "new-common-stage" and .required' "$attempt/plan.json" > /dev/null
perl scripts/release/validation.pl roster > "$fixture/roster"
tail -1 "$fixture/roster" | grep -Fx new-common-stage
cp ci/cargo-release-groups.json "$fixture/groups"
jq '.groups += [{name:"new-group"}]' "$fixture/groups" > ci/cargo-release-groups.json
refuse perl scripts/release/validation.pl select target/release-validation/group-roster
cp "$fixture/groups" ci/cargo-release-groups.json
jq '(.groups[] | select(.name=="metrics").members) += ["another-member"]' "$fixture/groups" > ci/cargo-release-groups.json
refuse perl scripts/release/validation.pl select target/release-validation/new-member
cp "$fixture/groups" ci/cargo-release-groups.json
fixture_complete=true
printf 'Selected product plans: routing, shared evidence custody, fail-fast CI and recovery passed.\n'
