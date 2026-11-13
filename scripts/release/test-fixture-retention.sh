#!/usr/bin/env bash
set -euo pipefail
export RELEASE_DELIVERY=direct
selected_kind=''
if [[ $# != 0 ]]; then
    [[ $# == 2 && "$1" == --kind ]] || {
        echo 'usage: test-fixture-retention.sh [--kind standard|publication|hook|exits]' >&2; exit 2;
    }
    case "$2" in standard|publication|hook|exits) selected_kind="$2" ;; *) exit 2 ;; esac
fi

# Exercise real consumer fixtures through controlled executable failures.
# Use caller-owned scratch, defaulting to native CI evidence, including inputs.
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
mkdir -p "$root/target/evidence/native-ci"
# shellcheck source=vendor/toko-tooling/scripts/ci/fixture-lifecycle.sh
source "$root/vendor/toko-tooling/scripts/ci/fixture-lifecycle.sh"
evidence="$(fixture_create "${TMPDIR:-$root/target/evidence/native-ci}/fixture-retention.XXXXXX")"
fixture_complete=false
cleanup() {
    local status=$?
    fixture_completion_status "$status" "$fixture_complete" || status=$?
    if [[ "$status" != 0 ]]; then
        fixture_replay_logs "${active_log:-}"
        echo "fixture retention check failed; evidence retained: $evidence" >&2
    fi
    exit "$status"
}
trap cleanup EXIT
# shellcheck source=vendor/toko-tooling/scripts/ci/fixture-retention-probes.sh
source "$root/vendor/toko-tooling/scripts/ci/fixture-retention-probes.sh"
real_bash="$(command -v bash)"
export FIXTURE_RETENTION_REAL_BASH="$real_bash"
FIXTURE_RETENTION_REAL_MAKE="$(command -v make)"
export FIXTURE_RETENTION_REAL_MAKE
git -C "$root" rev-parse HEAD > "$evidence/source-commit.txt"

write_bash_fault() {
    local destination="$1"
    cat >> "$destination" <<'BASH'
case "${1:-}" in
    */vendor/toko-tooling/scripts/ci/prepare-script-fixture.sh) ;;
    *) exec "$FIXTURE_RETENTION_REAL_BASH" "$@" ;;
esac
BASH
}

write_make_fault() {
    local destination="$1" scenario="$2"
    case "$scenario" in
        baseline)
            cat >> "$destination" <<'MAKE'
for argument in "$@"; do
    if [[ "$argument" == fmt-check ]]; then
        echo 'FIXTURE_RETENTION_INJECTED_FAILURE' >&2
        exit 43
    fi
done
exec "$FIXTURE_RETENTION_REAL_MAKE" "$@"
MAKE
            ;;
        publication-child)
            cat >> "$destination" <<'MAKE'
publication=false
for argument in "$@"; do
    case "$argument" in publish|publish-check) publication=true ;; esac
done
if [[ "$publication" != true ]]; then exec "$FIXTURE_RETENTION_REAL_MAKE" "$@"; fi
MAKE
            ;;
        *) return 2 ;;
    esac
}

for kind in standard publication hook; do
    [[ -z "$selected_kind" || "$selected_kind" == "$kind" ]] || continue
    case "$kind" in
        standard) script=scripts/release/test-standard-release.sh; prefix=standard-release-entry; child=bash ;;
        publication) script=scripts/release/test-publication-make.sh; prefix=publication-make-entry; child='make' ;;
        hook) script=scripts/dev/test-format-hook.sh; prefix=metrics-format-hook; child='make' ;;
    esac
    cp "$root/$script" "$evidence/$kind-source.sh"
    scenarios=(success child)
    if [[ "$kind" == publication ]]; then scenarios=(success publication-child publication-assertion); fi
    if [[ "$kind" == hook ]]; then scenarios=(success baseline); fi
    for scenario in "${scenarios[@]}"; do
        run="$evidence/$kind-$scenario"
        active_log="$run/result.log"
        mkdir -p "$run/tmp" "$run/bin"
        assertion_fault=0
        if [[ "$scenario" == *assertion ]]; then assertion_fault=1; fi
        if [[ "$scenario" != success && "$assertion_fault" == 0 ]]; then
            executable="$child"
            case "$scenario" in publication-child|baseline) executable='make' ;; esac
            printf '#!%s\n' "$real_bash" > "$run/bin/$executable"
            case "$executable" in
                bash) write_bash_fault "$run/bin/$executable" ;;
                make) write_make_fault "$run/bin/$executable" "$scenario" ;;
                *) exit 2 ;;
            esac
            cat >> "$run/bin/$executable" <<'FAIL'
