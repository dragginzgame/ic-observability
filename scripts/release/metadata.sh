#!/usr/bin/env bash
# Shared companions: scripts/dev/shared-tooling.sh scripts/ci/cargo-release-group.sh scripts/ci/cargo-release-metadata.sh scripts/ci/check-release-source.sh scripts/ci/check-release-delivery.sh scripts/ci/check-release-changelog.sh scripts/ci/cargo-release-preflight.sh scripts/ci/release-receipts.sh scripts/dev/release-editor.sh scripts/ci/check-setup-smoke.sh scripts/ci/fixture-lifecycle.sh ci/tool-versions.env ci/release-delivery.txt ci/release-tools.env
set -euo pipefail
[[ $# == 1 ]] || exit 2
operation="$1"
case "$operation" in selection|files|version|plan|packages|preflight|verify|prepare|check|commit-check) ;; *) exit 2 ;; esac
release_cache_prepare="${IC_METRICS_RELEASE_CACHE_PREPARE:-0}"
unset IC_METRICS_RELEASE_CACHE_PREPARE
root="${BASH_SOURCE[0]}"
[[ "$root" == /* ]] || root="$PWD/$root"
root="$(cd -P "${root%/*}/../.." && printf '%s/.' "$PWD")"
root="${root%/.}"
if [[ -z "${RELEASE_GROUP:-}" ]]; then
    echo 'Select RELEASE_GROUP explicitly; see ci/cargo-release-groups.json' >&2
    exit 2
fi
export RELEASE_GROUP
# Selection also runs before candidate host-tool preparation. Core Perl admits
# membership; Shared owns capture defaults, roster syntax and execution order.
perl -MJSON::PP -e '
    use strict; use warnings; local $/;
    open my $f, "<", $ARGV[0] or die $!;
    my $policy=decode_json(<$f>); close $f or die $!;
    my %known; $known{$_->{name}}++ for @{$policy->{groups}};
    my @selected=($ARGV[1], length($ARGV[2]) ? split(/,/, $ARGV[2], -1) : ());
    for my $group (@selected) {
        ($known{$group}//0)==1 or die "Unknown release group; see ci/cargo-release-groups.json\n";
    }
' "$root/ci/cargo-release-groups.json" "$RELEASE_GROUP" "${RELEASE_GROUPS:-}"
[[ "$operation" != selection ]] || exit 0
bash "$root/scripts/ci/check-release-delivery.sh" "$root/ci/release-delivery.txt" "${RELEASE_DELIVERY-direct}"
case "$operation" in
    preflight|verify|prepare)
        bash "$root/scripts/dev/shared-tooling.sh" check --consumer "$root" ;;
esac
# Initial admission precedes Cargo, tooling preparation and validation effects.
if [[ "$operation" == preflight || "$operation" == verify ]]; then
    bash "$root/scripts/ci/check-release-source.sh"
fi
if [[ "$operation" == packages ]]; then unset RELEASE_COMMIT; fi
case "$operation" in
    version|files|plan)
        exec bash "$root/scripts/ci/cargo-release-group.sh" "$operation" "$RELEASE_GROUP" ;;
esac
plan="$(bash "$root/scripts/ci/cargo-release-group.sh" plan "$RELEASE_GROUP")"
if [[ "$operation" == packages ]]; then
    printf '%s' "$plan" | jq -er '.members | join(" ")'
    exit
fi
primary="$(printf '%s' "$plan" | jq -er .primary)"
changelog="$(printf '%s' "$plan" | jq -er .changelog)"
files=()
while IFS= read -r -d '' path; do files+=("$path"); done < <(printf '%s' "$plan" | jq -jr '.files[] | . + "\u0000"')
source_arguments=()
for path in "${files[@]}"; do source_arguments+=(--allow "$path"); done
# shellcheck source=scripts/ci/release-receipts.sh
source "$root/scripts/ci/release-receipts.sh"
perl "$root/scripts/ci/validate-release-inputs.pl" version "${RELEASE_VERSION:?}" > /dev/null
state="$(git rev-parse --git-path release-state)/$RELEASE_GROUP-$RELEASE_VERSION"
metadata() {
    bash "$root/scripts/ci/cargo-release-metadata.sh" "$1" "$primary" ${2:+"$2"}
}
validated_identity() {
    release_receipt_identity || return
    printf 'group-validation:2\n%s\n' "$attempt" || return
    bash "$root/scripts/ci/verify-file-checksum.sh" --print sha256 "$attempt/proof.json"
}
validated() {
    [[ -f "$state/validation-attempt" && ! -L "$state/validation-attempt" ]]
    attempt="$(cat "$state/validation-attempt")"
    release_receipt_check "$state/validated" validated_identity
    perl "$root/scripts/release/validation.pl" check "$attempt"
}
prepared() {
    validated
    metadata check --manifest-order-grouped
    release_receipt_check "$state/prepared" release_receipt_payload "${RELEASE_COMMIT:-}" "${files[@]}"
}
case "$operation" in
    preflight)
        [[ "$(printf '%s' "$plan" | jq -er .previous)" == "${RELEASE_PREVIOUS:?}" ]]
        bash "$root/scripts/ci/check-release-changelog.sh" "$RELEASE_VERSION" "$RELEASE_PREVIOUS" "${RELEASE_DATE:?}" "$changelog"
        "${RELEASE_MAKE:-make}" --no-print-directory setup-smoke-check
        bash "$root/scripts/ci/cargo-release-preflight.sh" "$PWD" "$release_cache_prepare" \
            --pin "${RUST_TOOL_VERSIONS:-$root/ci/tool-versions.env}" --pin "$root/ci/release-tools.env" \
            --check rust-tools-check --check release-editor-check \
            --prepare install-rust-tools --prepare rust-tools-check \
            --prepare install-release-editor --prepare release-editor-check
        ;;
    verify)
        mkdir -p "$state"
        release_receipt_archive "$state/previous-attempt.XXXXXX" "$state/validated" "$state/prepared" "$state/validation-attempt"
        mkdir -p target/release-validation
        attempt="$(mktemp -d "target/release-validation/$RELEASE_GROUP-$RELEASE_VERSION.XXXXXX")"
        mkdir "$attempt/tmp"
        perl "$root/scripts/release/validation.pl" select "$attempt"
        release_receipt_write "$state/validation-attempt" printf '%s\n' "$attempt"
        OBSERVABILITY_RELEASE_VALIDATION_SCOPE="$(jq -er .scope "$attempt/plan.json")" \
            OBSERVABILITY_RELEASE_VALIDATION_ATTEMPT="$attempt" VALIDATION_LOG_DIR="$attempt/logs" \
        VALIDATION_FAILURE_LOG_DIR="$(git rev-parse --git-path release-state)/validation-failures" \
            TMPDIR="${TMPDIR:-$root/$attempt/tmp}" CARGO_NET_OFFLINE=true bash "$root/scripts/ci/run-validation-targets.sh" \
            --plan "$attempt/plan.json"
        bash "$root/scripts/ci/check-release-source.sh"
        release_receipt_write "$attempt/proof.json" perl "$root/scripts/release/validation.pl" seal "$attempt"
        release_receipt_write "$state/validated" validated_identity
        ;;
    prepare)
        validated
        bash "$root/scripts/ci/check-release-source.sh"
        CARGO_RELEASE_METADATA_EDITOR="$("${RELEASE_MAKE:-make}" --no-print-directory -s release-editor-check)"
        export CARGO_RELEASE_METADATA_EDITOR
        # shellcheck source=ci/release-tools.env
        source "$root/ci/release-tools.env"
        export CARGO_RELEASE_METADATA_MAX_BYTES="$IC_METRICS_RELEASE_METADATA_MAX_BYTES"
        metadata prepare
        release_receipt_write "$state/prepared" release_receipt_payload '' "${files[@]}"
        ;;
    check|commit-check)
        if [[ "$operation" == commit-check ]]; then [[ -z "${RELEASE_COMMIT:-}" ]]; fi
        prepared
        bash "$root/scripts/ci/check-release-source.sh" "${source_arguments[@]}"
        if [[ "$operation" == commit-check ]]; then git diff --quiet -- "${files[@]}"; fi
        ;;
esac
