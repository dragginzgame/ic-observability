# Logging changelog

This is the canonical ledger for the independent `logging` release group.
Shared Metrics/Logging release history through 0.23.0 remains once in the
[shared historical ledger](../history.md#0230---2026-10-31).
Logging's independent release series begins at 0.23.1. Future Logging notes
belong here.

## [0.25.5] - Unreleased

### 🛠️ Tooling

- Adopt published toko-tooling 0.42.5 and use its repaired vendor-aware fixture
  exit helper ([Toko Tooling #381](https://github.com/dragginzgame/toko-tooling/issues/381)).
  Remove the consumer workaround while retaining all 18 cleanup/retention checks,
  the existing vendor selection and the full release-stage roster.
- Pre-release registry review confirms stable toko-tooling 0.42.5, num-bigint
  0.5.1, Serde 1.0.229 and cargo-sort 2.1.4. Defer optional cargo-sort-derives
  0.15.0 to the next reviewed shared catalog adoption, retaining 0.14.1.
  Defer IC Build 0.84.1 to the next native-editor maintenance batch; retain
  qualified 0.83.0 and its packaged IC Host 0.76.4 lock rather than forcing
  current IC Host 0.77.1 into that supplier's graph. Revisit these dispositions
  at the next applicable release review.

## [0.25.4] - 2026-11-13

### 🛠️ Tooling

- Adopt published toko-tooling 0.42.4 with the existing vendor entrypoints and
  consumer-owned adapters. Use its updated Rust-tool setup and post-activation
  maintenance recovery; preserve product dependencies and the release-stage roster.

- Pre-release registry review confirms stable toko-tooling 0.42.4, num-bigint
  0.5.1, Serde 1.0.229 and cargo-sort 2.1.4. Defer optional cargo-sort-derives
  0.15.0 to the next reviewed shared catalog adoption, retaining 0.14.1.
  Defer IC Build 0.84.1 to the next native-editor maintenance batch; retain
  qualified 0.83.0 and its packaged IC Host 0.76.4 lock rather than forcing
  current IC Host 0.77.1 into that supplier's graph. Revisit these dispositions
  at the next applicable release review.

## [0.25.3] - 2026-11-13

### 🛠️ Tooling

- Adopt published toko-tooling 0.42.1 under `vendor/toko-tooling/` through the
  authenticated exporter. Update Make, CI actions, native evidence, hooks and
  release/publication callers together; retain consumer-owned scripts/policies,
  explicit group selection and tooling-drift admission before effects.
- Use the package-first dependency inventory and keep generic producer release
  checks upstream, retaining direct consumer dispatch and recovery qualification.

- Bind fixture exit probes to the consumer root under the vendor layout, retaining
  failure/premature-exit evidence and successful-cleanup assertions. A focused
  exit-boundary selection avoids repeating nested release transactions.
- Pre-release registry review confirms stable toko-tooling 0.42.1, num-bigint
  0.5.1, Serde 1.0.229 and cargo-sort 2.1.4. Defer optional cargo-sort-derives
  0.15.0 to the next reviewed shared catalog adoption, retaining 0.14.1.
  Defer IC Build 0.84.1 to the next native-editor maintenance batch; retain
  qualified 0.83.0 and its packaged IC Host 0.76.4 lock rather than forcing
  current IC Host 0.77.1 into that supplier's graph. Revisit these dispositions
  at the next applicable release review.

## [0.25.2] - 2026-11-13

### 🔧 Changed

- Format byte-budgeted export rows directly into the result after checking their
  exact encoded length, removing the per-row temporary string while preserving
  UTF-8 budgets, typed oversized-row errors and cursor continuation.

### 🛠️ Tooling

- Adopt published toko-tooling 0.41.0, its inherited Cargo/Rustdoc lint minimum
  and offline `make deps-list`. Keep display-only aliases and their allowances
  removed; preserve package identities, production graphs and existing gates.
  Publication uses admitted member manifests; group increments preserve root bytes.
- Enforce Clippy warnings through Cargo after qualifying fresh/reused native and
  Wasm artifact refusal. Keep explicit Rustdoc denial and selected-group admission.
  Generated public consumers retain only their supplier's inherited dependencies
  and integration targets, removing unused declarations and empty-library warnings.
- Keep optional test-supplier upgrades separate from the qualified frozen release
  graph. Native tool installation still admits exact versions, archive checksums
  and packaged locks; Cargo 1.100 supplies its default install lock.
- Pre-release registry review confirms current stable toko-tooling 0.41.0,
  num-bigint 0.5.1, Serde 1.0.229 and cargo-sort 2.1.4. Defer optional
  cargo-sort-derives 0.15.0 to the next reviewed shared catalog adoption, retaining
  0.14.1. Defer IC Build 0.84.0 to the next native-editor maintenance batch;
  this release retains qualified 0.83.0 and its packaged IC Host 0.76.4 lock.
  Current IC Host 0.77.0 is not forced into that supplier's selected graph.
  Revisit these dispositions at the next applicable release review.

## [0.25.1] - 2026-11-13

### 🩹 Fixed

- Refuse unsafe Make modes before group/scope selection on GNU Make 3.81,
  preserving release and publication admission on both macOS architectures.
  The existing consumer fixtures cover the failure from
  [native CI](https://github.com/dragginzgame/ic-observability/actions/runs/43398940199).

### 🛠️ Tooling

- Adopt authenticated toko-tooling 0.40.1 deployment and CI guidance. Use retained
  stage timings and focused wiring evidence when planning deployment; diagnose
  failed phases before retrying, preserving required fresh artifact/registry
  admission and existing release gates. Stage reuse and collector recovery remain
  unavailable until their input and custody contracts are qualified here.
- Registry review confirms current stable toko-tooling 0.40.1, num-bigint 0.5.1,
  serde 1.0.229, cargo-sort 2.1.4 and IC Build 0.83.0. Defer optional
  cargo-sort-derives 0.15.0 to the next reviewed shared catalog adoption; retain
  its selected 0.14.1. Keep the editor's packaged IC Host 0.76.4 lock, deferring
  optional artifacts/fs/process 0.76.5 to the next published editor adoption.
  Revisit both dispositions at the next applicable release review.

## [0.25.0] - 2026-11-13

### ⚠️ Breaking

- Require Rust 1.100.0 for native and Wasm consumers, matching the explicitly
  prepared development/release compiler. Upgrade the consumer compiler before
  adopting this release.
  [#134 — Adopt Rust 1.100.0 and the common lint policy](https://github.com/dragginzgame/ic-observability/issues/134).

### 🛠️ Tooling

- Adopt authenticated toko-tooling 0.40.0 and its common inherited lint policy.
  Preserve safe-only prohibitions and strict Clippy/Rustdoc gates, select
  individual checks instead of blanket nursery, and lint generated consumers.
  Retain the full validation roster, fresh artifact admission and recovery
  boundaries; stage reuse remains disabled.
- Registry review confirms current stable toko-tooling 0.40.0, num-bigint 0.5.1,
  serde 1.0.229, cargo-sort 2.1.4 and the selected IC Build 0.83.0 release editor.
  Defer optional cargo-sort-derives 0.15.0 to the next reviewed shared tool-catalog
  adoption; the current catalog selects 0.14.1. Keep the editor's packaged IC Host
  0.76.4 lock, deferring optional artifacts/fs/process 0.76.5 to the next published
  editor adoption. Revisit both dispositions at the next applicable release review.

## [0.24.17] - 2026-11-12

### 🛠️ Tooling

- Adopt authenticated toko-tooling 0.39.17 and its updated Cargo boundary checks
  and shared hash catalog.
  Retain both libraries' dependency-free production graphs and existing
  tooling placement; no simulator or crypto dependency is added.
  Bound LOC report labels by default and support full names with `cloc.sh --wide`,
  preserving numeric counts and full JSON labels.
  Apply explicit supplier freshness reviews before release capture, including
  the selected native release editor.
  Add explicit `make deps-update` with package/precise selectors, preserving
  normal Cargo output and default Make routing without changing release gates.
  Use directory test modules with preserved module paths and test coverage,
  removing sibling `tests.rs`/`tests/` pairs.
  Update the published release metadata editor to IC Build 0.83.0.
  Registry review found current toko-tooling 0.39.17, num-bigint 0.5.1,
  serde 1.0.229 and cargo-sort 2.1.4. Defer optional cargo-sort-derives 0.15.0
  to the next reviewed Toko tool-catalog adoption; preserve the shared 0.14.1 pin.
  IC Build 0.83.0 keeps its published IC Host 0.76.4 lock. Defer optional
  ic-host-artifacts/fs/process 0.76.5 to the next published IC Build editor
  adoption, retaining authenticated locked builds and revisiting at release review.

## [0.24.16] - 2026-11-10

### 🛠️ Tooling

- Adopt toko-tooling 0.39.7, explicitly enable the shared release interface and
  retire shared reference copies through the exporter in favour of pinned upstream links.
  Clarify product navigation, current release-line guidance and adapter ownership.
  Organise native guides by topic, repair caller links and compact the tooling summary.
  Use pinned online release-setting diagnostics in the trimmed snapshot.
  Qualify publication readback with complete distribution inputs and altered/missing-input refusals.
  [Tooling #373](https://github.com/dragginzgame/toko-tooling/issues/373).

## [0.24.15] - 2026-11-09

### 🛠️ Tooling

- Adopt authenticated toko-tooling 0.38.2 and its product/qualification placement
  rules. Retain both libraries and their package-local tests in the product
  workspace, with qualification explicitly excluded.
  [Tooling #369](https://github.com/dragginzgame/toko-tooling/issues/369).

## [0.24.14] - 2026-11-09

### 🛠️ Tooling

- Adopt authenticated toko-tooling 0.37.5, including accurate test-only LOC
  classification and refusal of obsolete LOC metadata. Migrate the baseline,
  receipt, tooling commands, variables and metadata to Toko names. Preserve
  inherited development selection and complete product release requirements.
  Explicitly protect consumer validation and metadata recipes under the new
  recipe-scoped Make admission guard.
  [Tooling #367](https://github.com/dragginzgame/toko-tooling/issues/367).

## [0.24.13] - 2026-11-09

### ➕ Added

- Retain structured diagnostic rows in a typed bounded heap history with
  count/payload-byte limits, oldest-row eviction receipts and intact refused
  inputs. Consumers retain sanitization, timestamp semantics and schema ownership;
  existing text logs and checkpoints are unchanged.
  [#131](https://github.com/dragginzgame/ic-observability/issues/131).

## [0.24.12] - 2026-11-08

### 🛠️ Tooling

- Select published toko-tooling 0.36.0 with an inherited dev-dependency and
  cargo-machete exemption, using the exact root pin and Cargo.lock. Remove the
  metadata/lock selector while preserving Logging's production graph and release gates.
- Reject missing or unknown release groups before Cargo-based tooling admission.
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
- Clarify [delivery policy](https://github.com/dragginzgame/toko-tooling/blob/12459b6029115b830b8477879d3bea2f030b6e63/rules/contributions.md#delegated-delivery) and
  explicit Cargo cleanup scope. Logging's dependency-free engine, compiler floor
  and public contracts are unchanged.

## [0.23.2] - 2026-10-31

### 🔧 Changed

- Require explicit `RELEASE_GROUP=logging` for release, resume and publication.
  Logging's canonical notes now live in this group ledger under releases/logging;
  the former crate-local path links here. Runtime contracts and the current
  package version are unchanged. See [group commands](../../docs/releases/independent-releases.md).

## [0.23.1] - 2026-10-31

### 🔧 Changed

- Give Logging its independent release and publication selection through
  `RELEASE_GROUP=logging`, preserving its current 0.23.0 identity and runtime
  contract. Metrics versions and pending notes remain untouched by Logging
  releases. See [group commands](../../docs/releases/independent-releases.md) and
  [#104 — Version Metrics and Logging independently](https://github.com/dragginzgame/ic-observability/issues/104).
