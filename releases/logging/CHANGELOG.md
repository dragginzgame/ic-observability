# Logging changelog

This is the canonical ledger for the independent `logging` release group.
Shared Metrics/Logging release history through 0.23.0 remains once in the
[shared historical ledger](../history.md#0230---2026-10-31).
Logging's independent release series begins at 0.23.1. Future Logging notes
belong here.

## [0.23.6]

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
