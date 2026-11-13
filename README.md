# IC Observability

Portable measurement and diagnostic logging in one Rust workspace, with separate
application-selected crates.

The [documentation index](docs/README.md) separates product contracts, development
commands, shared tooling references and historical evidence.

| Crate | Responsibility | Status |
| --- | --- | --- |
| [ic-metrics](crates/ic-metrics/README.md) | Application instrumentation and optional bounded heap recording | Independent Metrics release group |
| [ic-logging](crates/ic-logging/README.md) | Bounded heap logs, UTF-8-safe truncation, explicit age retention and scan-bounded cursor pages | Heap engine with validated checkpoint restoration |

The workspace is the renamed IC Metrics repository. It shares one catalog,
lockfile and compiler policy, with independent `metrics` and `logging` release
groups. Neither library
depends on the other. Consumers can keep selecting `ic-metrics` by its existing
package name; logging is a separate opt-in dependency.

Both libraries are `no_std` and have no production dependencies. Fixed Metrics recording is allocation-free;
Metrics' optional `recording` feature and the Logging library use `alloc`.
Applications own attribution, labels, clocks, authorization, lifecycle and
endpoints. Canic's metrics adapter owns the shared reporting endpoint and DTOs.
Logging supplies no global recorder, timer or IC exports. The
[independent worker example](crates/ic-logging/examples/worker.rs) demonstrates
logging without Canic. The
[byte-budgeted export example](crates/ic-logging/examples/byte-budgeted-export/main.rs)
checks exact UTF-8 row lengths before writing accepted rows into a bounded response,
with typed oversized-row errors and cursor continuation.
For the currently published Metrics API and separately selected heap logs:

```toml
[dependencies]
ic-metrics = "0.30"
ic-logging = "0.25"
```

Enable `recording` for bounded Metrics retention. Metrics follows
the [0.29 instrumentation boundary](releases/metrics/0.29.md): no general numeric
helpers or recorder Serde traits. Governed storage uses explicit restoration;
Canic's adapter owns report DTOs, validation, Wire schemas and generated clients.
The [API inventory](docs/architecture/metrics-api.md) and [Logging contract](docs/architecture/logging.md)
describe current behavior. Earlier migration guides retain their recorded scope
and are grouped in the [documentation index](docs/README.md#earlier-contracts).

[IC Storage](https://github.com/dragginzgame/ic-storage) owns
governed Storage integration, `ic-metrics-storage` and the separately selected
`ic-logging-storage` adapter. Logging's passive checkpoints carry validated state;
its heap engine acquires no storage dependency. See [the boundary](docs/architecture/logging.md)
for checkpoint, persistence and consumer qualification responsibilities.

## Release and package publication

Metrics and Logging use independent release groups in one workspace. Release,
resume and publication require an explicit `RELEASE_GROUP=metrics` or `logging`,
supplied on the command line or in the environment. Registry publication is a
separate maintainer action and selects only the chosen group's package:

```sh
make publish-check RELEASE_GROUP=metrics
# After reviewing the dry run, upload within the authorized delivery scope:
make publish-verified RELEASE_GROUP=metrics
# Logging:
make publish-check RELEASE_GROUP=logging
```

Any `PACKAGE` override must belong to the selected group. See
[independent releases](docs/releases/independent-releases.md) for version/ledger
ownership, selected validation work, measured stage costs and phase-specific recovery.
Each command runs the native/Wasm Clippy gate before Cargo publication. Neither
package depends on the other, so there is no publication-order dependency.
Toko Tooling owns package-selection mechanics and dispatch. This repository
declares its group policy, registry and validation target. Exact versions come
from locked offline workspace metadata; undeclared
packages are refused. Selection and attempt evidence is retained under
`target/publication`, including failed commands. Reconcile that evidence and the
registry before selecting another upload after a failure.
Consumers needing a new Logging API must select a version actually available in
the registry; a merged PR or workspace release tag alone does not supply it.
Uploads require a clean checkout of the selected group's annotated release tag,
with that exact tag already present in the declared GitHub repository.
`publish-verified` delegates to the existing publisher, then verifies non-yanked
registry metadata, the downloaded archive checksum and its clean source provenance.
`make verify-publication RELEASE_GROUP=metrics` repeats readback only. A failed
readback never retries the upload; retain and reconcile the separate receipts.

## Development

Use the pinned Rust 1.100.0 toolchain with rustfmt and Clippy. Starting with
Metrics 0.30.0 and Logging 0.25.0, both libraries require Rust 1.100.0 on native
and Wasm. [Local setup](https://github.com/dragginzgame/toko-tooling/blob/12459b6029115b830b8477879d3bea2f030b6e63/docs/adoption/local-setup.md) owns explicit
common-tool preparation through `make install-tools` and offline admission with
`make tools-check`. Checks do not install tools or change dependency selections.

Select the affected package during development:

```sh
cargo test --locked --offline -p ic-logging --lib
cargo test --locked --offline -p ic-logging --doc
cargo run --locked --offline -p ic-logging --example worker
```

Use `-p ic-metrics` for Metrics checks and select `--features recording` for its
optional recorder. The [host guide](docs/development/hosts.md) owns focused commands and
evidence limits. Aggregate Make checks and full release gates cover both members
and retain their explicit validation authority. Registry publication remains a
separately selected action per package.

[Ownership](docs/architecture/extraction.md) · [Logging boundary](docs/architecture/logging.md) ·
[Changelogs](CHANGELOG.md) · [Current handoff](docs/status/current.md) ·
[Contribution rules](https://github.com/dragginzgame/toko-tooling/blob/12459b6029115b830b8477879d3bea2f030b6e63/rules/contributions.md)

## Licence

[Toko Studios Network Licence 1.0](LICENSE.md).

The [source inventory](docs/governance/source-origins.md) records current component origins
and the distinction between maintained source and external build inputs.
