#!/usr/bin/env bash
set -euo pipefail
qualify=false
if [[ "${1:-}" == --qualify && $# == 1 ]]; then qualify=true; elif [[ $# != 0 ]]; then exit 2; fi
# Real consumer selector/receipts and Shared runner; substitute only Make effects.
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES RELEASE_COMMIT
unset OBSERVABILITY_RELEASE_VALIDATION_SCOPE OBSERVABILITY_RELEASE_VALIDATION_ATTEMPT
unset VALIDATION_REPOSITORY_ROOT VALIDATION_RUNNER_SNAPSHOT_PATH VALIDATION_LOG_DIR
unset VALIDATION_INPUT_ROOT VALIDATION_INPUT_BASELINE GITHUB_STEP_SUMMARY
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
export PATH="$root/.tools/host/bin:$PATH"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
# shellcheck source=scripts/ci/release-receipts.sh
source "$root/scripts/ci/release-receipts.sh"
mkdir -p "$root/target/qualification"
fixture="$(fixture_create "$root/target/qualification/release-validation.XXXXXX")"
fixture_complete=false
trap 'fixture_finish "$?" "$fixture" "Release validation qualification retained"' EXIT
mkdir "$fixture/repo"
bash "$root/scripts/ci/prepare-script-fixture.sh" "$root" "$fixture/repo" \
    make/validation.mk scripts/release/validation.pl \
    ci/release-validation.json ci/cargo-release-groups.json scripts/ci/check-pipe-jobserver.pl
cd "$fixture/repo"
# Exercise the actual consumer CI entry and roster without product compilation.
cat > Makefile <<'MAKE'
include make/validation.mk
.PHONY: ci $(shell jq -r '.stages[]' ci/release-validation.json)
$(shell jq -r '.stages[]' ci/release-validation.json):
	+@if test "$${REQUIRE_JOBSERVER:-0}" = 1 && test '$@' = compiler-check; then perl scripts/ci/check-pipe-jobserver.pl; fi
	@printf '%s\t%s\n' '$@' "$${OBSERVABILITY_RELEASE_VALIDATION_SCOPE:-workspace}" >> .git/commands
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
git tag -am baseline metrics-v0.1.0
git tag -am baseline logging-v0.1.0
export RELEASE_PREVIOUS=0.1.0
select_plan() {
    attempt="target/release-validation/$1"
    RELEASE_SOURCE="$(git rev-parse HEAD)"
    export RELEASE_SOURCE
    perl scripts/release/validation.pl select "$attempt" > "$fixture/$1-selection.log" 2>&1
}
run_plan() {
    OBSERVABILITY_RELEASE_VALIDATION_SCOPE="$(jq -r .scope "$attempt/plan.json")" \
        VALIDATION_LOG_DIR="$attempt/logs" VALIDATION_FAILURE_LOG_DIR="$fixture/failures" \
        bash scripts/ci/run-validation-targets.sh --plan "$attempt/plan.json" > "$fixture/${attempt##*/}-run.log" 2>&1
}
refuse() {
    if "$@" > "$fixture/refusal.log" 2>&1; then echo "unexpected acceptance: $*" >&2; exit 1; fi
}
seal() {
    release_receipt_write "$attempt/proof.json" perl scripts/release/validation.pl seal "$attempt"
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
    # An unrelated failure cannot block this group. All selected stages still run.
    export FAIL_TARGET="$other-profiles-check"
    run_plan
    unset FAIL_TARGET
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
    export FAIL_TARGET="$group-profiles-check"
    refuse run_plan
    unset FAIL_TARGET
    refuse perl scripts/release/validation.pl seal "$attempt"
done
export RELEASE_GROUP=metrics
git reset -q --hard "$baseline"
printf 'shared lock change\n' >> Cargo.lock
git add Cargo.lock; git commit -qm shared
select_plan shared
jq -e '.scope == "workspace" and all(.stages[]; .required)' "$attempt/plan.json" > /dev/null
if [[ "$qualify" == true ]]; then
    : > .git/commands
    run_plan
    cp .git/commands "$fixture/full-plan-commands"
    : > .git/commands
    parallel=(-j2)
    if make --help | grep -q -- --jobserver-style; then parallel+=(--jobserver-style=pipe); fi
    REQUIRE_JOBSERVER=1 make "${parallel[@]}" --no-print-directory ci \
        OBSERVABILITY_RELEASE_VALIDATION_SCOPE=group > "$fixture/ci.log" 2>&1
    cmp .git/commands "$fixture/full-plan-commands"
    refuse env OBSERVABILITY_RELEASE_VALIDATION_SCOPE=group bash scripts/ci/observability-ci.sh
    cmp .git/commands "$fixture/full-plan-commands"
    seal
    # Full CI stops at strict lint failure before expensive product stages.
    : > .git/commands
    export FAIL_TARGET=clippy
    refuse make --no-print-directory ci OBSERVABILITY_RELEASE_VALIDATION_SCOPE=group
    unset FAIL_TARGET
    tail -1 .git/commands > "$fixture/last-command"
    printf 'clippy\tworkspace\n' > "$fixture/last-expected"
    cmp "$fixture/last-command" "$fixture/last-expected"
fi
# Feature/manifests, another group and unknown paths also broaden scope.
for path in crates/ic-metrics/Cargo.toml crates/ic-logging/src/lib.rs unknown-input; do
    git reset -q --hard "$baseline"
    printf 'changed input\n' >> "$path"
    git add "$path"; git commit -qm "scope-$path"
    select_plan "scope-$(printf '%s' "$path" | tr '/.' '--')"
    jq -e '.scope == "workspace" and all(.stages[]; .required)' "$attempt/plan.json" > /dev/null
done
# Stale source, input drift and unknown product groups refuse.
select_plan drift
: > .git/commands
export DRIFT_TARGET=compiler-check
refuse run_plan
unset DRIFT_TARGET
printf 'compiler-check\tworkspace\n' > "$fixture/drift-expected"
cmp .git/commands "$fixture/drift-expected"
git restore crates/ic-metrics/src/lib.rs
refuse perl scripts/release/validation.pl seal "$attempt"
select_plan stale
git commit --allow-empty -qm moved
refuse run_plan
refuse env RELEASE_GROUP=unknown perl scripts/release/validation.pl select target/release-validation/unknown
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
# A missing baseline must broaden, including shallow checkout qualification.
git tag -d metrics-v0.1.0 > /dev/null
select_plan missing-baseline
jq -e '.scope == "workspace" and all(.stages[]; .required)' "$attempt/plan.json" > /dev/null
fixture_complete=true
printf 'Consumer group plans: mapping, shared evidence custody and recovery passed (matched comparison: %s).\n' "$qualify"
