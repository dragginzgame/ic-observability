# Qualification models delivery — 2026-11-01

The maintainer authorized deployment of the [qualified improvement batch](qualification-models-20261101.md).
[PR #117](https://github.com/dragginzgame/ic-observability/pull/117) merged source
`1c8541ed310d266e99c93795b7e7da4a11ccb7d0` as
`2955b221430d20936311db4c9cbe65bcd25a9707`. It delivers published-consumer CI
artifact retention, Wire/Derive 0.13.5 qualification and extensions to the existing
independent Logging/histogram models. Library implementation, APIs, schemas,
encoded/retained formats and independent production graphs remain unchanged.

| Package | Published version | Annotated tag | Release commit |
| --- | --- | --- | --- |
| Metrics | [0.24.6](https://crates.io/crates/ic-metrics/0.24.6) | [metrics-v0.24.6](https://github.com/dragginzgame/ic-observability/tree/metrics-v0.24.6) | `c750c0063d7ec772629688d5525c2fce1d98bf9b` |
| Logging | [0.23.7](https://crates.io/crates/ic-logging/0.23.7) | [logging-v0.23.7](https://github.com/dragginzgame/ic-observability/tree/logging-v0.23.7) | `afcb8e775a7536ea19f37b361f9b55086dd073f9` |

Both standard direct patch releases passed complete local CI/MSRV and package
archive checks before version preparation. Metrics CI/MSRV passed in 146/6
seconds; Logging in 131/2 seconds. Each release atomically pushed main and its
annotated group tag. Each publication dry run and actual upload passed the
standard native/Wasm Clippy and Cargo verification checks from its clean exact
release checkout, admitted against the remote tag. Each upload ran once.

Independent readback reports both official registry versions as non-yanked.
Downloaded archives match these SHA-256 checksums:

| Archive | SHA-256 |
| --- | --- |
| ic-metrics-0.24.6.crate | `974bab94f2b55223260c5c74d6c5797206e4f5286635a66f3b4606c04eaf04d4` |
| ic-logging-0.23.7.crate | `868a4bd157d8baebc03708c7dcbff485a49db1ff86160d6ee142c4bb37fe7bb9` |

Archive provenance identifies the clean exact release commit and package path.
Each source commit was retrieved into a fresh Git store; maintained file rosters
and bytes match that source: 38 Metrics files and 12 Logging files. Generated
Cargo metadata retains its separate packaging/provenance checks. Readback
receipts remain at target/publication/verification.7cvYXP and
target/publication/verification.L6iQ74. Both group journals remain under
.git/release-state/; no failed release/publication attempt occurred in this batch.

After both uploads, the independent consumer and frozen CI intent advance to
Metrics 0.24.6 and Logging 0.23.7. Only those two version/checksum records change
in its lock; Wire/Derive 0.13.5, Types 0.15.1, facade 0.15.2 and all other package
records remain unchanged. The declared Wire minimum stays 0.13.2.
`make published-identities-check EXPECTED_METRICS_VERSION=0.24.6` passes strict
Clippy, three real Principal/Account schema/byte/refusal tests, composition
execution on Rust 1.91 and Wasm compilation. Both libraries are actual registry
dependencies; no source copy or patch supplies them. The rejection fixture still
refuses absent, malformed and stale Metrics intent before Cargo effects.

On PR source `1c8541ed310d266e99c93795b7e7da4a11ccb7d0`,
[hosted CI](https://github.com/dragginzgame/ic-observability/actions/runs/41323708474)
has passed change selection, Linux native, MSRV and TypeScript. Both macOS jobs
remain in progress at this observation. Those jobs are separate from the
completed local release gates and exact published-consumer acceptance; pending
jobs are not passes. Later receipt/catalog checks retain their own identities.

Actual deployment logs, version-absence observations, private lock comparisons
and consumer execution remain under target/deploy/qualification-models-20261101/.
Earlier implementation evidence, including corrected lint/baseline preparation
failures, remains under target/improvements/qualification-models-20261101/.
No sibling edit, history rewrite, tag removal or artifact cleanup ran.
