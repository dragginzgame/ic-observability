#!/usr/bin/env bash
set -euo pipefail
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
export PATH="$root/.tools/host/bin:$PATH"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
mkdir -p "$root/target/qualification"
fixture="$(fixture_create "$root/target/qualification/retained-consumer.XXXXXX")"
fixture_complete=false
trap 'fixture_finish "$?" "$fixture" "Retained consumer fixture retained"' EXIT
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
rust-version = "1.100.0"
authors = ["A \"quoted\" author"]
[workspace.dependencies.ic-metrics]
path = "crates/ic-metrics"
version = "8.0.0"
[workspace.dependencies.ic-logging]
path = "crates/ic-logging"
version = "9.0.0"
[workspace.dependencies.serde]
version = "1.0"
default-features = false
features = ["derive"]
TOML
yq -p toml -o json '.' "$fixture/root.toml" > "$fixture/root.json"
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
fixture_complete=true
printf 'Retained-consumer rendering preserves parsed fields and independent identities.\n'
