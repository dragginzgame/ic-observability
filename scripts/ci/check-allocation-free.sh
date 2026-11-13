#!/usr/bin/env bash
# Shared companions: scripts/ci/check-rust-compiler.sh vendor/toko-tooling/scripts/ci/check-make-execution.sh
set -euo pipefail
# Validation only. Cargo uses this repository's target directory and locked graph.
[[ $# == 0 ]] || { echo 'usage: check-allocation-free.sh' >&2; exit 2; }
bash scripts/ci/check-rust-compiler.sh
bash vendor/toko-tooling/scripts/ci/check-make-execution.sh
export RUSTUP_AUTO_INSTALL=0 CARGO_NET_OFFLINE=true CARGO_TARGET_DIR="$PWD/target"
# --export-all and link-dead-code retain the runtime-input arithmetic entrypoint.
# No global allocator or std is supplied by the fixture. This must link, not check.
cargo rustc -p ic-metrics --example arithmetic-no-allocator \
    --no-default-features --locked --offline --target wasm32-unknown-unknown \
    -- -C panic=abort -C link-dead-code=yes -C link-arg=--no-entry -C link-arg=--export-all
# Capture only a successfully linked artifact, before any later compiler gate fails.
if [[ -n "${ALLOCATION_FREE_EVIDENCE_ROOT:-}" ]]; then
    mkdir -p "$ALLOCATION_FREE_EVIDENCE_ROOT"
    (set -C; cat target/wasm32-unknown-unknown/debug/examples/arithmetic-no-allocator.wasm \
        > "$ALLOCATION_FREE_EVIDENCE_ROOT/arithmetic-no-allocator.wasm")
fi
