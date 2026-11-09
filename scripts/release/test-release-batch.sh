#!/usr/bin/env bash
set -euo pipefail
# Actual capture/setup, metadata, source proofs, native/Wasm lint, archives and
# publication admission/readback. Only the full gate roster and registry effects
# are substituted, against a disposable local Git remote.
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES RELEASE_COMMIT RELEASE_SOURCE RELEASE_VERSION
unset RELEASE_BATCH_ACTIVE RELEASE_GROUPS RELEASE_PUBLISH_TARGET RELEASE_SETUP_MODE
unset TOKO_TOOLING_ROOT OBSERVABILITY_RELEASE_VALIDATION_SCOPE OBSERVABILITY_RELEASE_VALIDATION_ATTEMPT
unset VALIDATION_REPOSITORY_ROOT VALIDATION_RUNNER_SNAPSHOT_PATH VALIDATION_LOG_DIR VALIDATION_FAILURE_LOG_DIR
unset VALIDATION_INPUT_ROOT VALIDATION_INPUT_BASELINE GITHUB_STEP_SUMMARY
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
export PATH="$root/.tools/host/bin:$root/.tools/rust/common/bin:$PATH"
source "$root/scripts/ci/fixture-lifecycle.sh"
mkdir -p "$root/target/qualification"
fixture="$(fixture_create "$root/target/qualification/release-batch-consumer.XXXXXX")"
fixture_complete=false
finish() {
    local status=$?
    if [[ "$status" != 0 ]]; then fixture_replay_logs "$fixture"/*.log; fi
    fixture_finish "$status" "$fixture" 'Release batch consumer qualification retained'
}
trap finish EXIT
mkdir -p "$fixture/repo" "$fixture/bin" "$fixture/registry"
(cd "$root" && git ls-files --cached --others --exclude-standard -z | while IFS= read -r -d '' path; do
    [[ ! -f "$path" ]] || printf '%s\0' "$path"
done | tar --null -T - -cf -) | tar -xf - -C "$fixture/repo"
export RELEASE_BATCH_FIXTURE="$fixture" RELEASE_BATCH_FIXTURE_REAL_CARGO="$(command -v cargo)"
export RELEASE_BATCH_FIXTURE_REAL_CURL="$(command -v curl)"
cat > "$fixture/bin/cargo" <<'CARGO'
#!/bin/bash
set -euo pipefail
[[ "${1:-}" == publish ]] || exec "$RELEASE_BATCH_FIXTURE_REAL_CARGO" "$@"
selection='' previous=''
for value in "$@"; do
    [[ "$previous" != --package ]] || selection="$value"
    previous="$value"
done
[[ -n "$selection" && "$selection" == *@* ]]
package="${selection%@*}" version="${selection##*@}"
"$RELEASE_BATCH_FIXTURE_REAL_CARGO" package --package "$selection" --locked --offline
archive="$PWD/target/package/$package-$version.crate"
checksum="$(bash scripts/ci/verify-file-checksum.sh --print sha256 "$archive")"
cp "$archive" "$RELEASE_BATCH_FIXTURE/registry/$package-$version.crate"
jq -n --arg package "$package" --arg version "$version" --arg checksum "$checksum" \
    '{version:{crate:$package,num:$version,checksum:$checksum,yanked:false}}' > "$RELEASE_BATCH_FIXTURE/registry/$package-$version.json"
printf '%s\n' "$selection" >> "$RELEASE_BATCH_FIXTURE/uploads"
# Model uncertain success after the registry accepted one upload. Recovery must
# independently read it back before acknowledging publication, never upload twice.
if [[ -f "$RELEASE_BATCH_FIXTURE/hold-upload" ]]; then rm "$RELEASE_BATCH_FIXTURE/hold-upload"; exit 37; fi
CARGO
cat > "$fixture/bin/curl" <<'CURL'
#!/bin/bash
set -euo pipefail
url='' output='' previous=''
for value in "$@"; do
    [[ "$previous" != --output && "$previous" != -o ]] || output="$value"
    case "$value" in https://crates.io/api/v1/crates/*|https://static.crates.io/crates/*) url="$value" ;; esac
    previous="$value"
done
[[ -n "$url" ]] || exec "$RELEASE_BATCH_FIXTURE_REAL_CURL" "$@"
case "$url" in
    https://crates.io/api/v1/crates/*)
        pair="${url#https://crates.io/api/v1/crates/}"
        package="${pair%/*}" version="${pair##*/}"
        file="$RELEASE_BATCH_FIXTURE/registry/$package-$version.json"
        if [[ -f "$file" ]]; then cp "$file" "$output"; printf 200
        else : > "$output"; printf 404; fi ;;
    https://static.crates.io/crates/*) cp "$RELEASE_BATCH_FIXTURE/registry/${url##*/}" "$output" ;;
