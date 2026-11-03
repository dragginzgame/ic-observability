
## Application-owned instrumentation

Use Metrics to instrument Canic, `IcyDB`, Backup, Blob and participating application
libraries. Keep one unit and one admitted operation cohort per recorder. It is
not a general statistics, formatting, numeric-validation or report-decoding library.
Canic's metrics adapter owns the shared reporting endpoint, DTOs and Wire/TypeScript
projection. Report readers do not need this crate.

```rust
use ic_metrics::{MeasurementCounter, MeasurementHistogram, MeasurementSummary};

let mut instructions = MeasurementHistogram::new([10_000, 100_000])?;
let mut rows = MeasurementSummary::EMPTY;
let mut retries = MeasurementCounter::ZERO;
assert_eq!(instructions.aggregate().maximum(), None);
instructions.record(0); // A real observed zero, not an absent sample.
instructions.record(12_000);
rows.record(128);
retries.add(1);
assert_eq!(instructions.bucket_counts(), &[1, 1]);
assert_eq!(instructions.aggregate().samples(), 2);
assert_eq!(instructions.aggregate().total(), 12_000);
assert_eq!(instructions.aggregate().maximum(), Some(12_000));
assert_eq!(rows.latest(), Some(128));
assert_eq!(retries.exact_total()?, 1);
# Ok::<(), Box<dyn std::error::Error>>(())
```

The application supplies real observations and owns platform counter reads,
units, operation attribution, replicated-execution admission, limits, labels,
instance identity, lifecycle and reset authorization. `IcyDB`'s overlapping spans
and Canic's exclusive endpoint accounting remain separate consumer contracts.
Native substitutes are not IC measurements. Diagnostic counters never confer
spending authority or replace balances, budgets or journal debt.

### Overflow and reporting

Fixed recorders allocate nothing and remain `no_std`. Recording and merging keep
sticky actual-overflow flags; reaching a cap exactly does not set them. Zero is
a valid sample. An empty aggregate has no maximum; an empty summary has no latest.
A scalar counter starts at exact zero, while the host decides whether a metric
exists. Maximum/latest values remain individual observations after overflow.
Merging adds deliberately attributed batches without deduplication; summaries
have no unordered merge that invents a latest observation.

Read count, total, extrema, bucket counts and their quality to project an
adapter-owned DTO. Preserve `u128` totals and actual-overflow flags, and represent
unavailable/narrowing failures explicitly. The adapter owns averages, rounding,
percentages, quantiles, intervals and report validation. Identity, unit and reset
continuity must be established before it compares observations. A timer's latest
armed delay is not a total to divide by its work count.

### Bounded heap recording

The opt-in `recording` feature uses `alloc` for a bounded keyed recorder, adding
no dependencies or endpoint. The application chooses its fixed key budgets.

```rust
# #[cfg(feature = "recording")]
# {
use ic_metrics::{BoundedMeasurementTable, MeasurementTableLimits, MeasurementWindow};
let limits = MeasurementTableLimits { entries: 64, key_bytes: 1024, total_key_bytes: 8192 };
let mut window = MeasurementWindow::new(BoundedMeasurementTable::new(limits));
window.state_mut().record("query.instructions", 0);
assert_eq!(window.state().entries().len(), 1);
window.reset(BoundedMeasurementTable::new(limits));
assert_eq!(window.sequence(), Some(1));
# }
```

The table retains omitted observations separately, preserving their quality.
A window's nonwrapping reset sequence is local bookkeeping, not durable or global
identity. The application owns restart identity and reset policy.

### Governed persistence

[`persistence`] supplies canonical restoration of retained instrumentation fields.
Recording types have no public reconstruction methods and no Serde/Wire traits.
Storage owns encoding, governed handles, configuration/namespace identity,
continuity, lifecycle and checkpoint cadence. The functions validate consistency,
not arbitrary incoming report DTOs or observation provenance.

```rust
use ic_metrics::{MeasurementAggregate, persistence};
let mut recorded = MeasurementAggregate::EMPTY;
recorded.record(0);
let mut restored = persistence::restore_aggregate(
    recorded.samples(), recorded.total(), recorded.maximum(),
    recorded.samples_overflowed(), recorded.total_overflowed(),
)?;
restored.record(9);
assert_eq!(restored.samples(), 2);
assert_eq!(restored.total(), 9);
# Ok::<(), ic_metrics::persistence::MeasurementStateError>(())
```

The Storage adapter must preserve its existing retained schema and refuse
corrupt state, rather than initializing a replacement. Metrics does not allocate
stable memory or own durable-format migrations.

### Cost qualification

Qualify the selected application graph using raw Wasm bytes, IC instructions and
actual cycles separately, including recording overhead. These examples establish
API usage; they do not measure an application's IC cost or lifecycle behavior.
