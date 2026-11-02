# Shared Tooling 0.27.26 adoption — 2026-11-02

The root snapshot advances from 0.27.23 at
`619d194875369e0f72b45477b66adb430acbf6b7` to committed remote main
`fd9390ef797bfad8aaa05fdba8fcddec753b572c`, whose VERSION is 0.27.26.
The producer ledger still marks 0.27.26 Unreleased and no matching tag was
observed. This is an exact-commit adoption, not a tagged-release claim.

The canonical exporter ran from a clean isolated checkout under
`target/adoptions/shared-tooling-20261102/source/`. The producer sibling checkout
was only read. Impact preview preceded refresh; the existing entrypoints were
retained and their required companion closure grew from 134 to 141 files.
The manifest and every exported payload verified. No snapshot record or shared
payload was hand-edited.

## Applicable changes

- The baseline now owns Rust 1.99.1 as minimum and pinned compiler. Existing
  Metrics 0.26.0 and Logging 0.24.0 already implement that policy. AGENTS.md now
  reads the installed baseline instead of carrying the temporary revision-bound
  override; pre-existing product ownership/selector wording is retained.
- Cargo-tool native identity keeps tool/header/library providers, including held
  installed packages, and excludes unrelated Linux application updates. Compiler,
  tool-source and executable-byte admission remain. Host and IC tool catalogs
  have unchanged versions and digests.
- Successful managed Cargo-tool compilation scratch is discarded after admission.
  Selected binaries, source archives, locks, receipts and failed observations keep
  their owners. The exported maintenance helpers include their owned-tree module.
  No executable-generation reclamation or existing application-artifact cleanup
  was invoked. Optional product compiler-cache maintenance is not activated.
- Shared grouped-release policy admission is factored for source-only bootstrap
  observation. Existing resolved group plans and release adapters keep their
  contracts; this consumer does not add optional validation-proof reuse or narrow
  its release gates.

The two independent ledgers have compatible tooling notes pending at Metrics
0.26.1 and Logging 0.24.1. Package versions, all three Cargo locks, application
source, feature graphs and production dependency requirements are unchanged.
The pre-existing root and Metrics README edits remain byte-for-byte intact.
No staging, commit, PR, push, release or publication is part of this adoption.

## Focused local evidence

On prepared Linux x86_64 with Rust/Cargo 1.99.1:

- Explicit `make install-tools` prepares the unchanged pinned common tools and
  IC Build 0.73.0 CLI under the new build-input policy. New generation receipts
  pass offline `make tools-check`; old executable generations are left intact.
- Snapshot verification checks all 141 paths, digests, modes and declared roots.
- `make check-pins fmt-check` passes, preserving grouped manifests, standalone
  Rust formatting and locked dependency selections.
- The actual formatting/hook fixture passes, including preservation and hook
  installation. The release/publication Make fixture passes jobserver,
  selection, status propagation and fail-fast Clippy-ordering checks with effects
  substituted inside its disposable fixture.
- The actual independent-group release-admission fixture passes both Metrics and
  Logging metadata, rollback, exact commit/tag, receipts/resume and substituted
  publication. Its Git effects remain inside the disposable fixture.
- Native workflow evidence projection passes with substituted action/compiler/
  Make effects, preserving source identity, partial failures and archive custody.

Raw impact, refresh, setup and named-check logs are under
`target/adoptions/shared-tooling-20261102/`. The native fixture is
`target/evidence/native-ci/native-evidence.KCrywQ`; group admission is
`target/observability-release-groups.fPWH8P`. These local fixtures do not establish
new hosted macOS/product acceptance. The shared producer's complete generic
matrix, full local `make ci`, release gates and product builds were not rerun.
Those obligations remain with their existing owners and execution scopes.
