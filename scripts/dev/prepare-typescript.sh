#!/usr/bin/env bash
set -euo pipefail
cd "${BASH_SOURCE[0]%/*}/../.."
# This is explicit setup; ordinary checks never install or update tools.
package_manager="$(node -p "require('./ci/typescript/package.json').packageManager")"
npm install --global "$package_manager" --ignore-scripts --no-audit --no-fund
bash scripts/ci/check-typescript-setup.sh
npm ci --prefix ci/typescript --ignore-scripts --no-audit --no-fund
