# Metrics/Wire separation — 2026-11-03

Local implementation of
[#128 — Remove Metrics' Wire metadata dependency](https://github.com/dragginzgame/ic-observability/issues/128)
on base `1f2740fc43304492a9fa38df693bb58b09e7f8ec`. The pending release is
Metrics 0.28.0; actual package versions remain Metrics 0.27.2 and Logging 0.24.3.
No staging, commit, release, upload or sibling mutation was performed.

## Boundary and preserved contracts

Metrics has no Wire dependency, feature, derive or schema implementation.
Validated Serde records retain their field names, declaration order, u128 totals,
fixed arrays and canonical `from_parts` admission. Arithmetic implementations
are unchanged. The private serialization module is now `transport`; its tests
retain empty/zero/wide/exact-cap/actual-loss cases and numeric-state refusals,
with independent literal representation assertions.

Services own DTOs, schema generation, codec limits, endpoints and generated
clients. There is no new integration crate or production DTO wrapper. Metrics'
Node/npm setup, browser job and source/registry pairing inputs are retired.
Historical receipts/artifacts are unchanged, and retired qualification READMEs
identify their original scope. Native CI keeps Linux and both macOS hosts;
the retired job has no enforced required-check reference on main at inspection.
Release validation still selects the complete `ci msrv` gates. Parsed retained
consumer fixtures and independent group/rollback/receipt checks remain selected.

## Focused evidence

All executed checks pass on Linux with Rust/Cargo 1.99.1:

- Strict native all-target/all-feature Metrics Clippy and Wasm library Clippy.
- All 79 Metrics library tests, including independent restoration/recording
  models and six Serde transport cases; all 15 doctests.
- Real allocator-free Wasm link with default features disabled.
- Four Metrics normal/build graph profiles and independent native/Wasm Logging
  checks. Required Serde remains; Wire/Platform families are absent throughout.
- Declaration admission and its invalid optional/target/build/development Wire,
  feature-forwarding, malformed observation and retired-feature cases.
- CI selection/fallback, retained-consumer rendering, standard Make routing and
  real disposable group-release admission fixtures. Broad gates/uploads are
  substituted in those fixtures; no product release is claimed.
- ShellCheck, Actionlint, formatting, dependency pins, documentation links and
  unchanged 142-file Shared Tooling snapshot verification.

A separate temporary comparison under `target/issue-128/byte-compat/` uses
published Metrics 0.27.2 and Wire 0.15.0 alongside a workspace-owned current-source
Metrics 0.0.0 copy. Two tests pass: independently declared test DTO schemas match
the published traits; all four numeric shapes retain identical encoded bytes
across empty, zero, wide, exact-cap and lost-count/total states; generic decode
still rejects invalid arithmetic. Wire exists only in that temporary comparison,
not the maintained workspace graph. This is migration evidence, not acceptance
of any actual service endpoint, browser client or installed canister.

## Coordination and retained inputs

The [migration guide](../../releases/metrics/0.28.md) links the existing Blob,
IcyDB, Relay, Storage and Canic owners. Their issues remain open; source review
is not their runtime/schema acceptance. Toko Miner's owner also needs to remove
an explicit feature selection during adoption. No consumer code was exported or
edited. Timers was unavailable in this checkout; its arithmetic-only assessment
remains with #128's owning inspection rather than a new local qualification claim.

Raw logs, source hashes and disposable fixture evidence are under
`target/issue-128/`. The pre-existing README/lock changes are saved in
`pre-existing.patch` and original file copies there. README guidance was reconciled
with this approved boundary; the pending Wire 0.15.1 lock refresh is superseded
by removing Wire. All retained lock packages keep their original versions,
checksums and dependencies; only Metrics' Wire edge and unused packages disappear.
Logging's implementation, manifest, version and ledger are unchanged.
Full `ci msrv`, hosted/macOS checks and consumer runtime qualification were not
run. No local implementation blocker remains; delivery remains separate.
