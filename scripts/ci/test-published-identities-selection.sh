#!/usr/bin/env bash
set -euo pipefail
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
export PATH="$root/.tools/host/bin:$root/.tools/rust/common/bin:$PATH"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
mkdir -p "$root/target/qualification"
fixture="$(fixture_create "$root/target/qualification/published-selection.XXXXXX")"
fixture_complete=false
trap 'fixture_finish "$?" "$fixture" "Published selection fixture retained"' EXIT
mkdir "$fixture/bin"
cat > "$fixture/bin/cargo" <<'CARGO'
#!/usr/bin/env bash
printf 'unexpected Cargo effect\n' >> "$PUBLISHED_SELECTION_EVENTS"
exit 97
CARGO
chmod +x "$fixture/bin/cargo"
export PUBLISHED_SELECTION_EVENTS="$fixture/cargo-events" PATH="$fixture/bin:$PATH"
selected="$(yq -p toml -o json -r '.["ic-metrics"].version' "$root/qualification/wire-published/catalog.toml")"
other="$(perl "$root/scripts/ci/validate-release-inputs.pl" next-version "${selected#=}" patch)"
index=0
for expected in '' "$other" not-a-version; do
    status=0
    make --no-print-directory -C "$root" published-identities-check \
        "EXPECTED_METRICS_VERSION=$expected" > "$fixture/case-$index.log" 2>&1 || status=$?
    [[ "$status" != 0 && ! -e "$PUBLISHED_SELECTION_EVENTS" ]]
    index=$((index + 1))
done
fixture_complete=true
printf 'Published identity selection rejects absent, malformed and stale intent before Cargo effects.\n'
