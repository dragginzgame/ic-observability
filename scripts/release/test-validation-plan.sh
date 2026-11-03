#!/usr/bin/env bash
set -euo pipefail
# Real consumer selector/receipts and Shared runner; substitute only Make effects.
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES RELEASE_COMMIT
unset OBSERVABILITY_RELEASE_VALIDATION_SCOPE OBSERVABILITY_RELEASE_VALIDATION_ATTEMPT
unset VALIDATION_REPOSITORY_ROOT VALIDATION_RUNNER_SNAPSHOT_PATH VALIDATION_LOG_DIR
unset VALIDATION_INPUT_ROOT VALIDATION_INPUT_BASELINE GITHUB_STEP_SUMMARY
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
export PATH="$root/.tools/host/bin:$PATH"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
mkdir -p "$root/target/qualification"
fixture="$(fixture_create "$root/target/qualification/release-validation.XXXXXX")"
fixture_complete=false
trap 'fixture_finish "$?" "$fixture" "Release validation qualification retained"' EXIT
mkdir "$fixture/repo"
bash "$root/scripts/ci/prepare-script-fixture.sh" "$root" "$fixture/repo" \
    scripts/ci/run-validation-targets.sh scripts/release/validation.pl \
    ci/release-validation.json ci/cargo-release-groups.json
cd "$fixture/repo"
# Exercise the actual sequential CI recipe, without invoking the product suite.
perl -0777 -ne 'print "$1\n" if /^(ci:\n(?:\t[^\n]*\n)+)/m' "$root/Makefile" > Makefile
cat >> Makefile <<'MAKE'
.PHONY: ci $(shell jq -r '.stages[]' ci/release-validation.json)
$(shell jq -r '.stages[]' ci/release-validation.json):
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
    perl scripts/release/validation.pl seal "$attempt"
    perl scripts/release/validation.pl check "$attempt"
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
: > .git/commands
run_plan
cp .git/commands "$fixture/full-plan-commands"
: > .git/commands
make --no-print-directory ci OBSERVABILITY_RELEASE_VALIDATION_SCOPE=group > "$fixture/ci.log" 2>&1
cmp .git/commands "$fixture/full-plan-commands"
perl scripts/release/validation.pl seal "$attempt"
# Feature/manifests, another group and unknown paths also broaden scope.
for path in crates/ic-metrics/Cargo.toml crates/ic-logging/src/lib.rs unknown-input; do
    git reset -q --hard "$baseline"
    printf 'changed input\n' >> "$path"
    git add "$path"; git commit -qm "scope-$path"
    select_plan "scope-$(printf '%s' "$path" | tr '/.' '--')"
    jq -e '.scope == "workspace" and all(.stages[]; .required)' "$attempt/plan.json" > /dev/null
done
# Stale source, input drift, unknown groups and an unaccounted new gate refuse.
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
cp ci/release-validation.json "$fixture/policy"
jq -cS '.stages += ["new-unmapped-stage"]' "$fixture/policy" > ci/release-validation.json
refuse perl scripts/release/validation.pl select target/release-validation/new-stage
cp "$fixture/policy" ci/release-validation.json
cp Makefile "$fixture/makefile"
perl -0pi -e 's/ci:\n/ci:\n\t+\$\(MAKE\) unreviewed-stage\n/' Makefile
refuse perl scripts/release/validation.pl select target/release-validation/new-dispatch
cp "$fixture/makefile" Makefile
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
printf 'Consumer group plans: scope, full-CI equivalence, failures, drift and receipt recovery passed.\n'
