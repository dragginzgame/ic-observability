# Metrics changelog

This is the canonical ledger for the independent `metrics` release group.
Shared Metrics/Logging release history through 0.23.0 remains once in the
[shared historical ledger](../history.md#0230---2026-10-31).
Metrics and Logging each own their package version and release notes.

## [0.29.4] - Unreleased

### 🛠️ Tooling

- Keep publication scope overrides compatible with macOS's system Make, and
  check their exported values before tool installation or publication effects.

## [0.29.3] - 2026-11-05

### 🛠️ Tooling

- Adopt committed Shared Tooling 0.30.4: keep formatter and LOC scratch under
  the owning target directory, preserve explicit overrides and failed diagnostics,
  and use the updated LOC scanner and complete documentation companions.
- Refresh canonical release-draft handling without enabling final-candidate
  stage reuse or changing package/dependency versions.
- Enforce the shared Candid source boundary through the existing dependency gate,
  with no allowances and group scope carried to actual crate/fixture sources.

### 🧹 Cleanup

- Replace superseded evidence bundles, source snapshots and per-run diaries with
  compact topic summaries. Preserve release receipts and distribution custody,
  repair historical links and explicitly retire unavailable raw qualification.
- Remove the obsolete experimental archive-checksum command and CI stage after
  retiring its inputs; retain product/recovery and tool-download integrity checks.

## [0.29.2] - 2026-11-05

### 🛠️ Tooling

- Select committed Shared Tooling 0.30.0 and its classified source report.
  Keep allocator-link qualification under test source with an explicit role,
  preserving its existing Cargo command and retained Wasm artifact identity.
- Lint only the explicitly selected publication group on native and Wasm targets.
  Keep fresh source admission, lint-failure stopping and independent upload/readback.
- Declare retained-consumer fixtures as private test packages and preserve their
  complete source inputs when qualifying the independent package contracts.

## [0.29.1] - 2026-11-04

### 🛠️ Tooling

- Adopt committed Shared Tooling 0.29.4 rules and release/evidence fixes, including
  retained-state admission around release steps. Move
  reset-window tests into their own module so file-based source reports can
  separate test bodies while preserving private access and test behavior.
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

## [0.29.0] - 2026-11-03

### ⚠️ Breaking

- Restrict Metrics to application instrumentation. Remove general ratio/rounding,
  averaging and report-query APIs, and recorder Serde traits. Canic's metrics
  adapter owns report DTOs and the shared endpoint; governed storage uses the
  explicit persistence restoration contract. Preserve recording/overflow/reset
  semantics and storage-owned retained formats. See the [migration guide](0.29.md).
  [#130 — Restrict Metrics to instrumentation](https://github.com/dragginzgame/ic-observability/issues/130).

## [0.28.2] - 2026-11-03

### 🛠️ Tooling

- Adopt Shared Tooling 0.28.2 and its common validation-evidence, baseline and roster
  interfaces. Keep one CI stage declaration, preserve sealed release recovery
  after version preparation, and renew matched mapping qualification explicitly.
  [#129 — Consolidate shared validation mechanics](https://github.com/dragginzgame/ic-observability/issues/129).

## [0.28.1] - 2026-11-03

### 🛠️ Tooling

- Adopt Shared Tooling 0.28.0 and independent release-validation plans. Confined
  Metrics changes retain its complete package checks; shared or uncertain changes
  run the workspace gate. Bind scope decisions and successful checks to retained
  recovery evidence while preserving full repository CI.

## [0.28.0] - 2026-11-03

### ⚠️ Breaking

- Remove `native-wire` and Metrics-owned Wire metadata. Services own report DTOs,
  schemas and generated clients; Metrics retains validated Serde and arithmetic
  without a Wire/Platform dependency. Remove feature forwarding and migrate
  enclosing report schemas through the [0.28 guide](0.28.md).
  [#128 — Remove Metrics' Wire metadata dependency](https://github.com/dragginzgame/ic-observability/issues/128).

### 🧹 Cleanup

- Retire Metrics-owned browser/pairing qualification and Node/npm setup. Keep
  Serde representation/refusal tests, native/Wasm graph checks and independent
  release-consumer qualification. Historical receipts retain their original scope.

## [0.27.2] - 2026-11-02

### 🧹 Cleanup

- Render retained release-consumer manifests from parsed fields, preserving real
  supplier versions and independent release assertions across TOML layouts.
  Share fixture serialization while keeping source and registry policy separate.
- Narrow archive-content fixtures while retaining integrated tamper rejection;
  flatten native-evidence assertions and remove a duplicate dependency-fixture
  baseline.

## [0.27.1] - 2026-11-02

### 🧹 Cleanup

- Separate TypeScript tool admission from setup regression fixtures while keeping
  them in release validation and TypeScript CI. Simplify registry/source fixture
  selection, native evidence collection and browser-test diagnostics without
  changing report schemas, bytes or dependency selections.

## [0.27.0] - 2026-11-02

### ⚠️ Breaking

- Select Wire 0.15 for native report metadata. Schema consumers must align
  Metrics and Wire together; Principal/Account reports use canonical Types 0.17
  or Platform 0.18 re-exports. Arithmetic, schemas, encoded bytes and the Rust
  1.99.1 floor are unchanged. See the [migration guide](0.27.md).

## [0.26.1] - 2026-11-02

### 🔧 Changed

- Adopt the committed Shared Tooling 0.27.26 snapshot: canonical Rust 1.99.1
  policy, narrower native Cargo-tool fingerprints and managed tool-build scratch.
  Preserve package dependencies, release-group isolation and retained evidence.
- Simplify native metadata and qualification: group optional Wire implementations,
  render fixture manifests from parsed fields, use Shared graph checks and retain
  curated reports. Separate release/publication fixture flows and remove duplicate
  compiler observations without changing schemas, encoded bytes or arithmetic.

## [0.26.0] - 2026-11-02

### ⚠️ Breaking

- Require Rust 1.99.1 on native and Wasm, matching the pinned development and
  release compiler. Consolidate duplicate compiler jobs while retaining native,
  Wasm, doctest, package and consumer qualification. See the
  [migration notes](0.26.md) and
  [#124 — Adopt Rust 1.99.1 and consolidate compiler qualification](https://github.com/dragginzgame/ic-observability/issues/124).

### 🧪 Testing

- Reject missing, malformed or stale published-consumer version intent before
  compiler observations; valid intent still requires exact compiler admission.

## [0.25.1] - 2026-11-01

### 🧪 Testing

- Qualify published Wire/Derive 0.14.2 for native metadata and both independent
  identity consumers. Preserve the Wire 0.14.0 minimum, canonical Types 0.16.0 /
  Platform 0.17.0 pairing, schemas, encoded bytes and arithmetic-only isolation.
  See [patch qualification](../../docs/evidence/wire-history.md).

## [0.25.0] - 2026-11-01

### ⚠️ Breaking

- Adopt Wire 0.14 for native measurement metadata. Schema consumers must align
  their Wire trait identity; numeric shapes, encoded bytes, Serde admission and
  arithmetic APIs remain unchanged. See the [migration notes](0.25.md).
  Fix native schema composition for
  [#120 — Align native Metrics schemas with published Wire 0.14](https://github.com/dragginzgame/ic-observability/issues/120).

### 🧪 Testing

- Qualify source composition with canonical Types 0.16/Platform 0.17, keeping
  the existing Metrics 0.24.6 registry consumer on its independent Wire 0.13
  catalog until a new publication is explicitly selected.

## [0.24.6] - 2026-11-01

### 🧪 Testing

- Extend the independent histogram restoration oracle to every subset of its
  small observation domain, with zero through four finite bounds.
- Qualify Wire/Derive 0.13.5 in both isolated identity consumers alongside the
  root lock selection, retaining the 0.13.2 minimum and existing canonical
  identity pairing. Preserve generated client schemas and encoded vectors.
  Retain published-consumer inputs and metadata in CI failure artifacts.

## [0.24.5] - 2026-11-01

### 🧪 Testing

- Extend bounded recording qualification with an independent event-journal
  model across UTF-8/key/count/byte pressure, repeated keys, omissions, clear
  operations and host window resets. Add a compiled application example that
  composes published Metrics and Logging without a dependency between libraries.
  Exercise that consumer in CI and on the Rust floor.
- Qualify published Wire/Derive 0.13.3 in the root and both independently locked
  identity consumers. Preserve the declared Wire 0.13.2 minimum, canonical Types
  0.15.1/facade 0.15.2 pairing, schemas, bytes and arithmetic-only isolation.
  Compare generated TypeScript and vectors against an executed 0.13.2 baseline;
  leave the new fixed-byte-array representation opt-in and unselected.
  See [qualification evidence](../../docs/evidence/wire-history.md).

## [0.24.4] - 2026-11-01

### 🔧 Changed

- Verify every maintained package file against the retrieved release source
  during publication readback, including source roster and original manifest.
  Reject altered, missing, extra, duplicate and symlinked archive members.
- Check consumer Make publication-mode routing and declared Node/npm versions
  during release preflight; run Make admission before native tool setup.

### 🩹 Fixed

- Preserve failed npm/Node observations before admission or dependent setup,
  even when they print expected values. Record the Make smoke step's explicit
  outcome in native diagnostic and recovery evidence.

- Require an explicit expected Metrics version for registry-only identity
  acceptance; reject stale catalogs before Cargo effects and verify the resolved
  registry version against the requested intent.

### 🧪 Testing

- Add an independently locked registry-only Principal/Account consumer for
  published Metrics 0.24.3, reusing the source probe assertions without a local
  Metrics copy. Keep Platform and endpoint integrations outside the core graph.
  Package APIs, schemas, encoded bytes and production dependencies are unchanged.

## [0.24.3] - 2026-11-01

### 🩹 Fixed

- Keep publication-mode assignment compatible with macOS's older GNU Make.
  Prepare the declared npm version before installing the locked TypeScript tools
  in CI. Library APIs, dependency selections and encoded representations are unchanged.

## [0.24.2] - 2026-11-01

### 🔧 Changed

- Adopt published Wire/Derive 0.13.2 for optional native metadata, keeping the
  canonical Types 0.15 pairing, Rust 1.91 floor, schemas, bytes and arithmetic-only
  feature isolation unchanged. Existing Wire 0.13 consumers remain compatible;
  no endpoint integration is added. See [the pairing guide](0.24.md).
- Use conservative documentation-only CI while retaining stable check names and
  complete release gates ([#107 — Adopt conservative documentation-only CI selection](https://github.com/dragginzgame/ic-observability/issues/107)).
  The required Shared helpers are adopted from committed 0.27.23.
- Require uploads from the clean, remotely tagged group release. Add verified
  publication and readback-only commands using Shared's registry/provenance
  helpers; failed verification never repeats an upload.
- Clarify published installation options and make packaged documentation links
  independent of the repository layout.

### 🧪 Testing

- Maintain an independently locked Principal/Account schema and byte-compatibility
  consumer with native/Wasm floor checks, outside the arithmetic graph. Type-check
  generated Metrics clients alongside the existing runtime byte conformance.

## [0.24.1] - 2026-10-31

### 🔧 Changed

- Adopt Shared Tooling's complete root member catalog and group-owned version
  requirements, with the 0.27.22 single-block catalog layout.
  Release preparation advances only the selected group's root requirement and
  rejects stale catalog entries, including unused aliases in other groups.
- Clarify delegated delivery and explicit Cargo cleanup scope. Metrics' API,
  compiler floor, feature isolation and Wire 0.13 pairing are unchanged.

## [0.24.0] - 2026-10-31

### ⚠️ Breaking

- Adopt Wire/Derive 0.13.0 for native metadata and align composed Principal/Account
  schemas with canonical Platform Types 0.15. Native schema consumers must select
  matching Metrics/Wire identities. Arithmetic, typed errors, schema shapes and
  encoded bytes are unchanged; minimal arithmetic and Wasm stay independent of
  Wire, Platform and endpoints. See [migration](0.24.md).

## [0.23.2] - 2026-10-31

### 🔧 Changed

- Adopt the shared peer-group release layout: Metrics owns its literal version
  and this ledger; the workspace root holds common metadata and navigation.
  Release, resume and publication require explicit `RELEASE_GROUP=metrics`.
  Coordinated history is preserved separately. Package versions and runtime
  contracts are unchanged. See [group commands](../../docs/independent-releases.md).

## [0.23.1] - 2026-10-31

### 🔧 Changed

- Release Metrics and Logging independently in one workspace. Select
  `RELEASE_GROUP=metrics` (default) or `logging` for release, resume and
  publication. Existing numeric versions remain 0.23.0; arithmetic, log behavior
  and dependency boundaries are unchanged. See [group ownership and commands](../../docs/independent-releases.md)
  and [#104 — Version Metrics and Logging independently](https://github.com/dragginzgame/ic-observability/issues/104).
- Adopt the committed Shared Tooling group machinery and published IC Build
  0.73.0 metadata editor through managed setup; prepare the new editor before
  using the group commands.
