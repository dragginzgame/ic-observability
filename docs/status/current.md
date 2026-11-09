# Current handoff — 2026-11-09

## Published omitted-only diagnostics

[#133](https://github.com/dragginzgame/ic-observability/issues/133) is implemented
in Metrics 0.29.9: `BoundedCounterTable::add_omitted(u128)` and
`LexicalMeasurementTable::record_omitted(u64)` are const-capable, return unit,
and reuse canonical arithmetic without a key, comparison, allocation or retained
state change. Consumers decide eligibility and call omission instead of admission
for that event. The release is delivered and independently verified on crates.io;
Metrics 0.29.8 does not contain these methods.

Focused Linux/Rust 1.99.1 validation passes: 21 recording tests, three external
typed API tests (including const evaluation and comparison refusal), native
library/test and Wasm library Clippy with warnings denied, warnings-denied
Rustdoc, four dependency-free production graphs, formatting, links and diff
checks. The subsequent release passed the full workspace gate described below.
No production dependency/feature or sibling change belongs to this fix.
Canic #756 retains adoption and installed qualification.

## Published typed recording APIs

Metrics **0.29.10** and Logging **0.24.15** are delivered to origin/main and
published, non-yanked and independently verified against their source archives.
The [delivery receipt](../evidence/releases/toko0382-placement-20261109.md) owns
exact commits, annotated tags, archive hashes, plans and publication evidence.
Never re-upload these versions. Both ledger entries are finalized. These patches
deliver tooling and workspace-placement rules; recorder APIs remain unchanged.
The normal checkout is reconciled with the completed batch. The earlier omission
APIs and their original identities remain in the
[preceding receipt](../evidence/releases/omission-toko0375-20261109.md), which links
the original typed-recording delivery.

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

Batch `batch-Dvpzy0I1` is complete at index 2. Its candidate is retained under
`target/release-frozen/batch-Dvpzy0I1`, with durable recovery under
`.git/release-state/frozen/batch-Dvpzy0I1/`. Reconciliation completed and the
deferred syn edit was reapplied. No retirement or protected evidence cleanup ran.
The delivery receipt owns source, publication and recovery identities.

Earlier completed batches `batch-9DUaDslR`, `batch-vgM1oJ1f`, `batch-gfJA5IMg`
and `batch-z30yB8KG` retain their
candidates and Git-side recovery. Failed pre-delivery batch `batch-C8a10ddy`
remains retained and must not be resumed as repaired source. The
[previous delivery receipt](../evidence/releases/observability-patches-20261108-toko036.md)
owns those source and admission-repair identities. Earlier stashes, including
`a7dbbac568a37876f37f8a89607545a5fba389b2` and
`e5bedde93b31a520a4ff282071099152cb04c555`, remain untouched. The
[evidence retention index](../evidence/README.md) owns private-source custody
and historical evidence; no source/export authority is implied by read access.

## Installed Cargo-selected toko-tooling 0.38.2 and crate placement

Root `[workspace.dependencies]` declares `toko-tooling = "=0.38.2"` once. Both real
members inherit it unconditionally as a dev-dependency with cargo-machete ignored
metadata and no artificial Rust import. The root remains virtual, with no
selection-only package, metadata selector or separate tooling lock. Cargo.lock
and the snapshot select registry archive SHA-256
`45c12cc2aa598d14e137dd7db50f12e943470b4ce351dfcaffeccde6821c1876`; all 99 roots
and 171 installed files agree. Production library graphs remain dependency-free.

The 0.38.2 adoption is committed and delivered. Cargo updated only toko-tooling
during adoption, preserving the deferred syn selection. Delivery captured syn
3.0.9 and restored the normal 3.0.10 edit after reconciliation. The exporter
adds two qualification helper companions and updates five existing payloads from
0.38.0. Qualification release preparation remains unselected: there is no
`qualification_workspace` declaration or qualification package here. Actual
group plans and Make file inventories retain the same four files per group.
Binding rules apply without exceptions. Evidence is under
`target/evidence/toko-tooling-0382/`; the preceding placement checks remain under
`target/evidence/toko-tooling-0380/`.

The maintained manifest inventory and Cargo metadata identify only the virtual
root and its two product libraries, already correctly placed under `crates/`.
The root explicitly excludes `qualification`; its two README files are retired
history, not maintained packages. No package move or empty qualification
workspace is needed. Unit/integration tests and examples remain package-local.
Generated workspaces under `target/` are disposable fixtures. Product groups,
APIs, features and all 20 release obligations remain intact. Focused
checks cover locked membership/defaults, package inventories, release rosters,
production declarations and documentation; unchanged caller evidence is reused.

The preceding 0.37.1 published-package bootstrap refreshed all 97 mapped roots,
then the receipt moved to `.toko-tooling.snapshot`. The baseline is now
`TOKO-TOOLING.md`; live commands, CI, custom deployment admission, catalog variables
and LOC metadata use Toko names without aliases. Tool setup/admission, snapshot,
pins, formatting and documentation checks pass; focused caller evidence is under
`target/evidence/toko-tooling-0371/`. Product versions and all 20 release
obligations are preserved. Matched group/full traces, Make dispatch and unsafe-mode
refusals, custom drift admission, generated consumers and LOC roles, hook checks,
CI selection and the selected native-evidence success scenario pass. The new
recipe-scoped guard explicitly covers consumer compiler/Cargo and metadata gates.
Historical receipts retain their recorded names and identities.
The latest release receipt owns the subsequent full gates and delivered identities.

After intentionally changing the pin, resolve Cargo.lock with Cargo, then run
`make toko-tooling-update` or `make toko-tooling-install`. Neither installer
resolves the application graph. Offline admission checks declarations, lock and
installed bytes. Common CI/release targets and custom candidate, metadata and
publication adapters retain tooling admission before effects. The
[tooling summary](../evidence/tooling.md) retains prior observations and limits.

#130 remains closed for its producer scope. Remaining Profiler work belongs to
[Profiler #17](https://github.com/dragginzgame/ic-profiler/issues/17). The
[API inventory](../metrics-api.md) and [0.29 migration](../../releases/metrics/0.29.md)
retain the consumer map: Canic owns reporting, Storage owns governed stable
adapters, and each downstream owner retains acceptance.
