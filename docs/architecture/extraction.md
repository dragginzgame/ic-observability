# Observability ownership and extraction contract

IC Observability combines the Metrics and Logging packages in one workspace.
Their library APIs, dependencies and runtime state remain independent. The root
workspace owns dependency selection and validation tooling, with independent
Metrics and Logging versions under [explicit release groups](../releases/independent-releases.md).
Existing frozen Metrics evidence retains the original repository/source identities.
The [0.18 migration guide](../migrations/0.18.md) owns the Logging source break,
retained-data adoption boundary and new summary/histogram report contracts.

| Package | Owner |
| --- | --- |
| `ic-metrics` | Application instrumentation and the optional bounded recorder contract below |
| `ic-logging` | Heap admission, retention and paging; [logging contract](logging.md) |
| `ic-metrics-storage` | IC Storage; separately selected governed storage adapter |
| `ic-logging-storage` | IC Storage; separately selected durable checkpoints over Logging's validated restoration contract |

## Measurement contract

Metrics instruments the Canic application tree: Canic, IcyDB, Backup, Blob and
participating libraries. The maintainer decision in
[#130 — Restrict Metrics to instrumentation](https://github.com/dragginzgame/ic-observability/issues/130)
supersedes the former general-arithmetic and validated-transport boundary.
Metrics records application observations; it is not a statistics, numeric
validation, formatting or report-decoding library. Canic's metrics adapter owns
the shared reporting endpoint, transport DTOs and Wire/TypeScript projection.
Report readers must not acquire Metrics to decode or validate results.

Fixed application recorders are allocation-free, `no_std` and dependency-free.
Optional bounded heap retention uses `alloc` behind `recording`. Consumers own
platform reads, units, observation attribution, limits, labels, instance identity,
synchronization, lifecycle and reset authorization. The
[compiled application guide](../../crates/ic-metrics/src/application.md) demonstrates
that boundary; the [API inventory](metrics-api.md) accounts for every public type,
method, field, trait implementation and re-export, plus downstream repairs.

## Capability placement

Metrics is an application capability alongside Timers, Jobs and Auth. Applications
and Canic compose those capabilities; Metrics depends on none of them. IC Storage
owns governed persistence integration. IC Tooling owns Host, Build and Testkit;
tooling-specific reporting, benchmark statistics and numeric helpers stay there.
No general math crate replaces the removed API.

## Recording and report ownership

| Recorder | Retained instrumentation state |
| --- | --- |
| `MeasurementAggregate` | Same-unit observation count, wide total, maximum and sticky actual-overflow quality; deliberately attributed batch merging |
| `MeasurementCounter` | Diagnostic scalar total and actual-overflow flag; no authoritative financial/budget state |
| `MeasurementSummary` | Aggregate plus latest ordered observation; no unordered merge |
| `MeasurementHistogram<N>` | Immutable configured bounds, disjoint counts, overflow and aggregate; same-bound merging |
| `BoundedMeasurementTable` (`recording`) | Bounded first-admitted keys with explicit omission accounting |
| `BoundedCounterTable<K>` (`recording`) | First-admitted typed diagnostic scalar identities; omitted original increments |
| `LexicalMeasurementTable<K>` (`recording`) | Typed lexical-prefix identities; complete evicted aggregate and refused-observation accounting |
| `MeasurementWindow<T>` | Host-selected measurement composition and nonwrapping local reset sequence |

Zero is a valid observation, separate from no samples. Empty maxima/latest values
are absent; a scalar starts at exact zero. Exactly reaching a cap remains exact.
Actual overflow clips and sets sticky quality; merging propagates that quality.
Consumers cannot reconstruct lost provenance from a clipped number.

The report adapter projects counts, totals, individual extrema and bucket quality
into its own DTOs. It owns means, rounding, percentages, histogram queries,
intervals, validation, Wire metadata and generated clients. Recorder types have
no Serde/Wire implementation and are not transport payloads. Preserve wide totals
and explicit unavailable values; narrow conversions must not silently clip.
Identity, units and reset continuity precede comparisons. Maxima/latest values
cannot be subtracted; a latest timer delay is not a cohort total.

The [0.29 migration](../../releases/metrics/0.29.md) removes the leaking general
numeric and report APIs. The earlier [0.28 cut](../../releases/metrics/0.28.md) removed
Wire metadata only; its released contracts and frozen receipts keep their scope.
The 0.14 floating-point-statistics removal likewise remains historical evidence,
not a reason to retain general integer reporting helpers today.

## Platform and persistence boundaries

Consumers read counter 1 through their own adapters: IcyDB and Canic use
`ic_cdk::api::call_context_instruction_counter()`, while IC Timers uses
`ic0::performance_counter(1)`. Native substitutes are not IC measurements.
Inclusive overlapping IcyDB spans and exclusive Canic endpoint accounting remain
separate contracts; there is no attribution-mode switch or product dependency.

IC Storage owns the optional
[storage adapter](https://github.com/dragginzgame/ic-storage/tree/main/crates/ic-metrics-storage),
including persisted records, governed collection integration, restoration and
checkpoint validation. Its canonical guide and
[migration guide](https://github.com/dragginzgame/ic-storage/blob/main/docs/migration/ic-metrics-stable.md)
own version selection and retained-data compatibility. Hosts retain allocation,
identities, lifecycle, write cadence and reset policy. Metrics supplies canonical retained-state admission only through its explicit
`persistence` module. Storage owns the codec and retained bytes; there is no
recorder transport contract or stable-memory dependency. Historical storage receipts below retain their
original source and graph identities.

The published [IC Host Wasm inspector](https://github.com/dragginzgame/ic-tooling/tree/main/apps/ic-host-wasm-inspect)
owns bounded structural inspection and its managed installation guide. Optional
experiments retain their own qualified tool identity; Metrics maintains no CLI
adapter or pin. Common setup, CI and release preflight require no inspector. It
does not execute canisters or estimate instruction/cycle costs. PocketIC provisioning and lifecycle
belong to IC Testkit; this workspace has no maintained server caller.
No IC Host package is required to compile or use the instrumentation library.

## Downstream contract checks

| Consumer | Owning contracts to preserve | Adoption owner |
| --- | --- | --- |
| IcyDB | Inclusive overlapping spans, zero, overflow/report fields, CLI means, reset identity and journal-debt separation. | [#356](https://github.com/dragginzgame/icydb/issues/356) |
| Canic | Exclusive nesting, async call-context identity, invocation checkpoints, zero, scalar/measurement report quality and reset continuity. | [#535 — Shared scalar diagnostic counters](https://github.com/dragginzgame/canic/issues/535); [#523](https://github.com/dragginzgame/canic/issues/523); [#600 — Protected report semantics](https://github.com/dragginzgame/canic/issues/600) |
| IC Timers | Scheduler/work roles, registration/epoch identity, completion/trap admission and empty/zero/overflow projections. | [0.9 qualification](https://github.com/dragginzgame/ic-timers/issues/51); [#59 — Adopt Metrics 0.10 summary projections](https://github.com/dragginzgame/ic-timers/issues/59) |
| IC Backup | Nanosecond/byte separation, success/rejection samples, zero/repeated chunks, clamped durations, copied views, `Send + Sync` and empty create/open state. | [Earlier qualification](https://github.com/dragginzgame/ic-backup/issues/41); [#47 — Adopt Metrics 0.10 summary projections](https://github.com/dragginzgame/ic-backup/issues/47) |
| Blob restoration test probe | Restoration-operation attribution, call-context identity, zero, bounded reports and reset behavior; not production storage instrumentation. | [#65](https://github.com/dragginzgame/ic-blob-storage/issues/65) |
| Toko Miner game shard | Action-count cohort admission, separate attempt/instruction units, trap/outcome policy, bounded reports and window/reset identity. | [#48](https://github.com/dragginzgame/toko-miner/issues/48) |

Review affected producers, DTOs, codecs, generated views and callers when shared
contracts change. Consumers explicitly select registry dependencies, remove
superseded recording implementations and qualify their own runtime/native contracts. Exposed
shared types require a consistent dependency identity. Publication and a lock
update do not establish owning acceptance. GitHub issues retain current work;
remaining original Canic qualification stays with
[#447](https://github.com/dragginzgame/canic/issues/447) and
[#99](https://github.com/dragginzgame/canic/issues/99).
[Metrics #10](https://github.com/dragginzgame/ic-observability/issues/10) retains the
retired root coordination history, and [Toko #49](https://github.com/dragginzgame/toko-miner/issues/49)
owns the database quality bridge/UI. The
[consumer summary](../evidence/consumer-history.md) retains the ownership conclusions;
the detailed source-search diaries are retired.

Distribution adoption needs admitted observations, not reconstructed counts,
maxima or chronological histories. Backup's reviewed four-bound histogram owns
prepared chunk bytes. Timers' scheduler/work summaries and Toko's domain cohorts
are separate contracts. Histogram investigations remain with
[IcyDB #312](https://github.com/dragginzgame/icydb/issues/312),
[Canic #475](https://github.com/dragginzgame/canic/issues/475),
[Timers #22](https://github.com/dragginzgame/ic-timers/issues/22) and
[Backup #15](https://github.com/dragginzgame/ic-backup/issues/15).

## Compatibility and evidence

Reports preserve the tracked accumulator's actual overflow quality.
[The Metrics changelog](../../releases/metrics/CHANGELOG.md) owns released API
changes and required caller actions. Metrics never automatically resets retained data. Consumer wire changes
and retained-data disposition stay at their owner.

[The current handoff](../status/current.md) separates local preparation, package
publication and hosted qualification. Protected [0.8.2](../evidence/releases/release-082.md)
and [0.8.1](../evidence/releases/release-081.md) receipts retain their original source
and observed acceptance identities; historical cancelled runs keep their status.
They do not qualify a later source or establish that old hosted artifacts remain
available. Current release receipts live under [the protected index](../evidence/releases/README.md).

The [recorder](../evidence/metrics-history.md), [persistence](../evidence/persistence-history.md)
and [consumer](../evidence/consumer-history.md) summaries retain useful design and
ownership conclusions. Superseded raw experiments, including the older governed
Memory comparisons, are retired from the current tree under the
[evidence policy](../evidence/README.md#retired-raw-evidence). Their old hashes or
selected results are not independently verifiable current-tree qualification.
Required retained-codec or installed-canister acceptance belongs at its owning
adapter with its actual source, graph and workload.

Raw Wasm bytes, IC instructions and actual cycle charges remain separate units;
native substitutes provide none of those IC costs. No old experiment proves a
later consumer's performance. Historical extraction prose and removed inputs can
be read in Git history; the current summaries do not claim to preserve them verbatim.

## Bounded recording extension

The maintainer selected this extension on 2026-10-28 for unconditional bounded
consumer recording with independently selected endpoint exposure. `recording`
adds no further production dependency and uses Rust `alloc`, never `std` or platform APIs.
`BoundedMeasurementTable` admits the first identities within explicit entry,
per-key byte and total-key-byte limits. Existing identities continue at capacity.
Each refused observation contributes exactly once to a same-unit omitted aggregate;
its count is observations, not distinct omitted identities. Reports borrow keys
and copy recorded observation state; no global top-cost or complete-identity claim is made.
The key-byte budget excludes map-node and allocator overhead. Bounds are product
choices; the shared crate chooses no application capacity or admission labels.

`MeasurementWindow<T>` holds consumer-defined combinations of counters, aggregates,
summaries or bounded tables. Replacing a window advances its nonwrapping sequence.
Consumers supply clock fields, empty replacement state and reset authorization.
Equal sequences from different instances never establish continuity. Restart and
persistence remain at their existing owners; this is not a durable registry.
Authoritative database debt, quotas and balances never move into this recorder.
No change to inclusive versus exclusive attribution or public DTOs is implied.

The additive typed counter table applies the same first-admitted entry/per-key/
combined-byte policy to scalar increments without inventing observation samples.
The typed lexical table instead retains the smallest eligible identities by
consumer `Ord`. It requires a combined key budget covering every slot at its
per-key maximum; insufficient/overflowing configuration refuses before a table
exists. This prevents byte-pressure arrival-order dependence. Every evicted
aggregate moves completely into omitted accounting; rejected observations enter
it once. Borrowed existing-key updates allocate no key. These tables own no
DTO, endpoint roster, platform sampling or persistence contract. The original
string table keeps its existing behavior. Canic owns its endpoint/checkpoint
partition and adoption under [#756](https://github.com/dragginzgame/canic/issues/756).

Typed tables also expose omitted-only recording: `add_omitted(u128)` preserves
scalar units, while `record_omitted(u64)` records one observation, including zero.
Both delegate only to canonical arithmetic, without constructing/comparing a key,
allocating or changing retained state. The caller can reject an oversized borrowed
identity before copying it. It owns eligibility and must not also admit the same
event. No sentinel identity, separate omitted recorder, new trait or codec is
needed; existing admission and complete-eviction behavior are unchanged.
