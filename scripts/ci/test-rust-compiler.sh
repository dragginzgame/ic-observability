#!/usr/bin/env bash
set -euo pipefail
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES RUSTC MSRV
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
export PATH="$root/.tools/host/bin:$PATH"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
mkdir -p "$root/target/qualification"
fixture="$(fixture_create "$root/target/qualification/compiler-policy.XXXXXX")"
fixture_complete=false
trap 'fixture_finish "$?" "$fixture" "Compiler policy fixture retained"' EXIT
mkdir -p "$fixture/scripts/ci" "$fixture/bin" "$fixture/crates/ic-metrics" "$fixture/crates/ic-logging"
cp "$root/scripts/ci/"{check-rust-compiler.sh,read-cargo-workspace-rust-version.sh,check-allocation-free.sh,check-make-execution.sh} "$fixture/scripts/ci/"
pin="$(yq -p toml -o yaml -r '.toolchain.channel' "$root/rust-toolchain.toml")"
cat > "$fixture/bin/rustc" <<'RUSTC'
#!/usr/bin/env bash
printf 'rustc %s\nrelease: %s\n' "$TEST_RUSTC_VERSION" "$TEST_RUSTC_VERSION"
exit "$TEST_RUSTC_STATUS"
RUSTC
cat > "$fixture/bin/cargo" <<'CARGO'
#!/usr/bin/env bash
set -euo pipefail
if [[ "$*" == -vV ]]; then
    printf 'cargo %s\nrelease: %s\n' "$TEST_CARGO_VERSION" "$TEST_CARGO_VERSION"
    exit "$TEST_CARGO_STATUS"
fi
printf '%s\n' "$*" >> "$TEST_CARGO_EFFECTS"
[[ "$1" == rustc ]] || exit 99
[[ "$TEST_LINK_STATUS" == 0 ]] || exit "$TEST_LINK_STATUS"
printf 'fresh linked Wasm\n' > target/wasm32-unknown-unknown/debug/examples/arithmetic-no-allocator.wasm
CARGO
chmod +x "$fixture/bin/"{rustc,cargo}
export PATH="$fixture/bin:$PATH" TEST_CARGO_EFFECTS="$fixture/cargo-effects"
cd "$fixture"
reset_policy() {
    cp "$root/Cargo.toml" "$root/rust-toolchain.toml" .
    cp "$root/crates/ic-metrics/Cargo.toml" crates/ic-metrics/
    cp "$root/crates/ic-logging/Cargo.toml" crates/ic-logging/
    export TEST_RUSTC_VERSION="$pin" TEST_CARGO_VERSION="$pin"
    export TEST_RUSTC_STATUS=0 TEST_CARGO_STATUS=0 TEST_LINK_STATUS=0
    unset MSRV
    : > "$TEST_CARGO_EFFECTS"
}
for scenario in success floor-drift moving-pin nightly-pin member-override old-rustc newer-rustc old-cargo newer-cargo failed-rustc failed-cargo msrv-override; do
    reset_policy
    case "$scenario" in
        floor-drift) perl -pi -e 's/^rust-version = .*/rust-version = "1.0.0"/' Cargo.toml ;;
        moving-pin) perl -pi -e 's/^channel = .*/channel = "stable"/' rust-toolchain.toml ;;
        nightly-pin) perl -pi -e 's/^channel = .*/channel = "1.99.1-nightly"/' rust-toolchain.toml ;;
        member-override) perl -pi -e 's/^rust-version.workspace = true/rust-version = "1.0.0"/' crates/ic-logging/Cargo.toml ;;
        old-rustc) TEST_RUSTC_VERSION=1.0.0 ;;
        newer-rustc) TEST_RUSTC_VERSION=9.0.0 ;;
        old-cargo) TEST_CARGO_VERSION=1.0.0 ;;
        newer-cargo) TEST_CARGO_VERSION=9.0.0 ;;
        failed-rustc) TEST_RUSTC_STATUS=43 ;;
        failed-cargo) TEST_CARGO_STATUS=49 ;;
        msrv-override) export MSRV=stable ;;
    esac
    status=0
    bash scripts/ci/check-rust-compiler.sh > "$fixture/$scenario.log" 2>&1 || status=$?
    [[ ! -s "$TEST_CARGO_EFFECTS" ]] || exit 1
    case "$scenario" in
        success) [[ "$status" == 0 ]] || exit 1 ;;
        failed-rustc) [[ "$status" == 43 ]] || exit 1 ;;
        failed-cargo) [[ "$status" == 49 ]] || exit 1 ;;
        *) [[ "$status" != 0 ]] || exit 1 ;;
    esac
done
# Use the real link adapter: failure must never select an old target artifact;
# a later failure must preserve an earlier captured successful artifact.
reset_policy
mkdir -p target/wasm32-unknown-unknown/debug/examples
printf 'stale Wasm\n' > target/wasm32-unknown-unknown/debug/examples/arithmetic-no-allocator.wasm
export ALLOCATION_FREE_EVIDENCE_ROOT="$fixture/evidence" TEST_LINK_STATUS=47
status=0
bash scripts/ci/check-allocation-free.sh > failed-link.log 2>&1 || status=$?
[[ "$status" == 47 && ! -e "$ALLOCATION_FREE_EVIDENCE_ROOT/arithmetic-no-allocator.wasm" ]] || exit 1
TEST_LINK_STATUS=0
bash scripts/ci/check-allocation-free.sh > successful-link.log 2>&1
[[ "$(cat "$ALLOCATION_FREE_EVIDENCE_ROOT/arithmetic-no-allocator.wasm")" == 'fresh linked Wasm' ]] || exit 1
TEST_LINK_STATUS=47
status=0
bash scripts/ci/check-allocation-free.sh > later-failure.log 2>&1 || status=$?
[[ "$status" == 47 && "$(cat "$ALLOCATION_FREE_EVIDENCE_ROOT/arithmetic-no-allocator.wasm")" == 'fresh linked Wasm' ]] || exit 1
fixture_complete=true
printf 'Compiler admission and link custody passed\n'
