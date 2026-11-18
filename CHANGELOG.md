# Changelogs

Metrics and Logging are independent peers. This workspace has no aggregate
release version. Each group owns its release ledger:

- [Metrics releases](releases/metrics/CHANGELOG.md)
- [Logging releases](releases/logging/CHANGELOG.md)
- [Coordinated history through 0.23.0](releases/history.md)
- [Group commands and recovery](docs/releases/independent-releases.md)

## Maintainer tooling — Metrics 0.30.14 / Logging 0.25.13

- Reject missing, empty, malformed or incomplete Cargo package inventories before
  package-document validation can report success.
  [Observability #138](https://github.com/dragginzgame/ic-observability/issues/138).
- Delegate setup redaction to the selected shared diagnostic helper, excluding
  URL fragments and queries from console output and collected artifacts while
  preserving command status and the existing environment-secret coverage.
  [Observability #139](https://github.com/dragginzgame/ic-observability/issues/139).
- Adopt Toko Tooling 0.45.8 through the authenticated exporter; preserve caller
  Cargo network settings while retaining locked dependencies and explicit offline
  fixture cases. Move remaining test declarations, group the persistence imports
  and remove the unused broad line-count lint allowance.

## Maintainer tooling — Metrics 0.30.13 / Logging 0.25.12

- Adopt Toko Tooling 0.45.3 through the authenticated exporter, including frozen
  batch timing summaries and publication package-count observations. Retain fresh
  product gates without enabling optional stage sealing or changing other dependencies.
- Remove orphaned TypeScript npm configuration and its obsolete ignore entry;
  preserve installed-dependency exclusion coverage with a synthetic fixture.
  [Observability #137](https://github.com/dragginzgame/ic-observability/issues/137).

## Maintainer tooling — Metrics 0.30.9 / Logging 0.25.9

### ▶️ Try it

From this repository's root, with the `toko-cloc` PATH launcher installed as in
the [development guide](docs/development/hosts.md), and Cargo.lock selecting
toko-tooling 0.44.11:

```sh
make toko-tooling-update  # One-time setup: downloads tooling and prepares local tools.
toko-cloc
toko-cloc -d 0
toko-cloc -d 1
toko-cloc -d 2
toko-cloc -d 1 ic-metrics::recording
```

The first two reports are identical compact totals. Repository/workspace `-d 1`
adds crate rows; `-d 2` adds top-level modules. A named module's `-d 1` expands
its immediate children. JSON counts are unchanged.

The CI-only follow-up corrects native-prerequisite shell quoting and qualifies
the actual workflow body for Linux/macOS setup and failure paths.

## Maintainer tooling — Metrics 0.30.8 / Logging 0.25.8

### ▶️ Try it

From this repository's root, with the `toko-cloc` PATH launcher already installed
as described in the [development guide](docs/development/hosts.md), and Cargo.lock
selecting toko-tooling 0.44.2:

```sh
make toko-tooling-update  # One-time setup: downloads tooling and prepares local tools.
toko-cloc
toko-cloc -d 0
toko-cloc -d 1
```

The first two reports are identical and include crate rows. Explicit `-d 1`
expands source modules. These reporting commands do not change product versions.

## Maintainer tooling — Metrics 0.30.7 / Logging 0.25.7

### ▶️ Try it

From this repository's root, after Cargo.lock selects toko-tooling 0.43.2:

```sh
make toko-tooling-update  # One-time setup: downloads tooling and prepares local tools.
make release-batch-timings BATCH=batch-SPBo7uq9
```

Normal readback prints retained phase timings as JSON without network access,
credentials, release or publication. The example uses this deployment's retained
local batch; substitute one retained in your checkout. Older batches without
timing instrumentation return `[]`.
