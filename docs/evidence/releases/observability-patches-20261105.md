# Metrics 0.29.2 and Logging 0.24.7 delivery — 2026-11-05

> Historical release receipt. See [evidence retention](../README.md#retired-raw-evidence)
> for current artifact availability; the original identities and observations below are not fresh qualification.

Both independent patches were released through the normal `main` checkout and
standard direct adapters to `origin/main`, then uploaded once each to crates.io.
The implementation is `87cd195d44ec7dd4709318cedd532dc559f1897c`.

| Group | Qualified source | Release commit | Annotated tag |
| --- | --- | --- | --- |
| Metrics | `87cd195d44ec7dd4709318cedd532dc559f1897c` | `3af657f0e968b8f405704633c581aa0869dee1c4` | [metrics-v0.29.2](https://github.com/dragginzgame/ic-observability/releases/tag/metrics-v0.29.2) |
| Logging | `3af657f0e968b8f405704633c581aa0869dee1c4` | `f82bd69539387e8d7d8c0ec697b0e2e36d6c7e29` | [logging-v0.24.7](https://github.com/dragginzgame/ic-observability/releases/tag/logging-v0.24.7) |

Tag objects are `789b5ab0cd08fd2bd7638576a365840b8c604bc3` and
`8021d583049e58d8c10dd3bbe261f9db6e87e60e`, respectively. Each runner atomically
pushed its exact branch/tag and changed only the selected group's manifest,
catalog version, lock entry and owning changelog. Both ledgers are finalized.

The [rule audit](../../reports/audits/2026/11/05/shared-tooling-adoption/01/report.md)
retains the original review, focused checks and missing-document finding.
The [remediation receipt](../tooling.md) owns the
separately authorized Shared Tooling repair and fresh consumer qualification.
Shared 0.30.0 is selected at `b37a882314d22bf7ab393b3fe561809377ffd22d`, with
150 verified files. Its source ledger remains Unreleased; no Shared tag/release
is inferred. [Shared #355 — Complete exported documentation closure for LOC classification and audit guidance](https://github.com/dragginzgame/shared-tooling/issues/355)
is fixed, pushed and closed. No other sibling was changed by this deployment.

The changes preserve library APIs, recording/overflow/reset semantics and
retained-data contracts. Allocator-free qualification moved into test source
under an explicit LOC role while retaining the Cargo/artifact identity. Private
consumer fixtures declare their test role and compiler inheritance. Publication
lint selects only the requested independent group, preserving native/Wasm,
all-feature/target coverage and original failure stopping.

Each group selected workspace scope and passed every one of the 21 release
stages, including strict Clippy before product tests/archives, source/graph
admission, actual allocator-free Wasm linking, Rustdoc, package verification and
release/recovery fixtures. No stage reuse, version projection or gate narrowing
ran. Sealed plans/proofs and logs remain at:

- `target/release-validation/metrics-0.29.2.jtrVRS/`
  (`logs/validation.007Wqg`)
- `target/release-validation/logging-0.24.7.nPU7Sl/`
  (`logs/validation.UH5Bq6`)

The protected `.git/release-state/metrics-0.29.2.plan` and
`logging-0.24.7.plan` are complete. Metadata preparation separately compiled the
actual final archives. Both publication dry runs passed before a single upload
per package. Independent official registry/archive/source readback confirms
non-yanked versions and exact clean Git identities, including all 29 maintained
Metrics files and all 13 maintained Logging files:

| Package | Registry | Archive SHA-256 |
| --- | --- | --- |
| ic-metrics 0.29.2 | [crates.io](https://crates.io/crates/ic-metrics/0.29.2) | `d8d9e8ee13b8607c3febfb07002659bdb47c4f490b4ea879ed017d66d4246538` |
| ic-logging 0.24.7 | [crates.io](https://crates.io/crates/ic-logging/0.24.7) | `853290a163d57a44a8b8d76d6ccdd2fa890f30e6e781baafbb1bdce8a4ce372e` |

Dry-run attempts: `target/publication/check.selection.ke8NmM/` and
`check.selection.NDlKGh/`. Completed upload intent/arguments/status:
`target/publication/publish.selection.qrMogt/` and `publish.selection.Qxk1iN/`.
Readback/provenance: `target/publication/verification.8GnHLE/` and
`verification.97gYtZ/`. Top-level release/publication transcripts and the original
unpublished registry observations remain under
`target/deploy/observability-20261105/`. Do not upload these versions again;
`make verify-publication RELEASE_GROUP=metrics` or `logging` reconciles read-only.

Pre-existing lowercase Cargo catalog comments were separately preserved in stash
`a8d87d1f41fa48a784c56ccef7302b9ed0dd12ef` and the deployment directory. They are
restored after delivery while retaining both new package versions. Older stashes,
including `06ee2eaf4bf79bc230b27c702fbdd62d7acd9e44`, and original failure/recovery
inputs remain. No artifact/store cleanup, history rewrite or tag replacement ran.

These are local Linux/Rust 1.99.1 and registry observations. Configured hosted
Linux and Intel/Apple Silicon macOS CI continues asynchronously; this receipt
does not establish a fresh hosted three-host pass. Source and fixture evidence
is not installed consumer or deployed IC runtime qualification.
