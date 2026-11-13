# IC Observability documentation

Start with the product contract you need. Metrics and Logging are independent
libraries; their application, storage and reporting adapters have separate owners.

## Product guides

| Need | Guide |
| --- | --- |
| Package selection and quick start | [Repository README](../README.md), [Metrics](../crates/ic-metrics/README.md), [Logging](../crates/ic-logging/README.md) |
| Recording and consumer ownership | [Extraction contract](architecture/extraction.md) |
| Complete current Metrics surface | [API inventory](architecture/metrics-api.md), [0.29 migration](../releases/metrics/0.29.md) |
| Heap logging, checkpoints and durable-adapter boundary | [Logging contract](architecture/logging.md) |
| Component origins and external build inputs | [Source inventory](governance/source-origins.md) |

IC Storage owns the separately selected
[`ic-metrics-storage`](https://github.com/dragginzgame/ic-storage/tree/main/crates/ic-metrics-storage)
and [`ic-logging-storage`](https://github.com/dragginzgame/ic-storage/tree/main/crates/ic-logging-storage)
adapters. These are external to this workspace. Neither library includes a
storage dependency.

## Development and delivery

- [Host guide](development/hosts.md): focused commands, prepared tools and evidence limits.
- [Independent releases](releases/independent-releases.md): explicit group selection,
  publication and recovery.
- [Current handoff](status/current.md): local work and retained recovery state.
- [Changelogs](../CHANGELOG.md): independent ledgers and coordinated history.
- [Evidence index](evidence/README.md) and [release receipts](evidence/releases/README.md):
  recorded observations for their exact source versions.

## Shared tooling references

The root [baseline](../TOKO-TOOLING.md) and
[snapshot receipt](../.toko-tooling.snapshot) identify managed shared material.
Executable payloads and operational catalogs live under `vendor/toko-tooling/`;
consumer scripts, workflows and release policies remain outside it.
Product-specific instructions remain in [AGENTS.md](../AGENTS.md) and the guides
above.

- [Adoption and installation](https://github.com/dragginzgame/toko-tooling/blob/8eb734758129eef2d2190c4fd22e00b52525f41a/docs/adoption/consuming-snapshots.md)
- [Migration history](https://github.com/dragginzgame/toko-tooling/blob/8eb734758129eef2d2190c4fd22e00b52525f41a/docs/adoption/migrations.md)
- [Local setup](https://github.com/dragginzgame/toko-tooling/blob/8eb734758129eef2d2190c4fd22e00b52525f41a/docs/adoption/local-setup.md) and [Make interface](https://github.com/dragginzgame/toko-tooling/blob/8eb734758129eef2d2190c4fd22e00b52525f41a/docs/adoption/make-interface.md)
- [Tool inventory](https://github.com/dragginzgame/toko-tooling/blob/12459b6029115b830b8477879d3bea2f030b6e63/docs/tools/tool-inventory.md)
- [Validation helpers](https://github.com/dragginzgame/toko-tooling/blob/12459b6029115b830b8477879d3bea2f030b6e63/docs/validation/verification-helpers.md)
- [Shared release contract](https://github.com/dragginzgame/toko-tooling/blob/12459b6029115b830b8477879d3bea2f030b6e63/docs/releases/releases.md)

Shared reference documentation stays upstream. This checkout
installs the root baseline, canonical distribution files, executable entrypoints
and their runtime inputs. Product guides remain local; the receipt identifies
the managed files. The links above pin the reviewed upstream release commit.

## Earlier contracts

Versioned migration guides retain their original API and dependency scope:

| Release line | Migration guidance |
| --- | --- |
| Metrics/Logging 0.18 | [0.18 contract](migrations/0.18.md) |
| Metrics 0.19–0.23 | [0.19](migrations/0.19.md), [0.20–0.21](migrations/0.20.md), [0.22](migrations/0.22.md), [0.23](migrations/0.23.md) |
| Metrics 0.24–0.29 | [0.24](../releases/metrics/0.24.md), [0.25](../releases/metrics/0.25.md), [0.26](../releases/metrics/0.26.md), [0.27](../releases/metrics/0.27.md), [0.28](../releases/metrics/0.28.md), [0.29](../releases/metrics/0.29.md) |
| Logging 0.24 | [0.24](../releases/logging/0.24.md) |

Historical handoffs through [0.7.3](status/history-through-073.md) and
[0.11.0](status/history-through-0110.md) retain their earlier observations.
Audit reports cover [measurement needs](reports/audits/2026/10/09/measurement-needs/01/report.md),
[architectural sediment](reports/audits/2026/10/18/architectural-sediment/01/report.md)
and [tooling adoption](reports/audits/2026/11/05/shared-tooling-adoption/01/report.md).
These reports and the protected release receipts do not establish current
consumer or installed acceptance; use the current contracts above for new adoption.
