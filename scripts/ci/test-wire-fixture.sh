#!/usr/bin/env bash
set -euo pipefail
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
export PATH="$root/.tools/host/bin:$PATH"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
mkdir -p "$root/target/qualification"
fixture="$(fixture_create "$root/target/qualification/wire-render.XXXXXX")"
fixture_complete=false
trap 'fixture_finish "$?" "$fixture" "Wire renderer fixture retained"' EXIT
cat > "$fixture/root.toml" <<'TOML'
[workspace]
members = [
    "crates/ic-metrics",
    "crates/ic-logging",
]
resolver = "3"
[workspace.package]
edition = "2024"
rust-version = "1.99.1"
authors = ["A \"quoted\" author"]
[workspace.dependencies.ic-metrics]
path = "crates/ic-metrics"
version = "8.0.0"
[workspace.dependencies.ic-logging]
path = "crates/ic-logging"
version = "9.0.0"
[workspace.dependencies.ic-wire]
version = "1.0.0"
[workspace.dependencies.serde]
version = "1.0"
default-features = false
features = ["derive"]
TOML
cat > "$fixture/catalog.toml" <<'TOML'
ic-metrics = { version = "=7.0.0", default-features = false }
ic-logging = { version = "=6.0.0", default-features = false }
ic-wire = { version = "=2.0.0", default-features = false }
TOML
# Source catalog only supplies its integration; it must not replace source Metrics.
printf 'ic-platform-types = { version = "=2.0.0", default-features = false }\n' > "$fixture/source.toml"
for name in root catalog source; do yq -p toml -o json '.' "$fixture/$name.toml" > "$fixture/$name.json"; done
yq -p toml -o json '.' "$root/crates/ic-metrics/Cargo.toml" > "$fixture/metrics.json"
for mode in source published; do
    destination="$fixture/$mode"
    mkdir -p "$destination/crates/ic-metrics"
    catalog=catalog
    [[ "$mode" != source ]] || catalog=source
    perl "$root/scripts/ci/render-wire-fixture.pl" "$fixture/root.json" "$fixture/$catalog.json" "$fixture/metrics.json" "$destination" "$mode"
    yq -p toml -o json '.' "$destination/Cargo.toml" > "$destination/root.json"
    jq -e --slurpfile original "$fixture/root.json" '.workspace.package == $original[0].workspace.package and .workspace.dependencies.serde == $original[0].workspace.dependencies.serde' "$destination/root.json" > /dev/null
    if [[ "$mode" == source ]]; then
        jq -e '.workspace.members == ["crates/ic-metrics","probe"] and .workspace.dependencies["ic-metrics"].version == "0.0.0" and .workspace.dependencies["ic-metrics"].path == "crates/ic-metrics" and .workspace.dependencies["ic-logging"] == null and .workspace.dependencies["ic-wire"].version == "1.0.0"' "$destination/root.json" > /dev/null
        yq -p toml -o json '.' "$destination/crates/ic-metrics/Cargo.toml" > "$destination/metrics.json"
        jq -e --slurpfile original "$fixture/metrics.json" '. == ($original[0] | .package.version = "0.0.0")' "$destination/metrics.json" > /dev/null
    else
        jq -e '.workspace.members == ["probe"] and .workspace.dependencies["ic-metrics"].version == "=7.0.0" and .workspace.dependencies["ic-logging"].version == "=6.0.0" and .workspace.dependencies["ic-wire"].version == "=2.0.0"' "$destination/root.json" > /dev/null
    fi
done
mkdir -p "$fixture/collision/crates/ic-metrics"
# A source catalog must not silently replace a root-owned dependency selection.
if perl "$root/scripts/ci/render-wire-fixture.pl" "$fixture/root.json" "$fixture/catalog.json" "$fixture/metrics.json" "$fixture/collision" source > "$fixture/collision.log" 2>&1; then exit 1; fi
[[ ! -e "$fixture/collision/Cargo.toml" ]] || exit 1
fixture_complete=true
printf 'Wire fixture rendering preserves parsed fields and independent graph selection.\n'
