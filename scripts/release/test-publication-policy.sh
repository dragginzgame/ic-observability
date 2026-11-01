#!/usr/bin/env bash
set -euo pipefail
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
export PATH="$root/.tools/host/bin:$PATH"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
mkdir -p "$root/target/qualification"
fixture="$(fixture_create "$root/target/qualification/publication-policy.XXXXXX")"
fixture_complete=false
trap 'fixture_finish "$?" "$fixture" "Publication policy fixture retained"' EXIT
mkdir -p "$fixture/repo/scripts/"{release,ci} "$fixture/bin" "$fixture/archive/ic-metrics-0.1.0"
cp "$root/scripts/release/publication.sh" "$fixture/repo/scripts/release/"
cp "$root/scripts/ci/"{check-crates-io-version.sh,check-cargo-package-provenance.sh,verify-file-checksum.sh} "$fixture/repo/scripts/ci/"
cd "$fixture/repo"
printf '/target/\n' > .gitignore
printf '[workspace.package]\nrepository = "%s/remote.git"\n' "$fixture" > Cargo.toml
cat > scripts/release/metadata.sh <<'PLAN'
#!/usr/bin/env bash
set -euo pipefail
[[ "$1" == plan && "$RELEASE_GROUP" == metrics ]] || exit 2
printf '%s\n' '{"primary":"ic-metrics","previous":"0.1.0","dependencies":[{"package":"ic-metrics","path":"crates/ic-metrics"}]}'
PLAN
git init -q
git config user.email fixture@example.invalid
git config user.name Fixture
git add .
git commit -qm baseline
export RELEASE_GROUP=metrics OBSERVABILITY_PUBLICATION_MODE=check
bash scripts/release/publication.sh admit
export OBSERVABILITY_PUBLICATION_MODE=publish
if bash scripts/release/publication.sh admit > "$fixture/untagged.log" 2>&1; then exit 1; fi
git tag -a metrics-v0.1.0 -m release
source="$(git rev-parse HEAD)"
git init -q --bare "$fixture/remote.git"
if bash scripts/release/publication.sh admit > "$fixture/missing-remote-tag.log" 2>&1; then exit 1; fi
git push -q "$fixture/remote.git" HEAD:main refs/tags/metrics-v0.1.0
bash scripts/release/publication.sh admit
printf 'dirty\n' > dirty
if bash scripts/release/publication.sh admit > "$fixture/dirty.log" 2>&1; then exit 1; fi
git add dirty
if bash scripts/release/publication.sh admit > "$fixture/staged.log" 2>&1; then exit 1; fi
git commit -qm later
if bash scripts/release/publication.sh admit > "$fixture/later.log" 2>&1; then exit 1; fi
# Independent post-upload readback binds the tag, even after later repository work.
git push -q "$fixture/remote.git" HEAD:main refs/tags/metrics-v0.1.0
jq -n --arg source "$source" '{git:{sha1:$source,dirty:false},path_in_vcs:"crates/ic-metrics"}' \
    > "$fixture/archive/ic-metrics-0.1.0/.cargo_vcs_info.json"
tar -czf "$fixture/valid.crate" -C "$fixture/archive" ic-metrics-0.1.0
checksum="$(bash scripts/ci/verify-file-checksum.sh --print sha256 "$fixture/valid.crate")"
jq -n --arg checksum "$checksum" '{version:{crate:"ic-metrics",num:"0.1.0",checksum:$checksum,yanked:false}}' > "$fixture/registry.json"
cat > "$fixture/bin/curl" <<'CURL'
#!/usr/bin/env bash
set -euo pipefail
[[ "$*" != '--disable --version' ]] || { printf 'curl 8.10.1 fixture\n'; exit; }
output='' previous='' api=false
for value in "$@"; do
    if [[ "$previous" == --output || "$previous" == -o ]]; then output="$value"; fi
    [[ "$value" != https://crates.io/api/* ]] || api=true
    previous="$value"
done
if [[ "$api" == true ]]; then
    cp "$PUBLICATION_FIXTURE/registry.json" "$output"
    printf '%s' "${FIXTURE_REGISTRY_STATUS:-200}"
else
    if [[ "${FIXTURE_BAD_ARCHIVE:-0}" == 1 ]]; then printf 'corrupt\n' > "$output"
    else cp "$PUBLICATION_FIXTURE/valid.crate" "$output"; fi
fi
CURL
chmod +x "$fixture/bin/curl"
export PATH="$fixture/bin:$PATH" PUBLICATION_FIXTURE="$fixture"
bash scripts/release/publication.sh verify > "$fixture/success.log" 2>&1
find target/publication -name verified -type f | read -r _
for status in 403 404; do
    result=0
    FIXTURE_REGISTRY_STATUS="$status" bash scripts/release/publication.sh verify > "$fixture/status-$status.log" 2>&1 || result=$?
    if [[ "$status" == 403 ]]; then [[ "$result" == 2 ]]; else [[ "$result" == 1 ]]; fi
done
if FIXTURE_BAD_ARCHIVE=1 bash scripts/release/publication.sh verify > "$fixture/corrupt.log" 2>&1; then exit 1; fi
jq '.version.yanked = true' "$fixture/registry.json" > "$fixture/yanked.json"
cp "$fixture/yanked.json" "$fixture/registry.json"
if bash scripts/release/publication.sh verify > "$fixture/yanked.log" 2>&1; then exit 1; fi
fixture_complete=true
printf 'Publication policy: release tag, clean source, registry uncertainty, checksum and provenance passed; no uploads.\n'
