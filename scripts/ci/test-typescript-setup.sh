#!/usr/bin/env bash
set -euo pipefail
root="$(cd "${BASH_SOURCE[0]%/*}/../.." && pwd -P)"
# shellcheck source=scripts/ci/fixture-lifecycle.sh
source "$root/scripts/ci/fixture-lifecycle.sh"
mkdir -p "$root/target/qualification"
fixture="$(fixture_create "$root/target/qualification/typescript-setup.XXXXXX")"
fixture_complete=false
trap 'fixture_finish "$?" "$fixture" "TypeScript setup fixture retained"' EXIT
mkdir -p "$fixture/repo/scripts/"{ci,dev} "$fixture/repo/ci/typescript" "$fixture/bin"
cp "$root/scripts/ci/check-typescript-setup.sh" "$fixture/repo/scripts/ci/"
cp "$root/scripts/dev/prepare-typescript.sh" "$fixture/repo/scripts/dev/"
cp "$root/ci/typescript/package.json" "$fixture/repo/ci/typescript/"
cp "$root/ci/node-version.txt" "$fixture/repo/ci/"
cat > "$fixture/bin/npm" <<'NPM'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >> "$SETUP_FIXTURE/events"
case "$1" in
    --version)
        if [[ -f "$SETUP_FIXTURE/installed" ]]; then cat "$SETUP_FIXTURE/installed"
        else printf '11.19.0\n'; fi
        exit "${SETUP_NPM_STATUS:-0}" ;;
    install)
        [[ "$2" == --global && "$3" == "npm@$SETUP_FIXTURE_NPM" ]]
        printf '%s\n' "$SETUP_FIXTURE_NPM" > "$SETUP_FIXTURE/installed" ;;
    ci) [[ -f "$SETUP_FIXTURE/installed" && "$2" == --prefix && "$3" == ci/typescript ]] ;;
    *) exit 2 ;;
esac
NPM
chmod +x "$fixture/bin/npm"
export SETUP_FIXTURE="$fixture"
SETUP_FIXTURE_NPM="$(cd "$root" && node -p "require('./ci/typescript/package.json').engines.npm")"
export SETUP_FIXTURE_NPM PATH="$fixture/bin:$PATH"
if bash "$fixture/repo/scripts/ci/check-typescript-setup.sh" > "$fixture/bundled.log" 2>&1; then exit 1; fi
: > "$fixture/events"
bash "$fixture/repo/scripts/dev/prepare-typescript.sh" > "$fixture/prepared.log" 2>&1
[[ "$(head -1 "$fixture/events")" == "install --global npm@$SETUP_FIXTURE_NPM --ignore-scripts --no-audit --no-fund" ]]
[[ "$(tail -1 "$fixture/events")" == 'ci --prefix ci/typescript --ignore-scripts --no-audit --no-fund' ]]
# Correct-looking output cannot turn a failed observation into admission.
status=0
SETUP_NPM_STATUS=43 bash "$fixture/repo/scripts/ci/check-typescript-setup.sh" > "$fixture/npm-failed-observation.log" 2>&1 || status=$?
[[ "$status" == 43 ]]
# Failed package-manager selection must not reach global installation either.
SETUP_REAL_NODE="$(command -v node)"
export SETUP_REAL_NODE
cat > "$fixture/bin/node" <<'NODE'
#!/usr/bin/env bash
if [[ "${1:-}" == -p ]]; then printf 'npm@%s\n' "$SETUP_FIXTURE_NPM"; exit 47; fi
exec "$SETUP_REAL_NODE" "$@"
NODE
chmod +x "$fixture/bin/node"
: > "$fixture/events"
status=0
bash "$fixture/repo/scripts/dev/prepare-typescript.sh" > "$fixture/node-failed-observation.log" 2>&1 || status=$?
[[ "$status" == 47 && ! -s "$fixture/events" ]]
mv "$fixture/bin/node" "$fixture/node-failed-observer"
# Wrong Node must refuse before the locked install. Only fixture JSON is changed.
perl -pi -e 's/"node": "[^"]+"/"node": "0.0.0"/' "$fixture/repo/ci/typescript/package.json"
: > "$fixture/events"
if bash "$fixture/repo/scripts/dev/prepare-typescript.sh" > "$fixture/node.log" 2>&1; then exit 1; fi
if grep -q '^ci ' "$fixture/events"; then exit 1; fi
fixture_complete=true
printf 'Actual TypeScript setup rejects mismatches and failed observations before dependent effects (install effects substituted).\n'
