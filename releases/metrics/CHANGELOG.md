# Metrics changelog

This is the canonical ledger for the independent `metrics` release group.
Shared Metrics/Logging release history through 0.23.0 remains once in the
[shared historical ledger](../history.md#0230---2026-10-31).
Metrics and Logging each own their package version and release notes.

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
  See [qualification evidence](../../docs/evidence/wire-0133.md).

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
