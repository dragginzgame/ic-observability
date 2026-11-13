# Current handoff — 2026-11-13

## Published products and tooling

Metrics **0.30.0** and Logging **0.25.0** are delivered to GitHub and
independently verified on crates.io. Never re-upload those versions. The
[delivery receipt](../evidence/releases/toko0400-rust1100-20261113.md) owns exact
commits, annotated tags, archive hashes, complete plans and registry readback.
Both passed all 20 workspace stages without narrowing or stage reuse, followed
by final archive compilation and matching maintained source (34 Metrics and
16 Logging files). Hosted macOS and installed consumer acceptance remain separate
and asynchronous; pending or cancelled checks are not passes.

Both delivered packages require **Rust 1.100.0** on native and Wasm and inherit
common lint policy. Their published requirements retain toko-tooling 0.40.0 and
the delivery receipt's original identities.

The local root pin, Cargo.lock and authenticated snapshot now select published
**toko-tooling 0.40.1**, archive SHA-256
`fb884b05e2e5bbca2388dd0b757833fb5ad37e91b3ced09f6a37b454c7fe9f90`.
This adoption is uncommitted and unpushed. The exporter preserves 55 roots and
111 files, changing only the baseline; prepared tools are admitted, with no
compiler, executable or product Rust changes. Shared references stay upstream.
Pending Metrics **0.30.1** and Logging **0.25.1** notes are contributor-tooling
patches; this task does not execute another release.

The [release guide](../releases/independent-releases.md) records actual nested
commands, measured stage costs and the current missing cross-source/collector
recovery admission. All 20 release obligations and disabled stage reuse remain.
The 0.40.1 policy requires planned validation and failure-specific recovery; it
does not itself implement skipped-stage admission. Focused installation, tool,
pin, format and documentation checks are under `target/evidence/toko-tooling-0401/`.
Unchanged product/fixture evidence retains its 0.40.0 delivery source and scope.

[#134 — Adopt Rust 1.100.0 and the common lint policy](https://github.com/dragginzgame/ic-observability/issues/134)
is closed. Focused evidence under `target/evidence/toko-tooling-0400/` includes
actual compiler identities, both generated consumers and typed native/Wasm lint
refusals. Current full release transcripts and supplier review are under
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
`96058885f9422b59860801243f934678d1abd175`, pinned by branch
`preserved/syn-3.0.10-toko0400-20261113`. The earlier stash/ref
`6511a6979fae869912f7f3f2f6a3e7b968bb9792` and its
`preserved/syn-3.0.10-toko03917-20261112` branch remain retained. The earlier stash/ref
`39f97a10b8ecd7f567b3b69696b7c71fb549ab01` and its
`preserved/syn-3.0.10-toko0397-20261110` branch remain retained. The original stash
`de3f936fd3e93d094ddf5ff5d7129a8104119f0c` and its preservation branch remain
retained. Do not discard this work or mistake it for the released selection.

Batch `batch-V1TkLKoY` is complete at index 2. Execution remains under
`target/release-frozen/batch-V1TkLKoY`, with durable recovery under
`.git/release-state/frozen/batch-V1TkLKoY/`. Reconciliation completed and the
syn edit was reapplied. No retirement or protected cleanup ran.

The first 0.40.1 batch, `batch-wmST1LGL`, was stopped before delivery after
hosted run 43398940199 exposed GNU Make 3.81 scope/group prerequisite admission
failures on both macOS architectures. Its original source and partial validation
remain retained; do not resume it as repaired source. The consumer-owned Make
repair is qualified first with actual GNU Make 3.81 and current Make fixtures
under `target/evidence/toko0401-make381/`, before a fresh release capture.

Failed pre-delivery batch `batch-9uizEjhh` retains its original source and evidence;
do not resume it as repaired source. Its publication-policy fixture was fixed in
the normal checkout before the completed batch reran all required checks.

Earlier completed batches `batch-CRinIsG3`, `batch-ic09DJmB`, `batch-Dvpzy0I1`, `batch-9DUaDslR`, `batch-vgM1oJ1f`, `batch-gfJA5IMg`
and `batch-z30yB8KG` retain their candidates/recovery. Failed pre-delivery batch
`batch-C8a10ddy` must not be resumed as repaired source. The delivery-receipt
chain and [retention index](../evidence/README.md) own their identities and
private-source custody. Earlier stashes `a7dbbac568a37876f37f8a89607545a5fba389b2`
and `e5bedde93b31a520a4ff282071099152cb04c555` remain untouched.

The [API inventory](../architecture/metrics-api.md) and [Metrics migration](../../releases/metrics/0.29.md)
retain downstream contract ownership. Producer #130 remains closed; Profiler
[#17](https://github.com/dragginzgame/ic-profiler/issues/17) and each consumer
retain their own outstanding acceptance. No IC cost measurement is implied.
