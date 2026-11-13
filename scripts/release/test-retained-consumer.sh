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
[workspace.dependencies.serde]
version = "1.0"
default-features = false
features = ["derive"]
[workspace.dependencies.oracle]
version = "1.0"
[workspace.dependencies.unrelated]
version = "1.0"
TOML
yq -p toml -o json '.' "$fixture/root.toml" > "$fixture/root.json"
printf '%s\n' '{"dev-dependencies":{"serde":{"workspace":true}},"target":{"cfg(unix)":{"build-dependencies":{"oracle":{"workspace":true}}}}}' > "$fixture/supplier.json"
for supplier in metrics logging; do
    destination="$fixture/retained-$supplier"
    mkdir -p "$destination"
    case "$supplier" in metrics) version=8.0.0 ;; logging) version=9.0.0 ;; esac
    perl "$root/scripts/release/render-retained-consumer.pl" "$fixture/root.json" \
        "$fixture/supplier.json" "$destination/Cargo.toml" "$supplier" "$version"
    yq -p toml -o json '.' "$destination/Cargo.toml" > "$destination/root.json"
    # Preserve workspace metadata and actual inherited/target-specific suppliers;
    # unrelated catalog entries must not leak into this isolated consumer.
    jq -e --slurpfile original "$fixture/root.json" --arg supplier "ic-$supplier" --arg version "=$version" '
        . == ($original[0]
            | .workspace.members = ["supplier", "client"]
            | .workspace["default-members"] = ["client"]
            | .workspace.dependencies |= with_entries(select(.key == "serde" or .key == "oracle"))
            | .workspace.dependencies[$supplier] = {path: "supplier", version: $version, "default-features": false})
    ' "$destination/root.json" > /dev/null
done
fixture_complete=true
printf 'Retained-consumer rendering preserves parsed fields and independent identities.\n'
