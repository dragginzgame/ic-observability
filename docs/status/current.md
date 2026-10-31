# Current handoff — 2026-10-31

The maintainer requested the latest Shared Tooling adoption and a PR, then asked
for the 0.27.22 update. Continue existing [PR #106](https://github.com/dragginzgame/ic-observability/pull/106)
on chore/shared-tooling-0.27.21, based on
1da20a84a6c44144ca86c340351790b984036f39 (Metrics 0.24 registry delivery).
Scoped commits and topic pushes are authorized. Merge, main push, own version
bumps, release, publication, cleanup and sibling edits are outside this PR scope.

## Adopted source and release identity

Canonical export selected Shared commit 143a9abb9ae81feae9400ff3844b03b1ddfdd75a,
titled 0.27.22 and verified against remote main. It changes governance and
manifest presentation; no runtime, installer, tool pin or release script changes
from the preceding 0.27.21 adoption. The source was cloned into an isolated
/tmp checkout because the sibling has an uncommitted VERSION edit; it remains
untouched. Exporter-owned payloads and ownership records were not hand-edited.

Upstream's committed VERSION still says 0.27.21, although its commit and changelog
say 0.27.22. The snapshot correctly retains that committed display version with
the new full revision; AGENTS.md explains the distinction. The maintainer confirmed
that this exact revision is the intended selection; no source-selection question
remains. A later committed release identity can be refreshed through the exporter;
never relabel snapshot provenance by hand.

## Catalog and release behavior

Every member has a root workspace dependency alias with its owned path and full
current version: Metrics 0.24.0 and Logging 0.23.2. Each alias belongs to its
release group's dependencies roster. These unused declarations add no library
dependency edges. Root comments now present each group once in a contiguous
block, with short titles and separate changelog comments. The duplicate header
map is removed; grouped formatting preserves the blocks. External dependencies
retain production/test roles and relevant native/feature restrictions.

The combined PR also carries 0.27.21 complete-catalog admission, delegated-delivery
and explicit cleanup rules. Release preparation advances only the selected root
requirement and preserves other groups. There is no aggregate workspace version.
Plain cargo clean keeps its default whole-target scope; no cleanup ran.

## Qualification

Incremental evidence: target/audits/shared-02722-20261031/.

- Canonical impact/export receipts bind the reviewed upstream revision. Only four
  selected governance documents changed from 0.27.21; common executable payloads
  and catalogs remain identical.
- make fmt preserves the group blocks. Full locked offline Cargo metadata is
  exactly equal before/after the layout change; Cargo.lock is byte-identical.
- Both actual group plans pass. The named release-admission fixture passes in
  both directions with the new manifest layout, covering selected catalog edits,
  exact staging/commits, rollback, receipts/resume, retained consumers and
  publication selection. Actual shared editor/runner and disposable Git remotes
  are used; broad gates, archive compilation and registry uploads are substituted.
- Snapshot integrity, pins, documentation links and both pending-ledger checks
  pass. The retained release fixture is target/observability-release-groups.LMBIHI/.

Prior complete make release-tools-check, selected ShellCheck and custody checks
passed for the unchanged executable inputs. Those receipts remain at
target/audits/shared-02721-20261031/ and
target/evidence/native-ci/fixture-retention.djSfl5/.
No full local ci/msrv or new hosted/native matrix is required for this governance
and presentation update. Hosted PR checks remain asynchronous.

## Versions and retained evidence

Metrics remains published 0.24.0 with Wire/Derive 0.13; Logging remains 0.23.2.
Pending tooling notes remain Metrics 0.24.1 and Logging 0.23.3. No own package
version, library source, dependency selection or lockfile changed.
The prior [Wire receipt](../evidence/wire-0130/README.md) retains registry-only
Principal/Account qualification with Types 0.15.1/facade 0.15.2, Rust 1.91/Wasm
and exact byte/schema checks. Prior deployment receipts and all Git-owned release
journals remain retained. Canic #712/#100 and downstream integration ownership
remain separate; this change makes no new runtime or IC performance claim.
