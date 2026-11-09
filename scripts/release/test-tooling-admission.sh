#!/usr/bin/env bash
set -euo pipefail
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
mkdir -p "$root/target/qualification"
fixture="$(fixture_create "$root/target/qualification/tooling-admission.XXXXXX")"
fixture_complete=false
trap 'fixture_finish "$?" "$fixture" "Tooling admission fixture retained"' EXIT
mkdir -p "$fixture/scripts/release" "$fixture/scripts/dev" "$fixture/scripts/ci" "$fixture/ci" "$fixture/bin"
cp "$root/scripts/release/"{candidate-setup.sh,publication.sh,metadata.sh} "$fixture/scripts/release/"
cp "$root/ci/cargo-release-groups.json" "$fixture/ci/"
cp "$root/ci/release-delivery.txt" "$fixture/ci/"
cp "$root/scripts/ci/check-release-delivery.sh" "$fixture/scripts/ci/"
git init -q "$fixture"
cat > "$fixture/scripts/dev/toko-tooling.sh" <<'CHECK'
set -euo pipefail
[[ "$1" == check && "$2" == --consumer && "$3" == "$EXPECTED_ROOT" ]]
printf 'check\n' >> "$EVENTS"
exit 23
CHECK
for command in cargo curl make; do
    cat > "$fixture/bin/$command" <<'EFFECT'
#!/usr/bin/env bash
printf 'unexpected effect\n' >> "$EVENTS"
exit 99
EFFECT
    chmod +x "$fixture/bin/$command"
done
export EXPECTED_ROOT="$fixture" EVENTS="$fixture/events" RELEASE_GROUP=metrics
export RELEASE_BATCH_ACTIVE=1 RELEASE_SETUP_MODE=prepare
export RELEASE_DELIVERY=direct
export PATH="$fixture/bin:$PATH"
cd "$fixture"
for entry in candidate-setup publication metadata; do
    case "$entry" in
        candidate-setup) operations=('') ;;
        publication) operations=(admit verify) ;;
        metadata) operations=(preflight verify prepare) ;;
    esac
    for operation in "${operations[@]}"; do
        : > "$EVENTS"
        status=0
        bash "scripts/release/$entry.sh" ${operation:+"$operation"} > "$fixture/output" 2>&1 || status=$?
        [[ "$status" == 23 ]] || { cat "$fixture/output" >&2; exit 1; }
        printf 'check\n' > "$fixture/expected"
        cmp "$fixture/expected" "$EVENTS"
    done
done
fixture_complete=true
echo 'Custom deployment adapters refuse tooling drift before effects.'
