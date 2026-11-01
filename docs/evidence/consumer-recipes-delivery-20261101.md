# Consumer recipes delivery — 2026-11-01

The maintainer authorized integration, Git releases and crates.io publication.
[PR #114](https://github.com/dragginzgame/ic-observability/pull/114) delivered the
consumer examples and recording model; [PR #115](https://github.com/dragginzgame/ic-observability/pull/115)
repaired the retained-consumer fixture before either new package was released.

| Package | Published version | GitHub tag | Release commit |
| --- | --- | --- | --- |
| Metrics | [0.24.5](https://crates.io/crates/ic-metrics/0.24.5) | [metrics-v0.24.5](https://github.com/dragginzgame/ic-observability/tree/metrics-v0.24.5) | `780e1de855e9c02f901d49ebb5a0a5c7daac2f6d` |
| Logging | [0.23.6](https://crates.io/crates/ic-logging/0.23.6) | [logging-v0.23.6](https://github.com/dragginzgame/ic-observability/tree/logging-v0.23.6) | `0a9a9a7bfea8d2171732a0bfa6bfa986bb2f6e82` |

The release adds a compiled application-owned Metrics/Logging composition,
a tested byte-budgeted text-export recipe and an independent event-journal
model for bounded recording. Library APIs, production dependencies, arithmetic,
cursor semantics, schema shapes and retained/encoded formats remain unchanged.
Metrics and Logging still have no dependency on one another.

## Release gates and publication

Both final standard direct releases passed complete local CI/MSRV and archive
verification, then atomically pushed main plus their annotated tags. Metrics CI
passed in 148 seconds/MSRV 3 seconds; Logging CI in 139 seconds/MSRV 2 seconds.
Both dry runs and actual uploads passed the standard native/Wasm Clippy and
Cargo verification checks. Each package uploaded once from a clean exact group-tag
checkout admitted against its remote tag, then passed registry/source readback.

The first Metrics attempt failed before version/tag/upload mutation: the retained
consumer copied Logging's new explicit example manifest without the examples
directory. PR #115 copies declared examples for both supplier packages. Both
real group-admission directions passed, then fresh complete release gates ran.
The failed logs remain retained; no gate was weakened or skipped.

Official registry metadata reports both versions as non-yanked. Downloaded
archives match their reported SHA-256 checksums:

| Archive | SHA-256 |
| --- | --- |
| ic-metrics-0.24.5.crate | `440c378e52e275ae4ac3c9a5bcde619be9fa5b472cc59e9a3039b0c221a9004f` |
| ic-logging-0.23.6.crate | `6ea8e3fb4a31f52199d0214a78582f5be9aa5aa52a033d36ed0615dca7b3ba53` |

Each archive records clean provenance at its exact release commit/package path;
the source was retrieved into a fresh Git store. Automated readback compared all
38 maintained Metrics files and 12 Logging files, including exact rosters and
original manifests. Cargo-generated manifest/lock/provenance files retain their
separate packaging/provenance checks.

## Published consumer acceptance

After both uploads, the independent registry consumer and CI intent advanced to
exact Metrics **0.24.5** and Logging **0.23.6**. Only those two version/checksum
records changed in its lock. Wire/Derive 0.13.3, Types 0.15.1, facade 0.15.2 and
all other qualified suppliers remain unchanged. These integration suppliers do
not enter the arithmetic production graph; Logging remains dependency-free.

`make published-identities-check EXPECTED_METRICS_VERSION=0.24.5` passes strict
Clippy, all three real Principal/Account schema/byte/refusal tests on Rust 1.91,
actual composition execution on that compiler and Wasm compilation. Both libraries
are registry dependencies; only the probe is workspace-owned. The composition
counts log admission/truncation/eviction/refusal and verifies that resetting its
metrics window preserves log identity. Logging is a private consumer dev dependency.

Four export tests and nine recording tests passed on Rust 1.91 during focused
implementation, and both final full release gates include them. Export tests
cover UTF-8 body limits, oversized-first-row errors, empty filtered continuation
and count/scan ceilings. The recording oracle replays raw observations and key
admission rather than using the production map/cache/aggregate record method.
The source probe, formatting hook, Make adapters, workflow selection, Actionlint,
ShellCheck, graph profiles, dependency pins and package/repository links pass.

On repaired PR head `843062ba1447c5af440600633dcc142866fb29c8`,
[hosted CI](https://github.com/dragginzgame/ic-observability/actions/runs/41308135145)
has passed change selection, Linux, Apple Silicon macOS, Rust floor and TypeScript.
Intel macOS is still in progress at this observation. Those source-head checks
remain distinct from the release gates and exact published-consumer acceptance;
no pending job is counted as a pass.

Actual logs remain under target/deploy/consumer-recipes-20261101/. Readback
receipts are target/publication/verification.FEdTU9 and
target/publication/verification.OqQFpY. Standard journals and failures remain
under .git/release-state/, including the initial
validation-failures/20261101T124338Z-106473* logs. Earlier focused evidence stays
under target/improvements/consumer-recipes-20261101/. No cleanup, history rewrite
or sibling edits ran. The earlier Wire/delivery receipts retain their own scope.
