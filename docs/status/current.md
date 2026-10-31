# Current handoff — 2026-10-31

The maintainer requested the latest Shared Tooling adoption and a PR. The topic
branch is chore/shared-tooling-0.27.21, based on
1da20a84a6c44144ca86c340351790b984036f39 (Metrics 0.24 registry delivery).
The PR covers the complete pending adoption from the base's Shared 0.27.17 to
0.27.21. Its scoped commit and topic push are authorized; no main-branch push,
merge, version bump, release, publication, cleanup or sibling edit is included.

## Adopted contract and catalog

Canonical export selected clean committed Shared Tooling 0.27.21 at
3279d9b1a4b68178f3c4187be394de003e4ee010, verified against remote main. Snapshot
payloads remain untouched after export. AGENTS.md records that exact revision.
Impact/export receipts remain at target/audits/shared-02721-20261031/.

Every member now has a root workspace dependency alias with its owned path and
full current version: Metrics 0.24.0 and Logging 0.23.2. The alias is registered
in its owning group's dependencies roster, including unused entries. These are
catalog declarations only; neither library adds a dependency on the other.
Root comments label group ledgers and local/external production/test roles.
There is no aggregate workspace version or generated numeric summary.

Shared admission checks coverage, full versions, alias rosters and actual member
paths, including unused aliases in unselected groups. Release preparation updates
the selected root requirement through the existing transaction/editor. Fixtures
compare the entire expected root manifest, preserving the other group and all
external selections, and verify four exact staged/committed release paths.
Standalone retained-consumer workspaces select only their own supplier catalog.

The adoption also carries canonical delegated-delivery and explicit cleanup
clarifications. A ship/deploy request may cover release and publication, with
separate commands/receipts. Ordinary implementation and PR scope remain narrower.
Plain cargo clean retains its default whole-target behavior; the host guide
explains that retained target evidence is included, while managed tool stores
and Git-owned journals are outside that scope. No cleanup ran.

## Qualification

Current evidence is under target/audits/shared-02721-20261031/:

- make fmt, selected ShellCheck, snapshot integrity, check-pins, documentation
  links and both actual pending-ledger checks pass. Both group plans are admitted.
- The complete make release-tools-check gate passes, exercising actual shared
  admission, editor/runner and disposable Git remotes. It covers selected catalog
  updates, unchanged unrelated manifests/requirements/pending notes, exact stage/
  commit paths, rollback, validated/prepared receipts, resume, publication selection
  and unaffected consumers. Broad gates/archive verification and uploads are
  substituted; successful inputs remain at
  target/evidence/native-ci/fixture-retention.djSfl5/.
- A stale unused alias in the other group remains acceptable to Cargo metadata
  but is rejected by the actual group adapter in both release directions.
- Full locked Cargo metadata exactly matches the pre-catalog result, and
  Cargo.lock is byte-identical. This confirms no added package/feature edges.
  No library source, package manifest version or dependency selection changed.

Common tool catalogs/installers and Build 0.73.0 are unchanged. Prepared-tool
admission from the preceding 0.27.20 qualification remains applicable, and the
actual installed editor is admitted by the current release fixture. Generic
Shared producer matrices were reviewed rather than replayed. No full local
ci/msrv or new hosted/native matrix ran; PR CI supplies its asynchronous checks.

## Current versions and preserved evidence

Metrics remains published 0.24.0 with Wire/Derive 0.13; Logging remains 0.23.2.
Compatible pending tooling notes remain Metrics 0.24.1 and Logging 0.23.3.
The prior [Wire receipt](../evidence/wire-0130/README.md) retains real registry-only
Principal/Account tests with Types 0.15.1/facade 0.15.2, Rust 1.91/Wasm and exact
byte/schema checks. Prior deployment/evidence records and all .git/release-state
journals remain retained. No new runtime, installed IC or performance claim is
made; Canic #712/#100 and downstream integration ownership remain separate.
