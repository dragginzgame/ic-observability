#!/usr/bin/env bash
set -euo pipefail
# Both qualification workspaces own all source-less lock packages. Platform
# never participates in the arithmetic workspace's feature unification.
published=false
expected_version=''
if [[ "${1:-}" == --published ]]; then
    [[ $# -ge 2 && -n "$2" ]] || { echo 'Select --published EXPECTED_METRICS_VERSION explicitly' >&2; exit 2; }
    published=true
    expected_version="$2"
    shift 2
fi
[[ $# == 0 || ( $# == 1 && ( "$1" == --prepare || "$1" == --update-lockfile ) ) ]] || exit 2
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
export PATH="$root/.tools/host/bin:$root/.tools/rust/common/bin:$PATH"
export RUSTUP_AUTO_INSTALL=0
if [[ "$published" == true ]]; then
    perl "$root/scripts/ci/validate-release-inputs.pl" version "$expected_version" > /dev/null
    selected_version="$(yq -p toml -o json -r '.["ic-metrics"].version' "$root/qualification/wire-published/catalog.toml")"
    [[ "$selected_version" == "=$expected_version" ]] || {
        echo "Registry consumer catalog selects $selected_version; expected =$expected_version. Update its catalog and lock deliberately." >&2
        exit 2
    }
fi
mkdir -p "$root/target/qualification"
qualification=wire-identities
[[ "$published" != true ]] || qualification=wire-published
fixture="$(mktemp -d "$root/target/qualification/$qualification.XXXXXX")"
printf 'Identity qualification retained: %s\n' "$fixture"
if [[ "$published" == true ]]; then printf 'ic-metrics@%s\n' "$expected_version" > "$fixture/expected-package"; fi
mkdir -p "$fixture/probe/src"
if [[ "$published" != true ]]; then
    mkdir -p "$fixture/crates/ic-metrics"
    cp -R "$root/crates/ic-metrics/src" "$fixture/crates/ic-metrics/"
    cp "$root/crates/ic-metrics/"{Cargo.toml,README.md,LICENSE} "$fixture/crates/ic-metrics/"
fi
cp "$root/qualification/wire-identities/Cargo.toml.in" "$fixture/probe/Cargo.toml"
cp "$root/qualification/wire-identities/src/lib.rs" "$fixture/probe/src/"
export IDENTITY_CATALOG="$root/qualification/wire-identities/catalog.toml"
export IDENTITY_PUBLISHED="$published" IDENTITY_REGISTRY_CATALOG="$root/qualification/wire-published/catalog.toml"
# Project the maintained root selections into the isolated fixture. Preserve
# their bytes rather than maintaining another copy of the Metrics/Wire catalog.
perl -pe '
  if (/^members = /) {
    $_ = $ENV{IDENTITY_PUBLISHED} eq "true" ? "members = [\"probe\"]\n" : "members = [\"crates/ic-metrics\", \"probe\"]\n";
    $members++;
  }
  if (/^default-members = /) { $_ = "default-members = [\"probe\"]\n"; $defaults++ }
  if (/^ic-logging = /) { $_ = ""; $logging++ }
  if (/^ic-metrics = /) {
    if ($ENV{IDENTITY_PUBLISHED} eq "true") {
      open my $catalog, "<", $ENV{IDENTITY_REGISTRY_CATALOG} or die;
      local $/; $_ = <$catalog>;
      close $catalog or die;
    } else {
      s/version = "[^"]+"/version = "0.0.0"/ or die;
      s/ }$/, default-features = false }/ or die;
    }
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
if [[ "$published" != true ]]; then
    perl -pi -e 's/^version = "[^"]+"/version = "0.0.0"/' "$fixture/crates/ic-metrics/Cargo.toml"
fi
if [[ -f "$root/qualification/$qualification/Cargo.lock" ]]; then
    cp "$root/qualification/$qualification/Cargo.lock" "$fixture/Cargo.lock"
else
    [[ "${1:-}" == --update-lockfile ]] || exit 2
    cp "$root/Cargo.lock" "$fixture/Cargo.lock"
fi
export CARGO_TARGET_DIR="$root/target/qualification/$qualification-cargo"
minimum="$(bash "$root/scripts/ci/read-cargo-workspace-rust-version.sh" "$root/Cargo.toml")"
if [[ "${1:-}" == --update-lockfile ]]; then
    cargo "+$minimum" metadata --manifest-path "$fixture/Cargo.toml" --format-version 1 > "$fixture/metadata.json"
    cp "$fixture/Cargo.lock" "$root/qualification/$qualification/Cargo.lock"
    exit
fi
if [[ "${1:-}" == --prepare ]]; then
    cargo "+$minimum" fetch --locked --manifest-path "$fixture/Cargo.toml"
    exit
fi
cargo "+$minimum" metadata --locked --offline --manifest-path "$fixture/Cargo.toml" --format-version 1 > "$fixture/metadata.json"
if [[ "$published" == true ]]; then
    jq -e --arg version "$expected_version" '
      ([.packages[] | select(.name == "ic-metrics")] | length == 1 and
        all(.[]; .version == $version and (.source | startswith("registry+")))) and
      (.workspace_members | length == 1)
    ' "$fixture/metadata.json" > /dev/null
fi
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
if [[ "$published" == true ]]; then printf 'Registry consumer accepted: ic-metrics@%s\n' "$expected_version"; fi
