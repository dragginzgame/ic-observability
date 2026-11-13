# IC Metrics

[![crates.io](https://img.shields.io/crates/v/ic-metrics.svg)](https://crates.io/crates/ic-metrics)
[![docs.rs](https://docs.rs/ic-metrics/badge.svg)](https://docs.rs/ic-metrics)

Application instrumentation for the Canic application tree: Canic, IcyDB,
Backup, Blob and participating libraries. Metrics records observations and tracks
overflow; Canic's metrics adapter owns reporting DTOs, Wire/TypeScript projection
and the shared reporting endpoint. Report readers do not need Metrics.

Metrics 0.29 applies the breaking instrumentation boundary in
[#130 — Restrict Metrics to instrumentation](https://github.com/dragginzgame/ic-observability/issues/130).
It is not a general arithmetic, statistics, formatting or numeric-validation
library. Published 0.28 releases retain their earlier API; see the
[migration guide](https://github.com/dragginzgame/ic-observability/blob/main/releases/metrics/0.29.md).

```rust
use ic_metrics::{MeasurementAggregate, MeasurementCounter};
let mut instructions = MeasurementAggregate::EMPTY;
instructions.record(0);
instructions.record(12_000);
let mut retries = MeasurementCounter::ZERO;
retries.add(1);
assert_eq!(instructions.samples(), 2);
assert_eq!(instructions.total(), 12_000);
assert_eq!(instructions.maximum(), Some(12_000));
assert!(!instructions.samples_overflowed());
assert!(!instructions.total_overflowed());
assert_eq!(retries.exact_total(), Ok(1));
```

Fixed counters, aggregates, ordered summaries and fixed-bound histograms are
`no_std`, allocation-free and dependency-free. Enable `recording` for bounded heap
retention with explicit entry/key budgets and omitted-observation accounting;
that feature uses `alloc` and adds no dependencies. `MeasurementWindow<T>` provides
local nonwrapping reset bookkeeping for application-selected measurement state.

With `recording`, `BoundedCounterTable<K>` retains the first admitted typed
identities and records original `u128` scalar increments. `LexicalMeasurementTable<K>`
retains the lexically smallest eligible keys and moves complete evicted histories
into its omitted aggregate. Both accept consumer-accounted key-payload byte
charges and support borrowed updates without constructing repeated keys.
Lexical construction requires `total_key_bytes >= entries * key_bytes` (with
checked multiplication), so byte pressure cannot change identity selection by
arrival order. The existing string-keyed `BoundedMeasurementTable` keeps its
first-admitted policy and independent combined-byte budget unchanged.

For an ineligible borrowed identity, call `add_omitted(u128)` on the typed counter
table or `record_omitted(u64)` on the lexical measurement table. These const-capable
methods need no owned key, compare no keys and allocate nothing; retained rows,
charges and limits stay unchanged. Consumers own the eligibility decision and
call omission instead of admission for that event, never both. Scalar zero stays
exact; measured zero is a sample with a maximum. Actual overflow remains sticky.

```rust
# #[cfg(feature = "recording")] {
use ic_metrics::{BoundedCounterTable, LexicalMeasurementTable, MeasurementTableLimits};
let limits = MeasurementTableLimits { entries: 1, key_bytes: 8, total_key_bytes: 8 };
let mut calls = BoundedCounterTable::new(limits);
calls.add((7_u64, "read"), 4, 1);
calls.add((8, "read"), 4, 2);
assert_eq!(calls.omitted().exact_total(), Ok(2));
let mut instructions = LexicalMeasurementTable::new(limits).unwrap();
instructions.record("z", 1, 10);
instructions.record("a", 1, 0);
assert_eq!(instructions.entries().next().unwrap().0, &"a");
assert_eq!(instructions.omitted().total(), 10);
# }
```

Typed ordering and payload charges must remain stable while keys are retained;
byte charges exclude fixed metadata, map nodes and allocator overhead. Omitted
state counts increments or observations, never distinct lost identities. These
heap tables own neither endpoint schemas nor persistence formats.

Exactly reaching a cap remains exact. Actual overflow clips the total/count and
sets a sticky flag. Empty observations differ from measured zero; zero counters
are exact. Applications own units, platform reads, attribution, labels, admission,
identity, synchronization, reset authorization, lifecycle and limits. Diagnostic
metrics never replace balances, spending authority, budgets or journal debt.

Recorder values are not frontend DTOs and implement neither Serde nor Wire.
Adapters project fields and source quality into their own report contracts and
own averages, rounding, percentages, intervals and quantiles. Preserve wide totals
and explicit unavailable/overflow results. Do not depend on Metrics to decode or
validate a report.

Governed Storage adapters use `ic_metrics::persistence` for canonical restoration
of retained counters, aggregates, summaries and histograms. Storage owns durable
encoding/bytes, governed allocation, namespace/configuration identity, continuity,
checkpoint cadence and same-release reopening. Public raw constructors and
transport reconstruction are absent; restoration never infers lost provenance.
See the [complete API inventory](https://github.com/dragginzgame/ic-observability/blob/main/docs/architecture/metrics-api.md)
and [compiled application guide](https://github.com/dragginzgame/ic-observability/blob/main/crates/ic-metrics/src/application.md).

Rust 1.100.0 is the floor and pinned compiler on native and Wasm. Focused checks:

```sh
make fmt
cargo clippy -p ic-metrics --all-targets --all-features --locked --offline -- -D warnings
cargo test -p ic-metrics --all-features --locked --offline
make metrics-profiles-check allocation-free-check
```

The [host guide](https://github.com/dragginzgame/ic-observability/blob/main/docs/development/hosts.md)
owns command scope and evidence limits. Raw Wasm bytes, IC instructions and actual
cycles are separate measurements; native checks do not provide IC cost evidence.

Metrics and Logging have independent versions and publication. No release or
publication is implied by preparing an API cut. Maintainer delivery requires an
explicit `RELEASE_GROUP=metrics` and the
[independent-release workflow](https://github.com/dragginzgame/ic-observability/blob/main/docs/releases/independent-releases.md).
The [Metrics ledger](https://github.com/dragginzgame/ic-observability/blob/main/releases/metrics/CHANGELOG.md)
owns current and historical release notes. Historical receipts retain their
original source, package, schema and runtime qualification identities.

## Licence

[Toko Studios Network Licence 1.0](https://github.com/dragginzgame/ic-observability/blob/main/LICENSE.md).

Copyright (c) 2026 ic-metrics contributors
