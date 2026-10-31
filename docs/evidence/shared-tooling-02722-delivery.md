# Shared Tooling catalog patch delivery — 2026-10-31

The maintainer authorized release and crates.io publication after
[PR #106](https://github.com/dragginzgame/ic-observability/pull/106) merged.
The completed delivery contains compatible tooling changes, with finalized
[Metrics notes](../../releases/metrics/CHANGELOG.md#0241---2026-10-31) and
[Logging notes](../../releases/logging/CHANGELOG.md#0233---2026-10-31).

| Package | Registry version | GitHub tag | Release commit |
| --- | --- | --- | --- |
| Metrics | [0.24.1](https://crates.io/crates/ic-metrics/0.24.1) | [metrics-v0.24.1](https://github.com/dragginzgame/ic-observability/tree/metrics-v0.24.1) | `1e7193f77107a528cd99492b40df6750ddd445b5` |
| Logging | [0.23.3](https://crates.io/crates/ic-logging/0.23.3) | [logging-v0.23.3](https://github.com/dragginzgame/ic-observability/tree/logging-v0.23.3) | `064ee4963f38db34d4e4b9ac931177364dbbfd65` |

Both standard direct release commands passed their complete local ci/msrv gates,
verified the prepared workspace archives, and atomically pushed main and the
selected annotated tag. Both publication dry runs and actual uploads passed the
standard native/Wasm Clippy gate and Cargo archive verification. Each publication
completed its registry-availability check. Remote readback confirms the exact
annotated tags peel to the release commits above.

All five [PR CI jobs](https://github.com/dragginzgame/ic-observability/actions/runs/41222410976)
passed on head `0710dac5d74e02582ab95eceed203252452371ab`: TypeScript, Rust 1.91
MSRV, Linux x86_64, Intel macOS and Apple Silicon macOS. These remain identified
as pre-release source evidence; they do not stand in for the separate local
release gates or establish new installed IC/runtime measurements.

## Registry readback

Both official sparse-index entries report the new versions as non-yanked.
Downloaded official archives match their index SHA-256 checksums:

| Archive | SHA-256 |
| --- | --- |
| ic-metrics-0.24.1.crate | `744346d56fe0994acc3b39aed3e2139c62f91d4924d0b466a19cbb375c3d66ad` |
| ic-logging-0.23.3.crate | `a73dfd2a7bc6e594465ab02f366f5b919daeb77fdb64fcb4460d460b305249cf` |

Each archive records clean Git provenance at its exact release commit and owning
package directory. Its maintained source-file roster, every source file and
original package manifest match this repository. Registry dependency, feature
and Rust-floor declarations match
the previous versions, Metrics 0.24.0 and Logging 0.23.2. Logging still has no
dependencies. The workspace lock changed only the two local package versions.

The crates.io API returned HTTP 403 during initial observation; absence and final
publication claims use successful official sparse-index reads and verified static
archive downloads. No failed API response is treated as registry absence.

## Retention and source identity

Actual release, publication and readback logs remain locally under
`target/deploy/shared-tooling-02722-20261031/`, with exact publication intents and
statuses under `target/publication/`. Standard plans and validated/prepared
receipts remain under `.git/release-state/metrics-0.24.1*` and
`.git/release-state/logging-0.23.3*`. No cleanup ran and no sibling checkout changed.

The adopted Shared revision remains the maintainer-confirmed
`143a9abb9ae81feae9400ff3844b03b1ddfdd75a`. Its commit/changelog identify the
0.27.22 changes while its committed VERSION is 0.27.21; the canonical snapshot
preserves that display version and exact revision. Release delivery neither
relabels provenance nor changes the public Metrics/Logging contracts.
