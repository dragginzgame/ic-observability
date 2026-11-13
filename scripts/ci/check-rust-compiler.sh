#!/usr/bin/env bash
# Shared companions: vendor/toko-tooling/scripts/ci/read-cargo-workspace-rust-version.sh
set -euo pipefail
# Consumer policy: one exact, prepared compiler for development and support.
[[ $# == 0 ]] || { echo 'usage: check-rust-compiler.sh' >&2; exit 2; }
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
cd "$root"
export PATH="$root/.tools/host/bin:$PATH" RUSTUP_AUTO_INSTALL=0
minimum="$(bash vendor/toko-tooling/scripts/ci/read-cargo-workspace-rust-version.sh Cargo.toml)"
document="$("${YQ:-yq}" -p toml -o json '.' rust-toolchain.toml)"
pin="$(printf '%s' "$document" | jq -er '.toolchain.channel | select(type == "string" and test("^[0-9]+\\.[0-9]+\\.[0-9]+$"))')"
[[ "$minimum" == "$pin" ]] || { echo 'workspace Rust floor must equal the exact toolchain pin' >&2; exit 1; }
[[ -z "${MSRV:-}" || "$MSRV" == "$pin" ]] || { echo 'MSRV cannot override the compiler policy' >&2; exit 1; }
document="$("${YQ:-yq}" -p toml -o json '.' Cargo.toml)"
members="$(printf '%s' "$document" | jq -er '.workspace.members[]')"
while IFS= read -r member; do
    document="$("${YQ:-yq}" -p toml -o json '.' "$member/Cargo.toml")"
    printf '%s' "$document" | jq -e '.package["rust-version"] == {"workspace":true}' > /dev/null || {
        printf '%s must inherit the workspace Rust floor\n' "$member" >&2; exit 1;
    }
done <<< "$members"
printf 'Rust support floor and compiler pin: %s\n' "$pin"
observe() {
    local label="$1" output status=0 release
    shift
    output="$("$@" -vV 2>&1)" || status=$?
    printf '%s\n%s\n' "$label" "$output"
    [[ "$status" == 0 ]] || return "$status"
    release="$(printf '%s\n' "$output" | sed -n 's/^release: //p')"
    [[ "$release" == "$pin" ]] || { printf '%s must report release %s\n' "$label" "$pin" >&2; return 1; }
}
observe rustc "${RUSTC:-rustc}"
observe cargo cargo