esac
CURL
chmod +x "$fixture/bin/"{cargo,curl}
export PATH="$fixture/bin:$PATH"
cd "$fixture/repo"
# Package repository metadata and source retrieval both point to the local remote.
REPOSITORY="file://$fixture/remote.git" perl -pi -e 's{^repository = .*}{repository = "$ENV{REPOSITORY}"}' Cargo.toml
jq -cS '.stages=["compiler-check","clippy","package-check"]' ci/release-validation.json > "$fixture/policy.json"
cp "$fixture/policy.json" ci/release-validation.json
cat >> Makefile <<'MAKE'

# Qualification fault only; the owning metadata check still executes unchanged.
release-push-check:
	@bash scripts/release/metadata.sh check
	@if test ! -f "$$RELEASE_BATCH_FIXTURE/deferred-lock"; then \
	    printf '\n# deferred normal-checkout update\n' >> "$$RELEASE_BATCH_FIXTURE/repo/Cargo.lock"; \
	    cp "$$RELEASE_BATCH_FIXTURE/repo/Cargo.lock" "$$RELEASE_BATCH_FIXTURE/deferred-lock"; fi
	@test ! -f "$$RELEASE_BATCH_FIXTURE/hold-push"
MAKE
for group in metrics logging; do
    previous="$(RELEASE_GROUP="$group" bash scripts/release/metadata.sh version)"
    candidate="$(perl scripts/ci/validate-release-inputs.pl next-version "$previous" patch)"
    printf '# Changelog\n\n## [%s] - Unreleased\n\n- Qualification only.\n\n## [%s] - 2000-01-01\n\n- Baseline.\n' "$candidate" "$previous" > "releases/$group/CHANGELOG.md"
    printf '%s\n' "$candidate" > "$fixture/$group-version"
done
git init -q -b main
git config user.name 'Frozen qualification'
git config user.email fixture@example.invalid
git config core.hooksPath /dev/null
git add -- .
git commit -qm 'Disposable consumer baseline'
git init -q --bare "$fixture/remote.git"
git remote add origin "$fixture/remote.git"
git push -q -u origin main
base="$(git rev-parse HEAD)"
touch "$fixture/hold-push" "$fixture/hold-upload"
# Real outer automatic capture with the explicit affected roster; no copied
# tool selections. Both groups execute this repository's actual hooks.
if make release-patch RELEASE_GROUP=metrics RELEASE_GROUPS=metrics,logging \
    RELEASE_PUBLISH_TARGET=publish-verified > "$fixture/first.log" 2>&1; then exit 1; fi