echo 'FIXTURE_RETENTION_INJECTED_FAILURE' >&2
exit 43
FAIL
            chmod +x "$run/bin/$executable"
        fi
        expected_status=43
        case "$scenario" in
            success) expected_status=0 ;;
            publication-child|*assertion) expected_status=1 ;;
        esac
        marker=FIXTURE_RETENTION_INJECTED_FAILURE
        # The shared checker retains its nested log; replay is not required.
        if [[ "$kind" == hook ]]; then marker="$prefix"; fi
        METRICS_FIXTURE_ASSERTION_FAILURE="$assertion_fault" PATH="$run/bin:$PATH" \
            fixture_probe_effect "$root/$script" "$run" "$prefix" "$expected_status" "$real_bash" \
                "$marker"
        if [[ "$scenario" == success ]]; then
            echo "$kind fixture passed (full body; success cleanup checked)"
            continue
        fi
        retained="$fixture_effect_retained"
        if [[ "$kind" == hook ]]; then
            grep -Fxq "Metrics formatting fixture retained: $retained" "$run/result.log"
        else
            grep -Fq "fixture retained: $retained" "$run/result.log"
        fi
        if [[ "$assertion_fault" == 1 ]]; then
            # The child owns its payload names; verify its retained-input contract.
            [[ -s "$retained/retention-inputs.sha256" ]] || exit 1
            (cd "$retained" && shasum -a 256 -c retention-inputs.sha256) > "$run/retained-inputs.log"
            continue
        fi
        case "$kind" in
            standard|publication)
                [[ -f "$retained/output" ]] || exit 1
                if [[ "$scenario" == publication-* ]]; then
                    [[ -f "$retained/events" && -f "$retained/bin/cargo" ]] || exit 1
                fi
                ;;
            hook)
                grep -Fq FIXTURE_RETENTION_INJECTED_FAILURE "$retained"/formatting-adoption.*/baseline.log
                ;;
        esac
    done
done
if [[ -n "$selected_kind" && "$selected_kind" != exits ]]; then
    fixture_complete=true
    echo "Selected $selected_kind fixture retention passed; evidence: $evidence"
    exit 0
fi
# Execute the actual admission fixture with parent-owned evidence destinations.
# Its synthetic failures must use its own logs and leave the parent untouched.
if [[ "$selected_kind" != exits ]]; then
run="$evidence/admission-parent"
active_log="$run/result.log"
mkdir -p "$run/logs" "$run/failures" "$run/tmp"
printf 'parent-owned evidence\n' > "$run/expected"
for destination in logs/sentinel failures/sentinel summary.md; do
    cp "$run/expected" "$run/$destination"
done
VALIDATION_LOG_DIR="$run/logs" VALIDATION_FAILURE_LOG_DIR="$run/failures" \
    GITHUB_STEP_SUMMARY="$run/summary.md" TMPDIR="$run/tmp" \
    "$real_bash" "$root/scripts/release/test-release-admission.sh" \
    > "$run/result.log" 2>&1
for destination in logs/sentinel failures/sentinel summary.md; do
    cmp "$run/expected" "$run/$destination"
done
for directory in logs failures; do
    [[ "$(ls -A "$run/$directory")" == sentinel ]] || exit 1
done
echo 'Group admission fixture preserves inherited parent logs and summary; its receipts remain retained'
fi

# Render the actual consumer prefix and keep its root bound to this checkout.
# Shared's root-layout exit runner copies helpers from the consumer scripts tree;
# this caller instead supplies its vendor-aware source context to the renderer.
probe_consumer_exit() {
    local script="$1" run="$2" directory_variable="$3" scenario="$4"
    local injection expected=1 status=0 retained
    case "$scenario" in
        nounset) injection='unset RETENTION_UNBOUND; printf "%s\n" "$RETENTION_UNBOUND"' ;;
        premature) injection='exit 0' ;;
        completed|retained-completed) injection='fixture_complete=true; exit 0'; expected=0 ;;
        *) return 2 ;;
    esac
    fixture_probe_prefix "$root/$script" "$run/probe.sh" root "$directory_variable" "$injection" || return
    RETENTION_SOURCE_ROOT="$root" RETENTION_EXIT_PATH="$run/retained.path" TMPDIR="$run" \
        "$real_bash" "$run/probe.sh" > "$run/result.log" 2>&1 || status=$?
    [[ "$status" == "$expected" && -f "$run/retained.path" ]] || return 1
    retained="$(cat "$run/retained.path")" || return
    [[ "$retained" == "$run/"* ]] || return 1
    if [[ "$scenario" == completed ]]; then
        [[ ! -e "$retained" && ! -L "$retained" ]] || return 1
    else
        [[ -d "$retained" && "$(cat "$retained/exit-evidence")" == 'retained evidence' ]] || return 1
    fi
}

# Probe actual initialization/cleanup prefixes through the shared owner.
# Consumer rosters and successful diagnostic retention remain explicit here.
for script in scripts/release/test-standard-release.sh \
    scripts/release/test-publication-make.sh \
    scripts/dev/test-format-hook.sh \
    scripts/release/test-release-admission.sh \
    scripts/ci/test-native-evidence.sh scripts/release/test-fixture-retention.sh; do
    name="${script##*/}"
    success=completed
    directory_variable=fixture
    case "$script" in
        scripts/ci/test-native-evidence.sh|scripts/release/test-release-admission.sh) success='retained-completed' ;;
        scripts/release/test-fixture-retention.sh) success='retained-completed'; directory_variable=evidence ;;
    esac
    for scenario in nounset premature "$success"; do
        run="$evidence/cleanup-${name%.sh}-$scenario"
        mkdir -p "$run"
        active_log="$run/result.log"
        probe_consumer_exit "$script" "$run" "$directory_variable" "$scenario" || {
            fixture_replay_logs "$run/result.log"
            printf 'Consumer exit boundary failed: %s %s\n' "$script" "$scenario" >&2
            exit 1
        }
    done
done
echo "fixture success cleanup and child/assertion failure retention passed; evidence: $evidence"
fixture_complete=true
