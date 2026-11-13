# Current handoff — 2026-11-13

## Published products and tooling

Metrics **0.30.1** and Logging **0.25.1** are delivered to GitHub and
independently verified on crates.io. Never re-upload those versions. The
[delivery receipt](../evidence/releases/toko0401-delivery-20261113.md) owns exact
commits, annotated tags, archive hashes, complete plans and registry readback.
Both passed all 20 workspace stages without narrowing or stage reuse, followed
by final archive compilation and matching maintained source (34 Metrics and
16 Logging files). Hosted macOS and installed consumer acceptance remain separate
and asynchronous; pending or cancelled checks are not passes.

Both packages require **Rust 1.100.0** on native and Wasm, inherit common lint
policy and select published **toko-tooling 0.40.1** for development, archive SHA-256
`fb884b05e2e5bbca2388dd0b757833fb5ad37e91b3ced09f6a37b454c7fe9f90`.
The exporter preserves 55 roots and 111 files, changing only the baseline.
Canonical/executable bytes and production Rust/API/retention behavior are unchanged.
The consumer Make adapter now admits execution at group/scope prerequisites,
fixing the GNU Make 3.81 refusal failure found in both prior macOS jobs. Actual
release/publication fixtures passed on Linux-built GNU Make 3.81 and current Make
before fresh capture; this does not claim native macOS acceptance.

The local root pin, Cargo.lock and authenticated snapshot now select published
**toko-tooling 0.41.0**, archive SHA-256
`4aaafc699324611501e051132e971288c16392a3ece605e9909e88e0c7e80a2f`.
This adoption is uncommitted and unpushed, incorporating the earlier 0.40.2 work.
The exporter retains 55 roots and 111 files. `make deps-list` inventories members;
display-only aliases remain removed and both member rosters/versions are preserved.
The Cargo/Rustdoc lint minimum is inherited, with safe-only `forbid` unchanged.
Clippy uses Cargo warning denial qualified against fresh/reused native/Wasm
artifacts; explicit Rustdoc denial remains. Isolated consumers now retain only
actually inherited suppliers and integration targets, without empty-library or
missing-crate-documentation warnings. Library engines and APIs are unchanged.

The [release guide](../releases/independent-releases.md) records the selected
native/test dependency boundary. No testkit supplier is selected here; optional
upgrade failures do not invalidate the qualified existing graph. All required
product/native checks and current recovery limits remain. Current focused
qualification is under `target/evidence/toko-tooling-0410/`; no broad CI/release
suite ran. Pending Metrics **0.30.2** and Logging **0.25.2** remain compatible
contributor-tooling notes. The deferred syn 3.0.10 edit is preserved.

Logging's byte-budgeted export example now checks encoded length before writing
accepted rows directly into its result, using a reusable stack number buffer.
Its five named example tests, strict Clippy and runnable demonstration passed;
evidence is under `target/evidence/logging-export-direct-format/`. Engine APIs,
UTF-8 budgets, typed errors and continuation semantics remain unchanged.

The [release guide](../releases/independent-releases.md) records nested work,
measured stage costs and current missing cross-source/collector recovery admission.
All 20 release obligations and disabled stage reuse remain. Focused adoption/repair evidence is under
`target/evidence/toko-tooling-0401/` and `target/evidence/toko0401-make381/`.
Current full release transcripts and supplier review are under
`target/deploy/toko0401-20261113/`.

