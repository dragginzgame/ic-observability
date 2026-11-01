# Metrics changelog

This is the canonical ledger for the independent `metrics` release group.
Shared Metrics/Logging release history through 0.23.0 remains once in the
[shared historical ledger](../history.md#0230---2026-10-31).
Metrics and Logging each own their package version and release notes.

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
