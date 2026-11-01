# Logging changelog

This is the canonical ledger for the independent `logging` release group.
Shared Metrics/Logging release history through 0.23.0 remains once in the
[shared historical ledger](../history.md#0230---2026-10-31).
Logging's independent release series begins at 0.23.1. Future Logging notes
belong here.

## [0.23.4]

### 🔧 Changed

- Retain Logging's native check names while routing reviewed prose changes to
  documentation checks ([#107 — Adopt conservative documentation-only CI selection](https://github.com/dragginzgame/ic-observability/issues/107)); full release gates remain unchanged.
- Require a clean, remotely tagged Logging release before upload. Add verified
  publication and readback-only commands that check registry state, archive
  checksum and source provenance without retrying uploads.
- Document published installation and check packaged links without relying on
  repository-only files. The heap engine and dependency-free contract are unchanged.

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
