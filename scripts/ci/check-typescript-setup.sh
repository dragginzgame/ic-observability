#!/usr/bin/env bash
set -euo pipefail
cd "${BASH_SOURCE[0]%/*}/../.."
observed_npm="$(npm --version)"
OBSERVABILITY_OBSERVED_NPM="$observed_npm" node --input-type=commonjs - <<'JS'
const { readFileSync } = require('node:fs');
const { engines, packageManager } = require('./ci/typescript/package.json');
if (readFileSync('./ci/node-version.txt', 'utf8').trim() !== engines.node ||
    process.versions.node !== engines.node || packageManager !== `npm@${engines.npm}` ||
    process.env.OBSERVABILITY_OBSERVED_NPM !== engines.npm) {
  throw new Error('Prepare the declared Node and npm selections before TypeScript qualification or release.');
}
console.log(`TypeScript setup admitted: Node ${engines.node}, ${packageManager}`);
JS