[#134 — Adopt Rust 1.100.0 and the common lint policy](https://github.com/dragginzgame/ic-observability/issues/134)
is closed. Focused evidence under `target/evidence/toko-tooling-0400/` includes
actual compiler identities, both generated consumers and typed native/Wasm lint
refusals. Earlier full release transcripts and supplier review are under
`target/deploy/toko0400-20261113/`. Only Linux x86_64 ran locally; hosted native
and installed consumer acceptance are not inferred from those results.

The native release editor selects published IC Build **0.83.0**. Both group
ledgers record current supplier review and optional-refresh dispositions for
cargo-sort-derives and the editor's packaged IC Host lock. Review those again
at the next applicable maintenance/release boundary. Focused adoption/layout
checks remain under `target/evidence/toko-tooling-03917/`; earlier delivery
transcripts and registry review are under `target/deploy/toko03917-20261112/`.
The [tooling summary](../evidence/tooling.md) and
[source inventory](../governance/source-origins.md) retain their respective scope.
The deferred syn 3.0.10 edit is separate from the delivered syn 3.0.9 graph.

The product crates remain independent, under `crates/`, in one virtual root
workspace excluding `qualification`. That tree contains historical README files,
not maintained packages. No qualification workspace or qualification release selection is needed.
Package-local tests and examples remain with their products. Current product
APIs, features and all existing release obligations remain unchanged.

Metrics 0.29.9 introduced `BoundedCounterTable::add_omitted(u128)` and
`LexicalMeasurementTable::record_omitted(u64)`, preserving canonical arithmetic
without constructing/comparing a key, allocation or retained-state changes.
[#133](https://github.com/dragginzgame/ic-observability/issues/133) records producer
completion/publication. Original typed tables and Logging `BoundedHistory<T>`
are recorded in the earlier delivery receipts. Canic
[#755](https://github.com/dragginzgame/canic/issues/755) and
[#756](https://github.com/dragginzgame/canic/issues/756) retain adoption and real
endpoint/report/installed acceptance. No sibling deployment is implied.

## Deferred work and recovery custody

The syn 3.0.10 Cargo.lock edit is restored and excluded from the published
syn 3.0.9 graph. Its current stash is
`dcf41ce2ca54b419de568f549d3521a2b75b5779`, pinned by branch
`preserved/syn-3.0.10-toko0401-reconcile-20261113`. The initial 0.40.1 stash
`0797db766ffd29e0fc972c31e3c3a4cbf67a0b99` and branch
`preserved/syn-3.0.10-toko0401-20261113` remain retained. Earlier stash
`96058885f9422b59860801243f934678d1abd175` and its branch
`preserved/syn-3.0.10-toko0400-20261113` remain retained. The earlier stash/ref
`6511a6979fae869912f7f3f2f6a3e7b968bb9792` and its
`preserved/syn-3.0.10-toko03917-20261112` branch remain retained. The earlier stash/ref
`39f97a10b8ecd7f567b3b69696b7c71fb549ab01` and its
`preserved/syn-3.0.10-toko0397-20261110` branch remain retained. The original stash
`de3f936fd3e93d094ddf5ff5d7129a8104119f0c` and its preservation branch remain
retained. Do not discard this work or mistake it for the released selection.

Batch `batch-4BqGe_7B` is complete at index 2. Execution remains under
`target/release-frozen/batch-4BqGe_7B`, with durable recovery under
`.git/release-state/frozen/batch-4BqGe_7B/`. Reconciliation completed and the
syn edit was reapplied. No retirement or protected cleanup ran.

The first 0.40.1 batch, `batch-wmST1LGL`, was stopped before delivery after
hosted run 43398940199 exposed GNU Make 3.81 scope/group prerequisite admission
failures on both macOS architectures. Its original source and partial validation
remain retained; do not resume it as repaired source. The consumer-owned Make
repair passed GNU Make 3.81/current Make fixtures under
`target/evidence/toko0401-make381/` before the completed fresh capture.

Failed pre-delivery batch `batch-9uizEjhh` retains its original source and evidence;
do not resume it as repaired source. Its publication-policy fixture was fixed in
the normal checkout before the completed batch reran all required checks.

Earlier completed batches `batch-V1TkLKoY`, `batch-CRinIsG3`, `batch-ic09DJmB`, `batch-Dvpzy0I1`, `batch-9DUaDslR`, `batch-vgM1oJ1f`, `batch-gfJA5IMg`
and `batch-z30yB8KG` retain their candidates/recovery. Failed pre-delivery batch
`batch-C8a10ddy` must not be resumed as repaired source. The delivery-receipt
chain and [retention index](../evidence/README.md) own their identities and
private-source custody. Earlier stashes `a7dbbac568a37876f37f8a89607545a5fba389b2`
and `e5bedde93b31a520a4ff282071099152cb04c555` remain untouched.

The [API inventory](../architecture/metrics-api.md) and [Metrics migration](../../releases/metrics/0.29.md)
retain downstream contract ownership. Producer #130 remains closed; Profiler
[#17](https://github.com/dragginzgame/ic-profiler/issues/17) and each consumer
retain their own outstanding acceptance. No IC cost measurement is implied.
