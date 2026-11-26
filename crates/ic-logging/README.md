# ic-logging

Requires Rust 1.100.0 on native and Wasm, matching the workspace compiler policy.

Bounded, caller-owned heap logs without a framework or IC runtime dependency.
The library is `no_std` with `alloc`; it has no dependency on Metrics or any other crate.

```toml
[dependencies]
ic-logging = "0.24.13"
```

Logging has its own version and [changelog](https://github.com/dragginzgame/ic-observability/blob/main/releases/logging/CHANGELOG.md). Maintainers select
`RELEASE_GROUP=logging` for release and publication; see
[independent releases](https://github.com/dragginzgame/ic-observability/blob/main/docs/releases/independent-releases.md).

For structured diagnostics, `BoundedHistory<T>` retains opaque consumer-owned
rows with fixed count and caller-accounted payload-byte limits. It evicts oldest
rows, reports evicted row/byte counts, and returns individually refused inputs
intact. Iteration borrows oldest-first rows and can be reversed. Payloads need
neither `Clone` nor a codec. Callers retain field bounds, sanitization, privacy,
timestamp precision/order and lifecycle; no timestamp conversion or sequence ID
is imposed. Zero row capacity disables admission. This API has no checkpoint or
stable codec and does not change the existing `Log` engine or snapshot contract.

```rust
use ic_logging::{BoundedHistory, HistoryLimits};
let mut history = BoundedHistory::new(HistoryLimits { entries: 1, payload_bytes: 16 });
// The caller chooses and consistently charges retained payload content.
history.append((9_000_000_001_u64, "failure"), 7).unwrap();
let receipt = history.append((1, "next"), 4).unwrap();
assert_eq!(receipt.evicted, 1);
assert_eq!(receipt.evicted_payload_bytes, 7);
assert_eq!(history.entries().next_back().unwrap().0, 1);
```

Payload-byte accounting is a caller contract, not automatic heap measurement.
Fixed row metadata, spare capacity and allocator overhead are excluded unless
explicitly charged. Bound every payload field before append, and do not grow
charged content through interior mutability while retained. The history owns
immutable per-row charges and enforces their sum; it never normalizes payloads.

```rust
use ic_logging::{EntryInput, Filter, Level, Limits, Log, PageRequest};
use std::num::NonZeroUsize;

let mut log = Log::new(Limits {
    max_entries: NonZeroUsize::new(100).unwrap(),
    max_message_bytes: 1_024,
    max_label_bytes: 64,
    max_text_bytes: 64 * 1024,
});
let receipt = log.append(EntryInput {
    created_at_secs: 10,
    level: Level::Info,
    source: "worker",
    topic: Some("delivery"),
    message: "delivery accepted",
}).unwrap();
assert_eq!(receipt.sequence, 0);
assert!(!receipt.truncated);
assert_eq!(receipt.evicted, 0);

let page = log.page(Filter::default(), PageRequest {
    before: None,
    max_results: NonZeroUsize::new(10).unwrap(),
    max_scanned: NonZeroUsize::new(100).unwrap(),
});
assert_eq!(page.entries[0].message, "delivery accepted");
assert_eq!(log.next_expiry_secs(5), Some(16));
assert_eq!(log.prune_expired(16, 5, 20).removed, 1);
```

Limits are fixed for the lifetime of a log. Source and topic limits apply
individually; oversized labels refuse before mutation. Message limits apply to
retained UTF-8 bytes, including any truncation suffix. A zero message limit keeps
metadata and an empty message. The count is always positive; a caller disables
logging by not appending or not constructing a log.
`max_text_bytes` caps the sum of retained source, topic and message lengths.
It excludes row metadata, spare capacity, allocator overhead, transient append
buffers and checkpoint copies. An individually oversized row returns
`TextBudgetExceeded` before mutation. An admitted row evicts oldest rows until
both count and byte ceilings fit; append work can therefore visit up to the
configured retained row count. Its `AppendReceipt` reports the issued sequence,
message truncation and number of evicted rows. `retained_text_bytes()` reports
current payload use. Zero total text bytes still permits empty text and metadata.
Append refusals implement `core::error::Error` and preserve typed label/size/time
context for callers using `?` or their own error wrappers.

For a single retention budget, construct a `Log<RetainedByteLimits>` with
`Log::with_retained_byte_limit`:

```rust
use ic_logging::{EntryInput, Level, Log, RETAINED_ENTRY_OVERHEAD, RetainedByteLimits};

let mut log = Log::with_retained_byte_limit(RetainedByteLimits {
    max_retained_bytes: 512 * 1024,
    max_message_bytes: 160,
    max_label_bytes: 32,
});
log.append(EntryInput {
    created_at_secs: 1,
    level: Level::Info,
    source: "worker",
    topic: None,
    message: "",
}).unwrap();
assert_eq!(log.retained_bytes(), RETAINED_ENTRY_OVERHEAD + "worker".len());

let restored = Log::restore_retained_bytes(log.into_snapshot()).unwrap();
assert_eq!(restored.retained_bytes(), RETAINED_ENTRY_OVERHEAD + "worker".len());
```

The budget charges 96 bytes of logical metadata for every row, including empty
rows, plus the UTF-8 bytes of the source, optional topic and message after
truncation. The charge is fixed across targets and excludes allocator overhead,
spare capacity and checkpoint copies. `retained_bytes()` reports the current
charge in constant time. Labels and messages keep their per-field limits.
Append evicts oldest rows until the new row fits. A row that exceeds the entire
budget returns `AppendError::RetainedByteBudgetExceeded` before any eviction or
watermark change. A zero budget refuses every append.

Sequence IDs start at zero and never repeat within one log, even after all rows
expire. Timestamps cannot move backwards after retention. Sequence exhaustion
returns a typed error before eviction. This is an in-memory generation only:
creating another log starts a new sequence namespace.

An entry remains retained through `created_at_secs + max_age_secs`; it becomes
due in the next second. Overflowing deadlines return `None` and are never
scheduled early. Pruning removes at most the caller's batch limit. Appending
does not prune by age automatically; callers invoke retention and schedule their
own work using the reported deadline.

Pages scan from newest to oldest, after an optional exclusive sequence cursor.
Positioning uses a binary search; filtering examines at most `max_scanned` rows
and returns at most `max_results` borrowed entries. Follow `next_before` even
when a page contains no matches. Filters should stay the same across pages.
Retention may remove rows between calls; paging is not a frozen snapshot and
`scanned` is not a total matching count. Borrowed rows cannot mutate the log.
Topic selection is explicit: `TopicMatch::Any`, `TopicMatch::Absent` and
`TopicMatch::Exact(label)`. An absent topic differs from a present empty label.
`visit_page` runs the same scan without allocating a result collection. Its
callback returns `ControlFlow::Continue(())` or stops with `Break(())`; the
stopping row counts as delivered and the returned `PageScan` resumes before it.
The callback owns any allocation or encoding work it performs.

For a response byte ceiling, see the compiled
[byte-budgeted export example](examples/byte-budgeted-export/main.rs). It bounds the
returned UTF-8 body and keeps the next un-emitted row available when a candidate
does not fit. The callback's `Break` consumes that candidate in the engine, so
this recipe resumes from the last **emitted** sequence instead of blindly using
`PageScan::next_before`. A first matching row larger than the entire body budget
returns a typed `EntryTooLarge` error; callers can enlarge the budget or apply
an explicit policy. Empty filtered scans still follow the engine cursor.
The scan count includes an examined row that was not emitted. Temporary encoding
allocations and any transport envelope need their own host-selected limits.


`Log::checkpoint()` borrows the complete oldest-first entry iterator and both
watermarks without allocation, copying text or consuming the log. Its immutable
borrow keeps them fixed during encoding. The host still chooses codec limits,
allocation policy and write cadence. This view is not a serialized format.

`Log::into_snapshot()` consumes a log and moves its retained entries into a
checkpoint without cloning their owned text. Use `Log::snapshot()` to keep the
original log available: it explicitly copies a complete checkpoint, including limits,
oldest-first entries and sequence/time watermarks. `Log::restore()` admits that
checkpoint without replaying entries. For `LogSnapshot<RetainedByteLimits>`,
`Log::restore_retained_bytes()` also recomputes current byte usage. Both
restore methods reject invalid bounds, noncontiguous
identities, regressed timestamps, contradictory watermarks and inconsistent
truncation state and violations of the selected budget. Fully pruned and sequence-exhausted checkpoints retain their
append restrictions. Restoration proves internal consistency, not authenticity,
instance identity or continuity with another checkpoint. Byte decoders must bound
allocation before constructing it; `LogSnapshot` is not a serialized format.
An empty checkpoint cannot retain `u64::MAX` as its last timestamp: a row at that
timestamp can never expire. Nonempty checkpoints at that timestamp remain valid.

```rust
# use ic_logging::{Log, Limits};
# use std::num::NonZeroUsize;
# let log = Log::new(Limits { max_entries: NonZeroUsize::new(10).unwrap(), max_message_bytes: 128, max_label_bytes: 32, max_text_bytes: 2048 });
let checkpoint = log.snapshot();
let restored = Log::restore(checkpoint.clone()).unwrap();
assert_eq!(restored.into_snapshot(), checkpoint);
```

The library performs no authorization, timer registration, IC calls, serialization
or stable writes. Durable formats and governed allocation belong at the
[Storage integration boundary](https://github.com/dragginzgame/ic-storage). Hosts own
checkpoint cadence, lifecycle, retention scheduling and stable identity; linking
the heap crate selects no persistence. Diagnostic logs must not be treated as
evidence that a paid effect completed.

Applications may count Logging receipts and refusals with Metrics while keeping
the libraries and their reset lifetimes independent. The host owns those counters
and any report DTOs; linking Logging adds no Metrics or schema dependency.

## Licence

[Toko Studios Network Licence 1.1](https://github.com/dragginzgame/ic-observability/blob/main/LICENSE.md).

Copyright (c) 2024 Canic contributors
