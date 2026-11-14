# Changelogs

Metrics and Logging are independent peers. This workspace has no aggregate
release version. Each group owns its release ledger:

- [Metrics releases](releases/metrics/CHANGELOG.md)
- [Logging releases](releases/logging/CHANGELOG.md)
- [Coordinated history through 0.23.0](releases/history.md)
- [Group commands and recovery](docs/releases/independent-releases.md)

## Pending maintainer tooling — Metrics 0.30.7 / Logging 0.25.7

### ▶️ Try it

From this repository's root, after Cargo.lock selects toko-tooling 0.43.2:

```sh
make toko-tooling-update  # One-time setup: downloads tooling and prepares local tools.
make release-batch-timings BATCH=batch-gobrWzyt
```

Normal readback prints retained phase timings as JSON without network access,
credentials, release or publication. Older batches, including this example,
return `[]` because they predate timing instrumentation. Use a newer batch ID
after the next independently authorized deployment.
