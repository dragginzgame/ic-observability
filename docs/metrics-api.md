# Metrics instrumentation API boundary

This inventory implements the maintainer decision in
[#130 — Restrict Metrics to instrumentation](https://github.com/dragginzgame/ic-observability/issues/130).
The scope is the Canic application tree: Canic, IcyDB, Backup, Blob and participating
libraries. General arithmetic, statistics, numeric validation and report decoding
are outside Metrics. This is the breaking Metrics 0.29 source contract.
The [delivery receipt](evidence/releases/metrics-0290-delivery-20261103.md) records producer
publication separately from pending downstream acceptance.

## Retained public API

All modules are private except `persistence`. The crate-root re-exports below are
the complete instrumentation surface; their fields are private unless listed.

| Type | Every retained public constant, method or field | Instrumentation reason / consumer |
| --- | --- | --- |
| `MeasurementAggregate` | `EMPTY`, `record`, `merge`, `samples`, `total`, `samples_overflowed`, `total_overflowed`, `maximum` | Canic endpoint/perf attribution, IcyDB spans, Relay/Auth/Jobs application probes; record samples and project source quality without making the recorder a DTO |
| `MeasurementCounter` | `ZERO`, `add`, `merge`, `total`, `total_overflowed`, `exact_total` | Canic runtime event/byte/cycle diagnostics and Timers operational snapshots; no spending or general subtotal authority |
| `MeasurementCounterError` | `TotalOverflow` | Typed exact-total refusal; `DecreasingTotal` is removed with numeric delta queries |
| `MeasurementSummary` | `EMPTY`, `record`, `aggregate`, `latest` | Backup/Timers ordered operation observations; never invent a latest observation by merging unordered batches |
| `MeasurementHistogram<N>` | `new`, `record`, `upper_bounds`, `bucket_counts`, `overflow`, `bucket_overflowed`, `overflow_count_overflowed`, `aggregate`, `merge` | Backup chunk distribution and application-selected bounded distributions; retain recording and raw quality, not statistical report queries |
| `HistogramBoundsError` | `index` | Typed histogram configuration refusal at construction |
| `HistogramMergeError` | `index` | Typed differing-bound refusal, with no partial merge |
| `MeasurementWindow<T>` | `new`, `state`, `state_mut`, `sequence`, `reset` | Application combinations of measurement state share a nonwrapping local reset sequence; no clock/global/durable identity |
| `BoundedMeasurementTable` (`recording`) | `new`, `record`, `entries`, `omitted`, `retained_key_bytes`, `limits`, `clear` | Opt-in application instrumentation retains bounded identities and accounts for omitted observations |
| `BoundedCounterTable<K>` (`recording`) | `new`, `add`, `add_existing`, `entries`, `omitted`, `retained_key_bytes`, `limits`, `clear` | First-admitted typed diagnostic identities, original scalar units and complete scalar omission accounting |
| `LexicalMeasurementTable<K>` (`recording`) | `new`, `record`, `record_existing`, `entries`, `omitted`, `retained_key_bytes`, `limits`, `clear` | Typed lexical-prefix retention; complete evicted aggregates and rejected observations contribute once to omitted state |
| `LexicalTableLimitsError` (`recording`) | `KeyBudgetOverflow`, `KeyBudgetTooSmall` | Refuse limits that cannot guarantee arrival-order-independent lexical identity retention |
| `MeasurementTableLimits` (`recording`) | public fields `entries`, `key_bytes`, `total_key_bytes` | Caller selects explicit registry budgets |
| `MeasurementAttribution` (`recording`) | `Retained`, `Omitted(MeasurementOmission)` | Caller can observe recording admission without losing the omitted sample |
| `MeasurementOmission` (`recording`) | `KeyBytes`, `Entries`, `TotalKeyBytes` | Typed bounded-key refusal reasons |

The four fixed recorders derive `Clone`, `Copy`, `Debug`, `Eq`, `PartialEq`;
aggregate/counter/summary also derive `Default` as their empty/zero state.
The configuration/admission enums and table limits derive the same five
value traits. The table derives `Clone`/`Debug`; windows derive those traits when
`T` does. These support copying snapshots, assertions and host composition,
without exposing internal fields. Error types derive the five value traits and
implement `Display` and `core::error::Error`. No recorder implements numeric
operators, ordering, conversions, Serde, Wire or a generic numeric trait. Normal
Rust auto traits follow owned fields; no custom auto-trait implementation exists.

The two typed tables derive `Clone`/`Debug` conditional on their keys. Their
operations require `K: Ord`; borrowed updates also require `K: Borrow<Q>` and
`Q: Ord`. Entries borrow keys and copy recorders without exposing mutation.
The lexical limit error derives `Clone`, `Copy`, `Debug`, `Eq`, `PartialEq` and
implements `Display`/`core::error::Error`. No new recorder transport traits exist.
Consumer key-payload byte charges exclude metadata/map/allocator overhead and
must stay consistent. Lexical construction requires a checked worst-case key
budget of `entries * key_bytes`, covered by `total_key_bytes`; it cannot use a
smaller weighted-byte budget without losing its identity-selection guarantee.
The existing first-admitted string table and all fixed recorder contracts stay
unchanged. Canic owns adoption under
[#756](https://github.com/dragginzgame/canic/issues/756); producer capability is
tracked in [#132](https://github.com/dragginzgame/ic-observability/issues/132).

## Explicit governed persistence

`persistence` is the sole public reconstruction module. IC Storage's
`ic-metrics-storage` adapter already owns its encoding, collection identity,
configuration/continuity admission and lifecycle. Older Persistence receipts
retain their original package names and graphs.

| Public item | Contract and required owner |
| --- | --- |
| `restore_aggregate(samples, total, maximum, samples_overflowed, total_overflowed)` | Canonical admission of retained aggregate fields; Storage's aggregate-state decoder |
| `restore_counter(total, total_overflowed)` | Retained scalar diagnostic state; exact caps and sticky overflow remain distinct |
| `restore_summary(aggregate, latest)` | Retained ordered state; rejects impossible latest observations |
| `restore_histogram(bounds, counts, overflow, flags, overflow_flag, aggregate)` | Retained disjoint distribution; rejects inconsistent buckets, flags, bounds and maxima |
| `validate_histogram_bounds(&[u64])` | Storage admits borrowed configuration before lookup without a temporary histogram; constructor/restoration use the same private implementation |
| `MeasurementStateError` | `InvalidEmpty`, `MissingMaximum`, `InvalidOverflowFlag`, `InvalidTotal`, `InvalidLatest`, `InvalidBounds`, `InvalidDistribution`; typed corruption refusal for storage, with `Clone`, `Copy`, `Debug`, `Eq`, `PartialEq`, `Display`, `Error` |

Restoration delegates to the unchanged `pub(crate) from_parts` implementations.
The root `MeasurementStateError` and free bounds validator are no longer public.
The internal aggregate/counter/summary/histogram/state modules, their fields and
histogram restoration helpers remain private. No public persistence field/record
schema, generic state trait, alias or compatibility shim was added. Metrics does
not own a durable format. This cut does not change Storage's retained field
values, widths, ordering, kind tags, record envelope or continuity policy.
The Storage owner must qualify its real codec and retained fixtures after moving
its calls; external client tests here do not establish that downstream acceptance.

## Removed surface

| Former public surface, including all its members | Disposition |
| --- | --- |
| `checked_scaled_ratio`, `checked_scaled_ratio_nearest`, `MeasurementRatioError::{ZeroDenominator, Overflow}` | Removed with the unused ratio implementation; display/percentage arithmetic is owner-local |
| `CheckedMeasurementAggregate::{EMPTY, try_record, samples, total, minimum, maximum}`, `MeasurementRecordError::{Samples, Total}` | Removed; reviewed current application producers use tracked observation recorders, and exact wide report-cohort arithmetic belongs with that reporter |
| `MeasurementAggregate::{mean, scaled_mean}` and `MeasurementMeanError::SampleCountOverflow` | Removed; adapter reports admit the recorded quality and own averaging/rounding |
| `MeasurementAggregate::interval_since`, `MeasurementInterval::{samples, total, mean}` and `MeasurementIntervalError::{SampleCountOverflow, DecreasingSamples, DecreasingTotal, TotalWithoutSamples}` | Removed; report comparisons require owner-established units, cohort and reset identity |
| `MeasurementCounter::delta_since`, `MeasurementCounterError::DecreasingTotal` | Removed; application/report owner compares its own admitted snapshots |
| `MeasurementHistogram::{cumulative_count, quantile_bucket}`, `HistogramRange::{lower_exclusive, upper_inclusive}`, `HistogramQueryError::{BucketOutOfBounds { index, buckets }, InvalidQuantile, CountOverflow}` | Removed with unused report-query implementation; adapter owns distribution projection |
| Four recorder `from_parts` constructors | `pub(crate)` only; governed storage uses the named persistence functions |
| Four recorder `Serialize` / `Deserialize` implementations; private transport field records and fixed-array visitor | Removed; frontend/report decoding must not depend on recorder types |
| Root reconstruction error and bounds-validator exports | Moved to the explicit persistence module only |

The removed types' value/error trait implementations are removed too. There are
no aliases or indirect re-exports restoring them. Serde remains a development-only
dependency to prove recorder trait refusal; all production feature/target graphs
are dependency-free. `num-bigint` remains development-only for the independent
histogram-restoration overflow oracle.

## Consumer repairs and purpose classification

Reviewed source on 2026-11-03, including active uncommitted checkouts. This maps
work; no sibling source was edited or runtime qualification claimed. Track the
complete cut in #130 rather than opening release-wait issues per consumer.

| Owner / affected caller | Required repair and acceptance |
| --- | --- |
| Canic CLI `metrics/render.rs::average_per_count` | Local display rounding; remove production Metrics dependency if it only formats reports; preserve wide values, ties and unavailable results |
| Canic Core perf/runtime/providers | Keep legitimate recording. Provider test's `.mean()` assertion uses raw count/total/quality instead. Canic's adapter owns DTOs, Wire/TypeScript and the shared reporting endpoint |
| IcyDB build `write_wasm_size_report.rs` | Local checked percentage calculation, preserving zero-baseline/overflow behavior; no Metrics for build-report arithmetic |
| IcyDB Core `metrics/report.rs` and CLI render | Separate recorder from report DTO/Deserialize/schema; preserve existing transport fields/bytes at the owning boundary and derive report means locally. Update related source tests; instrumentation fixtures remain legitimate |
| Profiler `system/{logical,physical}.rs` | Private subtotal/overflow/serialization implementation and removal of Metrics dependency; preserve its numeric/serialization contract |
| Relay persistence-probe `examples/timer/measurements.rs` | Ordinary maximum and checked turn increment; preserve overflow refusal and instruction sampling |
| Relay mailbox `examples/mailbox/{step_costs,protocol}.rs` and installed consumer | Keep real application-cost instrumentation; replace recorder response/Serde types with owner-local DTOs, reconstruction and quality assertions, with fixed bounds and overflow refusal |
| Blob contracts `standalone/measurement/mod.rs` | Own DTO decoding/validation without recorder Deserialize; preserve validated report schema and encoded bytes. Canic's adapter owns endpoint consolidation; deployed `blob_metrics` cannot silently disappear without an explicit hard cut |
| Storage `ic-metrics-storage/src/metric/{mod,state}.rs` and `lib.rs` | Move `from_parts` to named `persistence::restore_*`, and scoped error/bounds imports; preserve its current durable codecs/bytes and corruption/continuity checks |
| Timers operational snapshots | Legitimate recording remains; tests using `delta_since`, `mean` or intervals move their report assertions to admitted fields/quality. No scheduler behavior cut |
| Backup | No Metrics catalog entry or Rust caller was found in the current Backup checkout. Earlier duration/byte summary/histogram receipts keep their original graph; any restored instrumentation must follow this purpose boundary |
| Auth/Jobs/Relay fixture-only recording | Legitimate Canic-tree instrumentation, not a production report-reader dependency. Do not delete solely because a fixture uses Metrics |
| Toko Miner / Toko | Protected source was not inspected in this audit; earlier tracked consumers retain their owner and need explicit purpose review before adopting the cut |

## Verification boundary

Compile-fail doctests independently check every former root type/helper export,
removed query methods, private reconstruction methods and missing Serde traits.
External integration tests exercise all four persistence functions, continued
recording, caps/actual overflow, typed corruption refusal and bounded omission/
reset behavior. Existing restoration oracles and recording models remain.
Native/Wasm graph checks exclude every external normal/build dependency.
On Linux x86_64 with Rust 1.99.1, focused execution passed: all 50 Metrics library
tests (including restoration oracles and the recording model), three external
persistence/recording tests, five positive doctests and 30 compile-fail doctests.
Native all-target/all-feature and Wasm library Clippy passed with warnings denied.
The four production feature/target graphs admitted no external dependencies;
fixed recording linked for Wasm without std or a global allocator. Declaration
admission and its corruption/dependency fixtures passed. Rustdoc with warnings
denied, documentation links and diff checks passed. Logs are retained under
`target/issue-130/`. The only lock changes prune unused JSON support and Serde's
derive edge; retained dependency versions/checksums are unchanged.

No automatic fleet/full matrix, publication, retained-data migration or sibling
acceptance is implied. No owner-local rounding implementation was changed here;
the report owners must test their required rounding/zero/overflow behavior.
