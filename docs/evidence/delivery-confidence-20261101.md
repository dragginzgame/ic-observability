# Delivery qualification improvements — 2026-11-01

The maintainer authorized integration, Git releases and crates.io publication of
this batch. [PR #111](https://github.com/dragginzgame/ic-observability/pull/111)
is merged at `86a0fc72a025bed92128e75bd45dc0e5307248d9`.

| Package | Published version | GitHub tag | Release commit |
| --- | --- | --- | --- |
| Metrics | [0.24.4](https://crates.io/crates/ic-metrics/0.24.4) | [metrics-v0.24.4](https://github.com/dragginzgame/ic-observability/tree/metrics-v0.24.4) | `063b462dbd2043bf9a37c503c3e9d5d296fe4c63` |
| Logging | [0.23.5](https://crates.io/crates/ic-logging/0.23.5) | [logging-v0.23.5](https://github.com/dragginzgame/ic-observability/tree/logging-v0.23.5) | `d8d64fa0492c23e0dd1f5332af3028258c17ef6c` |

This batch automates maintained archive-content comparison, adds registry-only
Principal/Account acceptance with explicit version intent, checks consumer Make
and Node/npm setup before release validation, records smoke outcomes in native
evidence, and extends Logging corruption/UTF-8 model coverage. Failed npm/Node
observations retain their status before any dependent action. Library APIs,
measurement arithmetic, schemas, encoded representations and Logging's heap
engine are unchanged. Shared Tooling remains reviewed 0.27.23 at
`619d194875369e0f72b45477b66adb430acbf6b7`.

## Release and publication evidence

Both standard direct releases passed their complete local CI/MSRV gates and
prepared archive checks, then atomically pushed main plus annotated group tags:
Metrics CI 137 seconds/MSRV 2 seconds; Logging CI 196 seconds/MSRV 4 seconds.
Both publication dry runs and uploads passed native/Wasm Clippy and Cargo archive
verification. Upload admission verified a clean exact tagged checkout and matching
remote tag. Each package uploaded once and passed the subsequent readback.
Metrics' fresh source fetch was slow but completed successfully; no upload replay
or fetch termination occurred.

Official registry metadata reports both versions as non-yanked. Downloaded
archives match their registry SHA-256 checksums:

| Archive | SHA-256 |
| --- | --- |
| ic-metrics-0.24.4.crate | `1a6018917ffc653f1ef13e4a09c1aaf10e273b00ec3fe341aef93442d2106f11` |
| ic-logging-0.23.5.crate | `b7cf3f28a20e059b02dff7095d80a448fd0a26043ea7a3a350970b9bce1f23d1` |

Each archive records clean provenance at its release commit and package directory;
the declared source was retrieved into a fresh Git store. Automated readback
compared every maintained package file against that source: 37 Metrics files and
11 Logging files, including Cargo.toml.orig and exact file rosters. Cargo-generated
Cargo.toml, Cargo.lock and provenance JSON retain their separate packaging and
provenance checks; they are outside the maintained-file byte comparison.

## Published consumer acceptance

After publication, the [registry consumer](../../qualification/wire-published/README.md)
was deliberately advanced from Metrics 0.24.3 to **0.24.4**. Only that package's
version/checksum changed in its independent lock. Root Cargo.lock and all other
qualified supplier records were preserved during this follow-up. The graph
continues to select Wire/Derive 0.13.2, canonical Types 0.15.1 and facade 0.15.2.

`make published-identities-check EXPECTED_METRICS_VERSION=0.24.4` passes strict
Clippy, all three real Principal/Account schema/byte/refusal tests on Rust 1.91,
and Wasm compilation. Metrics is a registry dependency; no Metrics source copy,
patch or external path package supplies that proof. Missing, malformed and stale
version intents refuse before Cargo effects. This is distinct from the existing
source-alignment probe, whose assertions also pass.

Platform suppliers remain private qualification dependencies. Arithmetic-only
Metrics still excludes Wire/Platform/endpoint integrations, and Logging remains
dependency-free. Downstream application/runtime qualification stays with its host.

On PR head `b33df20f4654b7bbc3b3ec208bad94b204024410`,
[hosted CI](https://github.com/dragginzgame/ic-observability/actions/runs/41290360613)
has passed change selection, Linux x86_64, Apple Silicon macOS, MSRV and TypeScript.
Intel macOS remains in progress at this observation. These are pre-release source
checks, distinct from complete local release gates and published-consumer proof.
No pending hosted check is counted as a pass.

Actual deployment logs remain under target/deploy/delivery-confidence-20261101/.
Publication receipts are target/publication/verification.YAOIMw and
target/publication/verification.38RFWN. Standard plans and source/validation
receipts remain under .git/release-state/metrics-0.24.4* and
.git/release-state/logging-0.23.5*. Earlier focused logs remain under
target/improvements/delivery-confidence-20261101/ and
target/improvements/qualification-guards-20261101/. No artifact cleanup or
sibling edits ran. Historical Metrics 0.24.2 remains Git-only and unuploaded.
