# Changelogs

Metrics and Logging are independent peers. This workspace has no aggregate
release version. Each group owns its release ledger:

- [Metrics releases](releases/metrics/CHANGELOG.md)
- [Logging releases](releases/logging/CHANGELOG.md)
- [Coordinated history through 0.23.0](releases/history.md)
- [Group commands and recovery](docs/releases/independent-releases.md)

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
