# Logging ownership and consumer boundary

IC Observability owns the independent `ic-logging` heap engine alongside Metrics.
Both packages share workspace release metadata; neither depends on the other.
Logging remains dependency-free `no_std` + `alloc`.

## Heap engine and checkpoints

The additive `BoundedHistory<T>` API retains opaque typed rows under fixed count
and caller-accounted payload-byte ceilings. Append evicts oldest rows, reporting
their count and payload charge; disabled or individually oversized inputs return
intact without mutating history. Borrowed double-ended iteration supports both
append order and newest-first projection. Clear drops rows/charges and keeps
limits. Rows need no codec or `Clone` implementation.

This history imposes no timestamp, sequence, schema, sanitization or checkpoint
contract. Consumers bound fields, charge retained content consistently, preserve
privacy and timestamp semantics, and must not grow charged content through
interior mutability. Byte limits do not automatically measure fixed metadata,
spare capacity or allocator overhead. The existing text `Log` and its stable
checkpoint representation are unchanged. Producer [#131](https://github.com/dragginzgame/ic-observability/issues/131)
supplies the primitive; Canic [#755](https://github.com/dragginzgame/canic/issues/755)
retains structured-diagnostic adoption and qualification.

Logging owns bounded append admission, UTF-8 truncation, explicit age-retention
batches and scan-bounded cursor pages. Callers supply time and choose limits,
labels, authorization, scheduling and instance identity. Paging borrows retained
rows rather than copying the complete history or computing an exact match total.
The [0.18 contract](../migrations/0.18.md) adds a combined retained-text budget,
append receipts and explicit topic presence matching. The budget counts text
payload, not all heap costs; count and byte pressure evict oldest rows.
`visit_page` provides the same bounded scan without a result collection.

The retained-byte configuration charges each row a fixed 96 bytes for metadata
plus the retained UTF-8 bytes of labels and truncated messages. It uses one
retention budget, with no separate row cap, and reports accounted use in constant
time. Oldest rows are evicted as needed. If the incoming row exceeds the whole
budget, append refuses before evicting rows or advancing either watermark.
Allocator overhead, spare capacity and checkpoint copies are outside this budget.

`Log::checkpoint()` borrows all rows, limits and append watermarks without copying
text or consuming the log. Hosts can encode that immutable view directly within
their own record/allocation budgets. It introduces no serialization dependency.

`Log::snapshot()` copies a complete checkpoint while retaining the original log.
`Log::into_snapshot()` consumes the log and moves its owned text into that same
checkpoint representation. The consuming accessor was introduced in
[PR #100 — Add consuming Logging checkpoint accessor](https://github.com/dragginzgame/ic-observability/pull/100)
and included in release 0.17.5. Consumers must select a published
Logging version containing that API before adopting it in their registry graph.

`Log::restore()` independently admits fixed bounds, contiguous sequence order,
nondecreasing timestamps, watermarks, total text budget and consistent truncated messages.
`Log::restore_retained_bytes()` checks the same row and watermark invariants and
recomputes metadata and text charges from retained rows under the saved budget. Empty
retained history preserves sequence/time watermarks and permanent exhaustion.
A checkpoint is passive state, not a byte format, authenticity proof or globally
unique instance identity. Decoders must bound allocation before constructing it.
No prior stable format is imported or migrated by the heap engine.

## Durable adapter

Durable checkpoint integration belongs at the Storage boundary. Hosts load a
log, call the heap engine's append/prune/page operations and save at explicit
checkpoint boundaries. Consult the [current IC Storage contract](https://github.com/dragginzgame/ic-storage)
before selecting an integration. `ic-logging-storage` refers to a historical adapter.

The original adapter qualification and publication integration are recorded in
the former Persistence repository:
[PR #138 — Qualify stable Logging rollback and upgrade behavior](https://github.com/dragginzgame/ic-persistence/pull/138)
and [PR #139 — Enable coordinated publication of IC Logging Stable](https://github.com/dragginzgame/ic-persistence/pull/139).

Original installed receipts qualify their exact source, graph and tools for
query non-persistence, update/upgrade rollback, reopen and empty-history
watermarks. They do not establish a later consumer's installed acceptance or IC
costs. Consumer lifecycle, decoding, identity, retention and checkpoint cadence
remain independently qualified contracts.

## Framework composition

Canic owns its configuration, topics, rendering, endpoint authorization and
retention timer. A heap-only integration may reset logs on upgrade/reinstall;
stable checkpoint adoption is a separate host choice with governed allocation
and installed qualification. There must be one authoritative log engine.
The [worker example](../../crates/ic-logging/examples/worker.rs) demonstrates framework
independence, without qualifying IC rollback or application acceptance.

The [publication guide](../../README.md#release-and-package-publication) distinguishes
workspace release from explicit publication of each package. The
[current handoff](../status/current.md) records observed release/adoption state and
source-bound qualification, rather than maintaining another version roster here.


## Consumer recipes

The [byte-budgeted export example](../../crates/ic-logging/examples/byte-budgeted-export/main.rs)
implements a caller-owned text format and body ceiling. Its tests cover exact
UTF-8 byte limits, oversized-first-row errors, filtered empty scans and bounded
continuation without losing a row. No new logging cursor or codec API is added.

Applications may compose Metrics and Logging to count log admission, truncations,
count/byte evictions and refusals
with scalar Metrics counters, without either library depending on the other.
Resetting the host's metrics window leaves log sequence/time watermarks intact.
Append receipts describe log admission only; they do not establish business or
paid-effect success. Refusals are counted without recursively appending more logs.
