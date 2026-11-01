# Verification and Wire patch delivery — 2026-11-01

The maintainer authorized integration, release/publication and resolved issue
closure. PRs [#108](https://github.com/dragginzgame/ic-observability/pull/108),
[#109](https://github.com/dragginzgame/ic-observability/pull/109) and
[#110](https://github.com/dragginzgame/ic-observability/pull/110) are merged.
[#107](https://github.com/dragginzgame/ic-observability/issues/107) is completed.

| Package | Published version | GitHub tag | Release commit |
| --- | --- | --- | --- |
| Metrics | [0.24.3](https://crates.io/crates/ic-metrics/0.24.3) | [metrics-v0.24.3](https://github.com/dragginzgame/ic-observability/tree/metrics-v0.24.3) | `2e7b56fc93c20c95bffc401ea330102a172fdcd7` |
| Logging | [0.23.4](https://crates.io/crates/ic-logging/0.23.4) | [logging-v0.23.4](https://github.com/dragginzgame/ic-observability/tree/logging-v0.23.4) | `ee1f19e354b2a361d066f8bd7db08b5681a1542e` |

The delivery supplies conservative documentation-only CI, clean tagged-source
publication admission and verified registry readback, maintained independent
Principal/Account qualification, static TypeScript checks and package-shaped
installation documentation. Shared Tooling remains reviewed 0.27.23 at
`619d194875369e0f72b45477b66adb430acbf6b7`.

Metrics selects published Wire/Derive 0.13.2, with no endpoint integration.
The private source-aligned identity probe retains published Types 0.15.1 and
facade 0.15.2. These integration suppliers remain outside Metrics' production
and arithmetic-only graphs. Library APIs, arithmetic, schemas, encoded bytes
and Logging's dependency-free engine are unchanged. The
[Wire receipt](wire-0132.md) records supplier identities and focused qualification;
the [pairing guide](../../releases/metrics/0.24.md) describes consumer adoption.
Tooling's native metadata consumers can select published Metrics 0.24.3 with
Wire 0.13.2; no paired Logging release is required for that integration.
Downstream hosts still own their schema/runtime qualification.

## Validation and recovery

Both final standard direct release commands passed complete local CI/MSRV,
verified prepared archives and atomically pushed main and annotated group tags:
Metrics CI 147 seconds/MSRV 3 seconds; Logging CI 131 seconds/MSRV 2 seconds.
Both publication dry runs and actual uploads passed the standard native/Wasm
Clippy and archive checks. Each actual upload ran exactly once and was followed
by successful registry, checksum and clean source-provenance verification.

Earlier focused checks cover eight Rust 1.91 metadata/refusal tests, TypeScript
static checks and five runtime report cases, three real Principal/Account schema
and byte tests plus Wasm, and all four dependency profiles. Publication fixtures
exercise dirty/untagged source rejection, hostile Make overrides, unavailable
registry state, corrupt archives and no repeated upload after readback failure.
The actual native/MSRV evidence fixtures and classifier failure routes pass.

The first release attempt stopped before version mutation on stale evidence
fixture expectations; #109 repaired them. Metrics 0.24.2 subsequently completed
its local release gates and was tagged at
`92b525d97ac33675e6334e692d6b2b4f272ada9e`, but was **never uploaded**.
Hosted checks exposed older macOS Make syntax and bundled-npm setup defects.
PR #110 repaired both; the existing tag was preserved and delivery advanced to
0.24.3 through fresh complete gates. No published version or tag was rewritten.

On repair head `798454674676be4934800a605a73742de43f53be`,
[hosted CI](https://github.com/dragginzgame/ic-observability/actions/runs/41286024262)
has passed change selection, Linux x86_64, Rust 1.91 MSRV, TypeScript and Apple
Silicon macOS. Intel macOS remains in progress at this receipt's observation.
These are pre-release source checks, distinct from the local release gates and
registry readback; a pending hosted job is not recorded as a pass.

## Published archive verification

Official registry metadata reports both versions as non-yanked. Downloaded
archives match their reported SHA-256 checksums:

| Archive | SHA-256 |
| --- | --- |
| ic-metrics-0.24.3.crate | `265698e8d2b9d16f9b64493234e513aacd47aee33145cf3acb007a6a222db766` |
| ic-logging-0.23.4.crate | `746bbb782344df20429a5dcca4b4292889b8d04a9b2a0a2c8ffe8a125c1856c3` |

Each archive records clean Git provenance at its exact release commit and package
directory, and that source was retrieved from the declared GitHub repository into
a fresh object store. Maintained source rosters and all 32 Metrics/5 Logging source
files plus each original package manifest match the corresponding release commit.

Actual logs remain under target/deploy/verification-wire-0131-20261101/.
The original directory name does not override the explicit Wire 0.13.2 inputs.
Final registry/provenance receipts are target/publication/verification.V4g9H6
and target/publication/verification.OcYmu9. Release journals and earlier failed
logs remain under .git/release-state/. No artifact cleanup or sibling edits ran.
