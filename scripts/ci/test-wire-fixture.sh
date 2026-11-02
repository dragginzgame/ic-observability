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
default-members = [
    "crates/ic-metrics",
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
    metrics_input=()
    if [[ "$mode" == source ]]; then catalog=source; metrics_input=("$fixture/metrics.json"); fi
    perl "$root/scripts/ci/render-wire-fixture.pl" "$fixture/root.json" "$fixture/$catalog.json" \
        "$destination" "$mode" ${metrics_input[@]+"${metrics_input[@]}"}
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
for supplier in metrics logging; do
    destination="$fixture/retained-$supplier"
    mkdir -p "$destination"
    version="$(jq -er --arg supplier "ic-$supplier" '.workspace.dependencies[$supplier].version' "$fixture/root.json")"
    perl "$root/scripts/release/render-retained-consumer.pl" "$fixture/root.json" \
        "$destination/Cargo.toml" "$supplier" "$version"
    yq -p toml -o json '.' "$destination/Cargo.toml" > "$destination/root.json"
    # Independent parsed comparison covers metadata, external aliases and the
    # real retained identity, including both multiline member arrays.
    jq -e --slurpfile original "$fixture/root.json" --arg supplier "ic-$supplier" --arg version "=$version" '
        . == ($original[0]
            | .workspace.members = ["supplier", "client"]
            | .workspace["default-members"] = ["client"]
            | del(.workspace.dependencies["ic-metrics"], .workspace.dependencies["ic-logging"])
            | .workspace.dependencies[$supplier] = {path: "supplier", version: $version, "default-features": false})
    ' "$destination/root.json" > /dev/null
done
mkdir -p "$fixture/collision/crates/ic-metrics"
# A source catalog must not silently replace a root-owned dependency selection.
if perl "$root/scripts/ci/render-wire-fixture.pl" "$fixture/root.json" "$fixture/catalog.json" "$fixture/collision" source "$fixture/metrics.json" > "$fixture/collision.log" 2>&1; then exit 1; fi
[[ ! -e "$fixture/collision/Cargo.toml" ]] || exit 1
fixture_complete=true
printf 'Wire and retained-consumer rendering preserve parsed fields and independent identities.\n'
