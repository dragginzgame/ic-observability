#!/usr/bin/env bash
set -euo pipefail
unset MAKEFLAGS MFLAGS MAKEOVERRIDES GNUMAKEFLAGS MAKEFILES
unset VALIDATION_REPOSITORY_ROOT VALIDATION_RUNNER_SNAPSHOT_PATH
export RELEASE_DELIVERY=direct
export RELEASE_GROUP=metrics
# Standard-runner projection inside a captured checkout, not outer capture.
export RELEASE_BATCH_ACTIVE=1
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
mkdir -p "$root/target/qualification"
fixture="$(fixture_create "${TMPDIR:-$root/target/qualification}/standard-release-entry.XXXXXX")"
fixture_complete=false
cleanup() {
    local status=$?
    if [[ "$status" != 0 ]]; then
        fixture_replay_logs "$fixture/output" "$fixture"/release-commands.*/*.log
    fi
    fixture_finish "$status" "$fixture" "failed standard release fixture retained"
}
trap cleanup EXIT
# shellcheck source=scripts/ci/make-adapter-probes.sh
source "$root/scripts/ci/make-adapter-probes.sh"
# shellcheck source=scripts/release/fixtures/prepare-make.sh
source "$root/scripts/release/fixtures/prepare-make.sh"
prepare_make_fixture "$root" "$fixture"
real_bash="$STANDARD_RELEASE_REAL_BASH"
cd "$fixture"
real_make="$(command -v make)"
# The actual Make entry projects the metadata owner's NUL-delimited roster.
(cd "$root" && "$real_make" --no-print-directory release-files) > "$fixture/release-files"
printf '%s\0' Cargo.toml Cargo.lock releases/metrics/CHANGELOG.md crates/ic-metrics/Cargo.toml > "$fixture/expected-release-files"
cmp "$fixture/expected-release-files" "$fixture/release-files"
for selection in default direct; do
    if [[ "$selection" == default ]]; then unset RELEASE_DELIVERY; else export RELEASE_DELIVERY=direct; fi
    TMPDIR="$fixture" "$real_bash" "$root/scripts/ci/check-release-commands.sh" "$root" \
        make/consumer.mk make/tools.mk make/release.mk make/rust-format.mk make/execution.mk make/validation.mk \
        scripts/ci/check-make-execution.sh scripts/ci/check-release-delivery.sh \
        ci/release-delivery.txt scripts/ci/run-formatting.sh \
        scripts/release/metadata.sh ci/cargo-release-groups.json > "$fixture/output" 2>&1
done

# Keep one real-consumer include-admission check. Shared Tooling owns the
# environment/recursive-root isolation matrix and checker export behavior.
mkdir -p "$fixture/external/scripts/ci"
cat > "$fixture/external/scripts/ci/check-make-execution.sh" <<'EXTERNAL'
#!/usr/bin/env bash
echo escaped >> "$EVENTS"
exit 0
EXTERNAL
: > "$EVENTS"
"$real_make" --no-print-directory -f "$root/Makefile" help \
    "SHARED_TOOLING_ROOT=$fixture/external" > "$fixture/output" 2>&1
[[ ! -s "$EVENTS" ]] || exit 1

# Unsupported inherited and command-line policies must fail before runner or
# metadata dispatch. The parse-time Make execution probe remains real.
export STANDARD_RELEASE_PHASE=metadata
# Preflight binds the same independently selected Rust catalog as installation;
# a host-only override must not change it. Exercise actual Make child routing.
selected_rust="$fixture/selected Rust pins.env"
cp "$root/ci/tool-versions.env" "$selected_rust"
: > "$EVENTS"
PATH="$fixture/bin:$PATH" RELEASE_DELIVERY=direct REQUIRE_RUST_CATALOG=1 \
    EXPECTED_RUST_CATALOG="$selected_rust" "$real_make" --no-print-directory \
    -f "$root/Makefile" release-preflight "RUST_TOOL_VERSIONS=$selected_rust" \
    "HOST_TOOL_VERSIONS=$fixture/other-host-catalog" > "$fixture/output" 2>&1
printf '%s\n' "$selected_rust" > "$fixture/expected-rust-catalog"
cmp "$fixture/expected-rust-catalog" "$EVENTS"
for policy in pr invalid ''; do
    for selection in environment command; do
        for target in release-patch release-minor release-major release-resume release-preflight release-prepare-version; do
            : > "$EVENTS"
            status=0
            if [[ "$selection" == command ]]; then
                PATH="$fixture/bin:$PATH" RELEASE_DELIVERY=direct "$real_make" --no-print-directory \
                    -f "$root/Makefile" "$target" "RELEASE_DELIVERY=$policy" > "$fixture/output" 2>&1 || status=$?
            else
                PATH="$fixture/bin:$PATH" RELEASE_DELIVERY="$policy" "$real_make" --no-print-directory \
                    -f "$root/Makefile" "$target" > "$fixture/output" 2>&1 || status=$?
            fi
            if [[ "$status" == 0 ]]; then
                echo 'unsupported delivery was accepted' >&2
                exit 1
            fi
            [[ ! -s "$EVENTS" ]] || exit 1
        done
    done
    : > "$EVENTS"
    if PATH="$fixture/bin:$PATH" RELEASE_DELIVERY="$policy" "$real_bash" "$root/scripts/release/metadata.sh" preflight \
        > "$fixture/output" 2>&1; then exit 1; fi
    [[ ! -s "$EVENTS" ]] || exit 1
done
export STANDARD_RELEASE_PHASE=real

# Captured standard entries admit prepared tools and retain caller offline mode.
mkdir -p scripts/ci
cat > scripts/ci/run-release.sh <<'RUNNER'
#!/usr/bin/env bash
set -euo pipefail
[[ "${IC_METRICS_RELEASE_CACHE_PREPARE:-}" == "${EXPECTED_CACHE_PREPARE:-0}" ]] || exit 1
[[ "${CARGO_NET_OFFLINE:-}" == true ]] || exit 1
printf '%s\n' "$@" > "$EVENTS"
exit "${CACHE_ENTRY_RESULT:-0}"
RUNNER
for target in patch minor major resume; do
    for result in 0 17; do
        : > "$EVENTS"
        status=0
        CACHE_ENTRY_RESULT="$result" CARGO_NET_OFFLINE=true "$real_make" --no-print-directory \
            -f "$root/Makefile" "release-$target" VERSION=0.1.2 RELEASE_REMOTE=review \
            RELEASE_BRANCH=main > "$fixture/output" 2>&1 || status=$?
        if [[ "$result" == 0 ]]; then [[ "$status" == 0 ]] || exit 1; else [[ "$status" != 0 ]] || exit 1; fi
        if [[ "$target" == resume ]]; then printf '%s\n' resume 0.1.2 review main > "$fixture/cache-entry-expected";
        else printf '%s\n' "$target" review main > "$fixture/cache-entry-expected"; fi
        cmp "$fixture/cache-entry-expected" "$EVENTS"
    done
done

# Earlier standalone recovery keeps its preparation lane; outer increments use
# the separately qualified batch runner instead.
CARGO_NET_OFFLINE=true EXPECTED_CACHE_PREPARE=1 "$real_make" --no-print-directory \
    -f "$root/Makefile" release-resume RELEASE_BATCH_ACTIVE= VERSION=0.1.2 \
    RELEASE_REMOTE=review RELEASE_BRANCH=main > "$fixture/output" 2>&1
printf '%s\n' resume 0.1.2 review main > "$fixture/cache-entry-expected"
cmp "$fixture/cache-entry-expected" "$EVENTS"

# Recursive MAKE arguments belong to the real invocation, not the admission probe.
cat > "$fixture/recursive.mk" <<'MAKE'
RELEASE_REMOTE := recursive
recursive-entry:
	+@$(MAKE) release-patch
MAKE
: > "$EVENTS"
CARGO_NET_OFFLINE=true "$real_make" -j2 --no-print-directory \
    -f "$root/Makefile" -f "$fixture/recursive.mk" recursive-entry \
    "MAKE=$real_make --no-print-directory -f $root/Makefile -f $fixture/recursive.mk" \
    RELEASE_BRANCH=main > "$fixture/output" 2>&1
printf '%s\n' patch recursive main > "$fixture/cache-entry-expected"
cmp "$fixture/cache-entry-expected" "$EVENTS"

# The actual consumer includes reject unsafe Make modes before any substituted
# release/formatter operation, including an inherited marker claiming admission.
# Publication remains a separate Cargo operation. Substitute it
# before admission cases so even a broken guard cannot reach a registry.
export JOBSERVER_PROBE="$root/scripts/ci/check-pipe-jobserver.pl"
parallel=(-j4)
if "$real_make" --help | grep -q -- --jobserver-style; then parallel+=(--jobserver-style=pipe); fi
cargo_targets=(package-check check check-wasm clippy docs-check test allocation-free-check)
metadata_targets=(release-preflight release-prepare-version release-commit-check release-prepared-check release-committed-check release-tagged-check release-push-check)
export STANDARD_RELEASE_PHASE=metadata
# Shared Tooling owns flag aliases and inheritance permutations. Keep all actual
# consumer targets under each unsafe behavior, without repeating that matrix.
PATH="$fixture/bin:$PATH" make_probe_target_admission "$real_make" "$root/Makefile" "$fixture" "$EVENTS" \
    release-patch release-minor release-major release-resume fmt fmt-check compiler-check msrv \
    "${cargo_targets[@]}" "${metadata_targets[@]}"
export STANDARD_RELEASE_PHASE=real

# The real consumer Makefile must leave both pipe descriptors open at every
# owned Cargo boundary. Cargo effects are substituted; Make admission is real.
PATH="$fixture/bin:$PATH" REQUIRE_JOBSERVER=1 \
    make_probe_parallel_dispatch "$real_make" "$root/Makefile" "$fixture" "$EVENTS" "${cargo_targets[@]}"
# Metadata also dispatches Cargo, so its Bash entry must retain the descriptors.
export STANDARD_RELEASE_PHASE=metadata
PATH="$fixture/bin:$PATH" REQUIRE_JOBSERVER=1 make_probe_parallel_dispatch "$real_make" "$root/Makefile" "$fixture" "$EVENTS" "${metadata_targets[@]}"
# Prepared metadata must precede archive verification; either failure stops release.
for failure in none metadata package; do
    : > "$EVENTS"
    status=0
    metadata_failure=0
    package_failure=0
    [[ "$failure" != metadata ]] || metadata_failure=39
    [[ "$failure" != package ]] || package_failure=1
    PATH="$fixture/bin:$PATH" REQUIRE_JOBSERVER=1 FAIL_METADATA="$metadata_failure" \
        FAIL_PACKAGE="$package_failure" "$real_make" "${parallel[@]}" --no-print-directory \
        -f "$root/Makefile" release-prepare-version > "$fixture/output" 2>&1 || status=$?
    if [[ "$failure" == none ]]; then [[ "$status" == 0 ]] || exit 1; else [[ "$status" != 0 ]] || exit 1; fi
    printf 'metadata prepare\n' > "$fixture/expected"
    if [[ "$failure" != metadata ]]; then
        printf '%s\n' package -p ic-metrics --all-features --locked --offline --allow-dirty >> "$fixture/expected"
    fi
    cmp "$fixture/expected" "$EVENTS"
done
export STANDARD_RELEASE_PHASE=real
# A failure in a multi-command gate stops before any later Cargo command.
: > "$EVENTS"
status=0
PATH="$fixture/bin:$PATH" REQUIRE_JOBSERVER=1 CLIPPY_FAILURE=native "$real_make" "${parallel[@]}" --no-print-directory \
    -f "$root/Makefile" clippy > "$fixture/output" 2>&1 || status=$?
[[ "$status" == 2 ]] || exit 1
printf '%s\n' clippy --workspace --all-targets --all-features --locked -- -D warnings > "$fixture/expected"
cmp "$fixture/expected" "$EVENTS"

# The same Cargo recipes select either independent package under group scope;
# full CI remains workspace-scoped. Inspect actual dispatch, including Wasm.
for group in metrics logging; do
    for target in clippy docs-check test package-check; do
        : > "$EVENTS"
        PATH="$fixture/bin:$PATH" REQUIRE_JOBSERVER=1 RELEASE_GROUP="$group" \
            "$real_make" "${parallel[@]}" --no-print-directory -f "$root/Makefile" \
            "$target" OBSERVABILITY_RELEASE_VALIDATION_SCOPE=group > "$fixture/output" 2>&1
        case "$target" in
            clippy)
                printf '%s\n' clippy -p "ic-$group" --all-targets --all-features --locked -- -D warnings \
                    clippy -p "ic-$group" --lib --all-features --locked --target wasm32-unknown-unknown -- -D warnings > "$fixture/expected" ;;
            docs-check)
                printf '%s\n' doc -p "ic-$group" --all-features --locked --no-deps \
                    doc -p "ic-$group" --all-features --locked --no-deps --target wasm32-unknown-unknown > "$fixture/expected" ;;
            test) printf '%s\n' test -p "ic-$group" --all-features --locked > "$fixture/expected" ;;
            package-check) printf '%s\n' package -p "ic-$group" --all-features --locked --offline --allow-dirty > "$fixture/expected" ;;
        esac
        cmp "$fixture/expected" "$EVENTS"
    done
done

# The real CI entry forces workspace scope through recursive Make. The named
# mapping qualification separately exercises shared dispatch and lint ordering.
cat > "$fixture/gate-make" <<'MAKE'
#!/usr/bin/env bash
set -euo pipefail
[[ $# == 3 && "$1" == --no-print-directory && "$3" == OBSERVABILITY_RELEASE_VALIDATION_SCOPE=workspace ]] || exit 91
printf '%s\n' "$2" >> "$EVENTS"
exit "${FAIL_CI_DISPATCH:-0}"
MAKE
chmod +x "$fixture/gate-make"
for fail in 0 1; do
    : > "$EVENTS"
    status=0
    FAIL_CI_DISPATCH="$fail" "$real_make" "${parallel[@]}" --no-print-directory \
        -f "$root/Makefile" ci "MAKE=$fixture/gate-make" > "$fixture/output" 2>&1 || status=$?
    if [[ "$fail" == 0 ]]; then [[ "$status" == 0 ]] || exit 1; else [[ "$status" == 2 ]] || exit 1; fi
    printf 'workspace-ci\n' > "$fixture/expected"
    cmp "$fixture/expected" "$EVENTS"
done

# Safe replacement flags still reach the real consumer adapter with its selected
# runner substituted, including parallel mode and a quoted ordinary selection.
for selection in '' --no-print-directory; do
    : > "$EVENTS"
    CARGO_NET_OFFLINE=true "$real_make" -j2 --no-print-directory -f "$root/Makefile" \
        release-patch "MAKEFLAGS=$selection" RELEASE_REMOTE=review RELEASE_BRANCH=main \
        "AUDIT_SELECTION=owner's selection" > "$fixture/output" 2>&1
    printf '%s\n' patch review main > "$fixture/cache-entry-expected"
    cmp "$fixture/cache-entry-expected" "$EVENTS"
done

# Archive admission must build the arithmetic package and propagate Cargo failure.
for fail in 0 1; do
    : > "$EVENTS"
    status=0
    PATH="$fixture/bin:$PATH" FAIL_PACKAGE="$fail" "$real_make" --no-print-directory \
        -f "$root/Makefile" package-check > "$fixture/output" 2>&1 || status=$?
    if [[ "$fail" == 0 ]]; then [[ "$status" == 0 ]] || exit 1; else [[ "$status" != 0 ]] || exit 1; fi
    printf '%s\n' package --workspace --all-features --locked --offline --allow-dirty > "$fixture/expected"
    cmp "$fixture/expected" "$EVENTS"
done

echo 'Release Make adapters passed (command stubs; no Git effects)'
fixture_complete=true
