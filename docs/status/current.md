# Current handoff — 2026-11-09

## Published typed recording APIs

Metrics **0.29.8** and Logging **0.24.13** are delivered to origin/main and
published, non-yanked and independently verified against their source archives.
The [delivery receipt](../evidence/releases/typed-recording-20261109.md) owns
exact commits, annotated tags, archive hashes, plans and publication evidence.
Never re-upload these versions. Both ledgers are finalized; no next release is
selected. The normal checkout was explicitly reconciled with the completed batch.

Logging supplies `BoundedHistory<T>`: fixed count/accounted-payload limits,
oldest-row eviction receipts, intact typed refusals, borrowed reversible rows
and clear. Callers own sanitization, field bounds, timestamp precision/order,
privacy and lifecycle. No typed-history checkpoint or codec is introduced;
existing `Log`/checkpoint behavior is unchanged. Producer
[#131](https://github.com/dragginzgame/ic-observability/issues/131) is complete;
Canic [#755](https://github.com/dragginzgame/canic/issues/755) owns adoption.

Metrics supplies `BoundedCounterTable<K>` and `LexicalMeasurementTable<K>` under
`recording`. Typed first-admitted scalars preserve original increments; lexical
measurements merge complete evicted histories into omitted accounting. Both
support borrowed existing-key updates. Lexical construction requires checked
`entries * key_bytes` covered by the total key budget for arrival-order-independent
identity selection. Charges exclude automatic metadata/allocator measurement.
Producer [#132](https://github.com/dragginzgame/ic-observability/issues/132) is
complete; Canic [#756](https://github.com/dragginzgame/canic/issues/756) retains
partitioning, attribution, reports and consumer/installed acceptance.

Both groups passed their complete 20-stage local workspace release plan, final
archive compilation and independent registry readback (34 Metrics and 16 Logging
maintained files). No stage reuse or scope narrowing was enabled. Hosted/native
macOS checks remain separate and asynchronous; pending, failed or cancelled
checks are not passes. No IC cost measurement or sibling acceptance is implied.
No sibling repository was modified or deployed.

## Deferred work and recovery custody

The pre-existing syn 3.0.10 Cargo.lock edit is restored, uncommitted and excluded
from these releases. Capture used the committed syn 3.0.9 graph. The original
edit remains preserved in stash `de3f936fd3e93d094ddf5ff5d7129a8104119f0c`, pinned
by branch `preserved/syn-3.0.10-typed-recording-20261109`. Do not discard it or
mistake the dirty normal lock for the published graph.

Batch `batch-vgM1oJ1f` is complete at index 2. Its candidate is retained under
`target/release-frozen/batch-vgM1oJ1f`, with durable recovery under
`.git/release-state/frozen/batch-vgM1oJ1f/`. Reconciliation completed; no retirement
or protected evidence cleanup ran. The delivery receipt records the initial
pre-capture clean-source refusal and subsequent preservation/recovery.

Earlier completed batches `batch-gfJA5IMg` and `batch-z30yB8KG` retain their
candidates and Git-side recovery. Failed pre-delivery batch `batch-C8a10ddy`
remains retained and must not be resumed as repaired source. The
[previous delivery receipt](../evidence/releases/observability-patches-20261108-toko036.md)
owns those source and admission-repair identities. Earlier stashes, including
`a7dbbac568a37876f37f8a89607545a5fba389b2` and
`e5bedde93b31a520a4ff282071099152cb04c555`, remain untouched. The
[evidence retention index](../evidence/README.md) owns private-source custody
and historical evidence; no source/export authority is implied by read access.

## Installed Cargo-selected toko-tooling 0.36.0

Root `[workspace.dependencies]` declares `toko-tooling = "=0.36.0"` once. Both real
members inherit it unconditionally as a dev-dependency with cargo-machete ignored
metadata and no artificial Rust import. The root remains virtual, with no
selection-only package, metadata selector or separate tooling lock. Cargo.lock
and the snapshot select registry archive SHA-256
`de0dd05b6437061622a76942baa25d40d2181497e7ba66d9fd809132a3082936`; all 97 roots
and 168 installed files agree. Production library graphs remain dependency-free.

After intentionally changing the pin, resolve Cargo.lock with Cargo, then run
`make shared-tooling-update` or `make shared-tooling-install`. Neither installer
resolves the application graph. Offline admission checks declarations, lock and
installed bytes. Common CI/release targets and custom candidate, metadata and
publication adapters retain tooling admission before effects. The
[tooling summary](../evidence/tooling.md) retains prior observations and limits.

#130 remains closed for its producer scope. Remaining Profiler work belongs to
[Profiler #17](https://github.com/dragginzgame/ic-profiler/issues/17). The
[API inventory](../metrics-api.md) and [0.29 migration](../../releases/metrics/0.29.md)
retain the consumer map: Canic owns reporting, Storage owns governed stable
adapters, and each downstream owner retains acceptance.