intents=(.git/release-state/frozen/batch-*/intent.json)
[[ "${#intents[@]}" == 1 && -f "${intents[0]}" ]]
intent="${intents[0]}" batch="${intent%/intent.json}" batch="${batch##*/}"
[[ "$(jq -r .schema "$intent")" == 2 && "$(jq -r .phase "$intent")" == releasing ]]
work="$PWD/target/release-frozen/$batch"
[[ -f "$work/.tools/host/bin/jq" && -d "$work/.tools/rust/common" ]]
[[ "$(git rev-parse HEAD)" == "$base" ]]
cmp Cargo.lock "$fixture/deferred-lock"
# Partially prepared candidate metadata cannot cause a recovery installation.
mv "$work/.tools" "$work/target/saved-tools"
if make release-batch-resume RELEASE_GROUP=metrics BATCH="$batch" > "$fixture/missing-tools.log" 2>&1; then exit 1; fi
grep -Fq 'Release candidate setup: check' "$fixture/missing-tools.log"
[[ ! -e "$work/.tools" ]]
mv "$work/target/saved-tools" "$work/.tools"
rm "$fixture/hold-push"
if make release-batch-resume RELEASE_GROUP=metrics BATCH="$batch" > "$fixture/upload-uncertain.log" 2>&1; then exit 1; fi
[[ "$(jq -r .phase "$intent")" == publishing && "$(wc -l < "$fixture/uploads")" == 1 ]]
# The saved publication identity must be the actual released tag, never inferred
# from whichever HEAD a later recovery happens to observe.
recorded_commit="$(jq -er .release_commit "$intent")"
[[ "$recorded_commit" == "$(git -C "$work" rev-parse "metrics-v$(cat "$fixture/metrics-version")^{commit}")" ]]
make -C "$work" verify-publication RELEASE_GROUP=metrics > "$fixture/metrics-readback.log" 2>&1
make release-batch-resume RELEASE_GROUP=metrics BATCH="$batch" PUBLICATION_RESULT=published > "$fixture/resume.log" 2>&1
[[ "$(jq -r .phase "$intent")" == complete ]]
[[ "$(git rev-parse HEAD)" == "$base" ]]
cmp Cargo.lock "$fixture/deferred-lock"
printf 'ic-metrics@%s\nic-logging@%s\n' "$(cat "$fixture/metrics-version")" "$(cat "$fixture/logging-version")" > "$fixture/expected-uploads"
cmp "$fixture/expected-uploads" "$fixture/uploads"
make release-batch-status BATCH="$batch" > "$fixture/status.log" 2>&1
make release-batch-resume RELEASE_GROUP=metrics BATCH="$batch" > "$fixture/complete-resume.log" 2>&1
cmp "$fixture/expected-uploads" "$fixture/uploads"
make -C "$work" verify-publication RELEASE_GROUP=logging > "$fixture/logging-readback.log" 2>&1
# Deferred work must survive an attempted reconciliation. Preserve it on its
# own durable fixture branch before explicitly reconciling the clean base.
if make release-batch-reconcile BATCH="$batch" > "$fixture/dirty-reconcile.log" 2>&1; then exit 1; fi
cmp Cargo.lock "$fixture/deferred-lock"
git switch -qc deferred-update
git add -- Cargo.lock
git commit -qm 'Preserved deferred fixture lock update'
git switch -q main
make release-batch-reconcile BATCH="$batch" > "$fixture/reconcile.log" 2>&1
[[ "$(git rev-parse HEAD)" == "$(jq -r .commit "$intent")" ]]
git show deferred-update:Cargo.lock > "$fixture/preserved-deferred-lock"
cmp "$fixture/preserved-deferred-lock" "$fixture/deferred-lock"
# Preserve this qualification's receipts before exercising explicit retirement
# of its completed disposable candidate. No real deployment state is selected.
cp -R "$work/target/publication" "$fixture/publication"
cp -R "$work/target/release-validation" "$fixture/validation"
make release-batch-retire BATCH="$batch" > "$fixture/retire.log" 2>&1
[[ ! -e "$work" && ! -e ".git/release-state/frozen/$batch" ]]
for group in metrics logging; do
    version="$(cat "$fixture/$group-version")"
    [[ "$(git cat-file -t "$group-v$version")" == tag ]]
    [[ "$(git rev-parse "$group-v$version^{commit}")" == "$(git --git-dir="$fixture/remote.git" rev-parse "$group-v$version^{commit}")" ]]
done
fixture_complete=true
printf 'Release batch consumer capture, real setup/lint/archives/readback, offline resume, deferred lock custody and explicit reconcile/retire passed (local Git/registry effects only).\n'
