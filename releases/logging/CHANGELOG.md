# Logging changelog

This is the canonical ledger for the independent `logging` release group.
Shared Metrics/Logging release history through 0.23.0 remains once in the
[shared historical ledger](../history.md#0230---2026-10-31).
Logging's independent release series begins at 0.23.1. Future Logging notes
belong here.

## [0.24.12] - Unreleased

### 🛠️ Tooling

- Adopt committed Shared Tooling 0.31.12: retain the Bash 3.2 checksum repair,
  restrict formatting to owned workspace members, isolate release command checks,
  and admit the shared hashing inventory. LOC detail now uses `CLOC_DEPTH=0`
  for packages and larger depths for source modules.
- Cache authenticated CI tool downloads before setup and run one full-history,
  redacted Gitleaks scan per repository CI run, including documentation changes.
  Support selecting a crate or source module in the LOC report.
- Colour LOC names in terminals and show sibling scan progress on one updating
  line, preserving plain redirected output and existing counts.

### 🧪 Testing

- Isolate release fixtures from inherited batch configuration, including CI's
  empty group roster, so standard command and group recovery checks use their
  own explicit selection.

## [0.24.11] - 2026-11-06

### 🛠️ Tooling

- Adopt committed Shared Tooling 0.31.0 with automatic captured delivery for
  explicit release groups, candidate tool setup and offline recovery. Use the
  new release-batch settings and schema-2 journals with recorded publication
  identity; retired settings refuse. Keep publication and reconciliation explicit.
- Adopt hardened snapshot/checksum admission, including rejection of NUL-containing
  checksum output. [Shared #360](https://github.com/dragginzgame/shared-tooling/issues/360).

## [0.24.10] - 2026-11-06

### 🛠️ Tooling

- Adopt committed Shared Tooling 0.30.7 and its release-efficiency guidance.
  Preserve normal direct delivery and reject unqualified frozen-batch selection
  before release effects; keep stage reuse disabled.

## [0.24.9] - 2026-11-06

### 🛠️ Tooling

- Adopt committed Shared Tooling 0.30.6 and enforce its shared Cargo and Rust CBOR
  boundaries, including independently generated retained-consumer workspaces.
  Keep the existing Candid checks and empty allowance policy.
- Keep publication scope overrides compatible with macOS's system Make, and
  check their exported values before tool installation or publication effects.

## [0.24.8] - 2026-11-05

### 🛠️ Tooling

- Adopt committed Shared Tooling 0.30.4: keep formatter and LOC scratch under
  the owning target directory, preserve explicit overrides and failed diagnostics,
  and refresh LOC reporting, documentation companions and release-draft handling.
  Final-candidate stage reuse remains disabled; package/dependency versions stay
  unchanged until normal release preparation.
- Enforce the shared Candid source boundary through the existing dependency gate,
  with no allowances and group scope carried to actual crate/fixture sources.

### 🧹 Cleanup

- Compact superseded experimental evidence into topic summaries, preserving exact
  release receipts and source-distribution custody while repairing references.
  Retire raw bundles and their now-obsolete archive-checksum Make/CI stage;
  deployed formats, product checks and tool-download verification stay unchanged.

## [0.24.7] - 2026-11-05

### 🛠️ Tooling

- Select committed Shared Tooling 0.30.0 and its classified source report.
  Lint only the explicitly selected publication group on native and Wasm targets,
  preserving source admission, lint-failure stopping and upload/readback ordering.
- Declare retained-consumer fixtures as private test packages and preserve their
  complete source inputs when qualifying the independent package contracts.

## [0.24.6] - 2026-11-04

### 🛠️ Tooling

- Adopt committed Shared Tooling 0.29.4 rules and release/evidence fixes, including
  retained-state admission around release steps. Move
  byte-budgeted export tests into their own module, retaining the example's
  Cargo target and command while separating tests from its source report.
- Prepare CI selection, compiler-policy and publication fixtures through the shared
  companion resolver, preserving helper dependencies and existing refusal checks.
- Keep retained-consumer contracts in regular Rust test files covered by formatting,
  with a focused execution entrypoint and complete default release qualification.
- Keep standalone local fixture scratch under the workspace's `target/`, retaining
  explicit temporary-root overrides and failed-input evidence.
- Allow native-evidence checks to select one recovery scenario while retaining the
  complete default run. Simplify synthetic dependency inputs without reducing
  declaration and metadata refusal coverage.
- Reject missing maintained package inputs and bound captured check commands by
  output size and lifetime. Keep default CI/release validation scratch under
  `target/`, and distinguish workspace gates from focused checks in command help.

## [0.24.5] - 2026-11-03

### 🛠️ Tooling

- Adopt Shared Tooling 0.28.2 and its common validation evidence and baseline helpers.
  Share the full CI roster with release selection and keep matched mapping
  qualification separate from routine caller checks, with sealed recovery intact.
  [#129 — Consolidate shared validation mechanics](https://github.com/dragginzgame/ic-observability/issues/129).

## [0.24.4] - 2026-11-03

### 🛠️ Tooling

- Adopt Shared Tooling 0.28.0 and independent release-validation plans. Confined
  Logging changes retain its native/Wasm package and dependency checks; shared or
  uncertain changes run the workspace gate. Preserve complete repository CI and
  require retained plan evidence for release recovery.

## [0.24.3] - 2026-11-02

### 🧹 Cleanup

- Simplify the byte-budgeted export example's stop/error state while preserving
  lossless UTF-8 continuation and typed oversized-row errors. Check Logging's
  dependency-free native/Wasm graphs separately from Metrics' feature matrix;
  retain real supplier identities in parsed release-consumer fixtures.
- Simplify shared publication and native-evidence fixtures while preserving
  archive-content rejection, diagnostic custody and dependency isolation checks.

## [0.24.2] - 2026-11-02

### 🧹 Cleanup

- Share retained-text component accounting across append, eviction and checkpoint
  admission, preserving byte ceilings and independent validation. Simplify setup
  qualification and native evidence test flows without changing the Logging API.

## [0.24.1] - 2026-11-02

### 🔧 Changed

- Adopt the committed Shared Tooling 0.27.26 snapshot: canonical Rust 1.99.1
  policy, narrower native Cargo-tool fingerprints and managed tool-build scratch.
  Preserve package dependencies, release-group isolation and retained evidence.
- Derive visitor continuation from the consumed cursor instead of storing a
  second scan watermark. Preserve paging, early-stop and retention semantics.
  Keep release/publication and evidence qualification in focused fixture flows.

## [0.24.0] - 2026-11-02

### ⚠️ Breaking

- Require Rust 1.99.1 on native and Wasm, matching the pinned development and
  release compiler. Consolidate duplicate compiler jobs while retaining native,
  Wasm, doctest, package and consumer qualification. See the
  [migration notes](0.24.md) and
  [#124 — Adopt Rust 1.99.1 and consolidate compiler qualification](https://github.com/dragginzgame/ic-observability/issues/124).

## [0.23.7] - 2026-11-01

### 🧪 Testing

- Extend the independent operation-history model to visitor early stops and
  absent versus present-empty topic filters across append refusals, retention,
  restoration and cursor continuation. Retain the engine's existing semantics.

## [0.23.6] - 2026-11-01

### 📚 Documentation

- Add a compiled byte-budgeted text export recipe with typed oversized-row
  errors and continuation from the last emitted row. Explain that the stopping
  candidate counts as scanned, while transport/envelope limits remain host-owned.
- Demonstrate application-owned Metrics counters for log admission, truncation,
  eviction and refusal, with independent metrics-window and log lifetimes.

### 🧪 Testing

- Run the export example's UTF-8, first-row error, empty-filter and bounded-scan
  tests in ordinary Cargo tests. The heap engine, cursor API, dependency-free
  library and retained-data contract are unchanged.

## [0.23.5] - 2026-11-01

### 🔧 Changed

- Verify maintained package contents against the retrieved release source during
  publication readback. Admit consumer Make routing and declared Node/npm setup
  before release validation; run Make checks early on the native CI hosts.

### 🩹 Fixed

- Preserve failed npm/Node observations before admission or dependent setup,
  even when they print expected values. Record the Make smoke step's explicit
  outcome in native diagnostic and recovery evidence.

### 🧪 Testing

- Exercise independently corrupted UTF-8 checkpoints and add opt-in long seeded
  operation histories over the existing independent event model. The heap engine,
  public API, retained-data format and dependency-free contract are unchanged.

## [0.23.4] - 2026-11-01

### 🔧 Changed

- Retain Logging's native check names while routing reviewed prose changes to
  documentation checks ([#107 — Adopt conservative documentation-only CI selection](https://github.com/dragginzgame/ic-observability/issues/107)); full release gates remain unchanged.
- Require a clean, remotely tagged Logging release before upload. Add verified
  publication and readback-only commands that check registry state, archive
  checksum and source provenance without retrying uploads.
- Document published installation and check packaged links without relying on
  repository-only files. The heap engine and dependency-free contract are unchanged.
- Keep the publication Make entrypoint compatible with the older GNU Make
  supplied by supported macOS hosts.

## [0.23.3] - 2026-10-31

### 🔧 Changed

- Adopt Shared Tooling's complete member-catalog admission and 0.27.22 catalog
  layout. Logging release preparation updates its root requirement while
  preserving Metrics' version, requirement and release notes.
- Clarify [delivery policy](../../rules/contributions.md#delegated-delivery) and
  explicit Cargo cleanup scope. Logging's dependency-free engine, compiler floor
  and public contracts are unchanged.

## [0.23.2] - 2026-10-31

### 🔧 Changed

- Require explicit `RELEASE_GROUP=logging` for release, resume and publication.
  Logging's canonical notes now live in this group ledger under releases/logging;
  the former crate-local path links here. Runtime contracts and the current
  package version are unchanged. See [group commands](../../docs/independent-releases.md).

## [0.23.1] - 2026-10-31

### 🔧 Changed

- Give Logging its independent release and publication selection through
  `RELEASE_GROUP=logging`, preserving its current 0.23.0 identity and runtime
  contract. Metrics versions and pending notes remain untouched by Logging
  releases. See [group commands](../../docs/independent-releases.md) and
  [#104 — Version Metrics and Logging independently](https://github.com/dragginzgame/ic-observability/issues/104).
