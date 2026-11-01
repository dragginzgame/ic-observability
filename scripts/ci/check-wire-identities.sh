#!/usr/bin/env bash
set -euo pipefail
# This integration workspace owns all source-less lock packages. Platform never
# participates in the root workspace's feature unification or arithmetic graph.
[[ $# == 0 || ( $# == 1 && ( "$1" == --prepare || "$1" == --update-lockfile ) ) ]] || exit 2
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
export PATH="$root/.tools/host/bin:$root/.tools/rust/common/bin:$PATH"
export RUSTUP_AUTO_INSTALL=0
mkdir -p "$root/target/qualification"
fixture="$(mktemp -d "$root/target/qualification/wire-identities.XXXXXX")"
printf 'Identity qualification retained: %s\n' "$fixture"
mkdir -p "$fixture/crates/ic-metrics" "$fixture/probe/src"
cp -R "$root/crates/ic-metrics/src" "$fixture/crates/ic-metrics/"
cp "$root/crates/ic-metrics/"{Cargo.toml,README.md,LICENSE} "$fixture/crates/ic-metrics/"
cp "$root/qualification/wire-identities/Cargo.toml.in" "$fixture/probe/Cargo.toml"
cp "$root/qualification/wire-identities/src/lib.rs" "$fixture/probe/src/"
export IDENTITY_CATALOG="$root/qualification/wire-identities/catalog.toml"
# Project the maintained root selections into the isolated fixture. Preserve
# their bytes rather than maintaining another copy of the Metrics/Wire catalog.
perl -pe '
  if (/^members = /) { $_ = "members = [\"crates/ic-metrics\", \"probe\"]\n"; $members++ }
  if (/^default-members = /) { $_ = "default-members = [\"probe\"]\n"; $defaults++ }
  if (/^ic-logging = /) { $_ = ""; $logging++ }
  if (/^ic-metrics = /) {
    s/version = "[^"]+"/version = "0.0.0"/ or die;
    s/ }$/, default-features = false }/ or die;
    $metrics++;
  }
  if (/^\[workspace.dependencies\]/) {
    print;
    open my $catalog, "<", $ENV{IDENTITY_CATALOG} or die;
    print while <$catalog>;
    close $catalog or die;
    $_ = "";
  }
  END { die "unexpected root manifest shape\n" unless $members == 1 && $defaults == 1 && $logging == 1 && $metrics == 1 }
' "$root/Cargo.toml" > "$fixture/Cargo.toml"
perl -pi -e 's/^version = "[^"]+"/version = "0.0.0"/' "$fixture/crates/ic-metrics/Cargo.toml"
if [[ -f "$root/qualification/wire-identities/Cargo.lock" ]]; then
    cp "$root/qualification/wire-identities/Cargo.lock" "$fixture/Cargo.lock"
else
    [[ "${1:-}" == --update-lockfile ]] || exit 2
    cp "$root/Cargo.lock" "$fixture/Cargo.lock"
fi
export CARGO_TARGET_DIR="$root/target/qualification/wire-identities-cargo"
minimum="$(bash "$root/scripts/ci/read-cargo-workspace-rust-version.sh" "$root/Cargo.toml")"
if [[ "${1:-}" == --update-lockfile ]]; then
    cargo "+$minimum" metadata --manifest-path "$fixture/Cargo.toml" --format-version 1 > "$fixture/metadata.json"
    cp "$fixture/Cargo.lock" "$root/qualification/wire-identities/Cargo.lock"
    exit
fi
if [[ "${1:-}" == --prepare ]]; then
    cargo "+$minimum" fetch --locked --manifest-path "$fixture/Cargo.toml"
    exit
fi
cargo "+$minimum" metadata --locked --offline --manifest-path "$fixture/Cargo.toml" --format-version 1 > "$fixture/metadata.json"
jq -e '
  [.packages[] | select(.name == "ic-wire")] | length == 1
' "$fixture/metadata.json" > /dev/null
jq -e '
  [.packages[] | select(.name == "ic-platform-types")] | length == 1
' "$fixture/metadata.json" > /dev/null
jq -e '
  . as $m | all(.packages[]; .source != null or (.id as $id | $m.workspace_members | index($id))) and
  all(.packages[]; .name != "ic-wire-endpoint" and .name != "ic-cdk" and .name != "ic0")
' "$fixture/metadata.json" > /dev/null
cargo clippy --locked --offline --manifest-path "$fixture/Cargo.toml" -p wire-identity-probe --lib --tests -- -D warnings
cargo "+$minimum" test --locked --offline --manifest-path "$fixture/Cargo.toml" -p wire-identity-probe --lib
cargo "+$minimum" check --locked --offline --manifest-path "$fixture/Cargo.toml" -p wire-identity-probe --target wasm32-unknown-unknown
