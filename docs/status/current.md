# Current handoff — 2026-11-12

## Published products and tooling

Metrics **0.29.11** and Logging **0.24.16** are delivered to GitHub and
independently verified on crates.io. Never re-upload those versions. The
[delivery receipt](../evidence/releases/toko0397-docs-20261110.md) owns exact
commits, annotated tags, archive hashes, complete plans and registry readback.
Both passed all 20 workspace stages without narrowing or stage reuse, followed
by final archive compilation and matching maintained source (34 Metrics and
16 Logging files). Hosted macOS and installed consumer acceptance remain separate
and asynchronous; pending or cancelled checks are not passes.

The local root Cargo pin, inherited dev-dependencies, lock and snapshot select
published toko-tooling **0.39.17**, archive SHA-256
`aaeab49adb84ea0d66cf86ecc48d826125f9c3ac6eafaf2a362bccfeba7acbfd`.
This refresh is local and uncommitted; the published products above retain their
original 0.39.7 tooling selection and source identities.
The receipt retains the existing selection and adds the dependency-update module,
for 55 roots and 111 files. `make deps-update` is explicit Cargo maintenance;
it is not a CI/release prerequisite or a supplier freshness review. Shared
reference docs stay upstream
at reviewed commit-pinned URLs; native guides are organised by topic through the
[documentation index](../README.md). The earlier managed-document namespace plan
is superseded. Current installation and focused evidence are under
`target/evidence/toko-tooling-03917/`; the [tooling summary](../evidence/tooling.md)
records the scope. Five test module files move byte-identically into their owning
`tests/mod.rs` paths. Production Rust, public APIs and release obligations are
unchanged; the package library test inventories remain preserved.
The consumer retains `TOKO_TOOLING_RELEASE := 1` and explicitly selects
`validation-evidence.pl` for its actual release caller.

The [source inventory](../governance/source-origins.md) records component origins.
The IC Storage adapter ownership edits and current product links are delivered.
The deferred syn 3.0.10 edit remains separate from the released syn 3.0.9 graph.

Delivery is selected for Metrics 0.29.12 and Logging 0.24.17 through the frozen
batch workflow. The native release editor selects published IC Build 0.83.0.
Supplier registry review and optional-refresh dispositions are recorded in both
pending group ledgers; the standard runner owns version preparation and notes.

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
`39f97a10b8ecd7f567b3b69696b7c71fb549ab01`, pinned by branch
`preserved/syn-3.0.10-toko0397-20261110`. The earlier stash
`de3f936fd3e93d094ddf5ff5d7129a8104119f0c` and its preservation branch remain
retained. Do not discard this work or mistake it for the released selection.

Batch `batch-ic09DJmB` is complete at index 2. Execution remains under
`target/release-frozen/batch-ic09DJmB`, with durable recovery under
`.git/release-state/frozen/batch-ic09DJmB/`. Reconciliation completed and the
syn edit was reapplied. No retirement or protected cleanup ran.

Failed pre-delivery batch `batch-9uizEjhh` retains its original source and evidence;
do not resume it as repaired source. Its publication-policy fixture was fixed in
the normal checkout before the completed batch reran all required checks.

Earlier completed batches `batch-Dvpzy0I1`, `batch-9DUaDslR`, `batch-vgM1oJ1f`, `batch-gfJA5IMg`
and `batch-z30yB8KG` retain their candidates/recovery. Failed pre-delivery batch
`batch-C8a10ddy` must not be resumed as repaired source. The delivery-receipt
chain and [retention index](../evidence/README.md) own their identities and
private-source custody. Earlier stashes `a7dbbac568a37876f37f8a89607545a5fba389b2`
and `e5bedde93b31a520a4ff282071099152cb04c555` remain untouched.

The [API inventory](../architecture/metrics-api.md) and [Metrics migration](../../releases/metrics/0.29.md)
retain downstream contract ownership. Producer #130 remains closed; Profiler
[#17](https://github.com/dragginzgame/ic-profiler/issues/17) and each consumer
retain their own outstanding acceptance. No IC cost measurement is implied.
