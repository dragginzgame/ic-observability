# Current handoff — 2026-11-13

## Published products and tooling

Metrics **0.29.12** and Logging **0.24.17** are delivered to GitHub and
independently verified on crates.io. Never re-upload those versions. The
[delivery receipt](../evidence/releases/toko03917-delivery-20261112.md) owns exact
commits, annotated tags, archive hashes, complete plans and registry readback.
Both passed all 20 workspace stages without narrowing or stage reuse, followed
by final archive compilation and matching maintained source (34 Metrics and
16 Logging files). Hosted macOS and installed consumer acceptance remain separate
and asynchronous; pending or cancelled checks are not passes.

The local Cargo selection and authenticated snapshot now select published
**toko-tooling 0.40.0**, archive SHA-256
`9c1758c3c04e2754d97fd38d29177d73fc03d3d414d654f689d8b75cbc7ed918`.
Both product members inherit its dev-dependency and the root common lint table.
The root and retained-consumer fixtures select **Rust 1.100.0**; explicit setup
prepared native/Wasm support and rebuilt/admitted managed tools for that compiler.
The exporter preserves 55 roots and 111 files, changing only the shared baseline.
Shared reference docs remain upstream; canonical files and executable bytes are
unchanged. No production Rust, public API or retention arithmetic changed.

[#134 — Adopt Rust 1.100.0 and the common lint policy](https://github.com/dragginzgame/ic-observability/issues/134)
is implemented locally. Strict native/Wasm Clippy and Rustdoc, all-feature and
minimal Metrics tests, feature graphs, allocator-free Wasm linking, compiler-policy
fixtures and both generated public consumers passed. Disposable consumers also
proved typed rejection of unsafe code, ignored results, dead code, stale lint
expectations and broken Rustdoc links on both targets. Actual compiler identities
and focused transcripts are under `target/evidence/toko-tooling-0400/`.
Linux x86_64 was exercised; macOS hosts were unavailable and remain unqualified
for these new inputs. No full release roster or hosted matrix was run.

This adoption is uncommitted and unpushed. Pending **Metrics 0.30.0** and
**Logging 0.25.0** notes record the consumer Rust-floor change: consumers need
Rust 1.100.0 before adopting the next release. Published identities above remain
unchanged. Stage reuse remains disabled and all 20 release obligations remain.
The deferred syn 3.0.10 edit and all recovery custody below are preserved.

The native release editor selects published IC Build **0.83.0**. Both group
ledgers record current supplier review and optional-refresh dispositions for
cargo-sort-derives and the editor's packaged IC Host lock. Review those again
at the next applicable maintenance/release boundary. Focused adoption/layout
checks remain under `target/evidence/toko-tooling-03917/`; current delivery
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
`6511a6979fae869912f7f3f2f6a3e7b968bb9792`, pinned by branch
`preserved/syn-3.0.10-toko03917-20261112`. The earlier stash/ref
`39f97a10b8ecd7f567b3b69696b7c71fb549ab01` and its
`preserved/syn-3.0.10-toko0397-20261110` branch remain retained. The original stash
`de3f936fd3e93d094ddf5ff5d7129a8104119f0c` and its preservation branch remain
retained. Do not discard this work or mistake it for the released selection.

Batch `batch-CRinIsG3` is complete at index 2. Execution remains under
`target/release-frozen/batch-CRinIsG3`, with durable recovery under
`.git/release-state/frozen/batch-CRinIsG3/`. Reconciliation completed and the
syn edit was reapplied. No retirement or protected cleanup ran.

Failed pre-delivery batch `batch-9uizEjhh` retains its original source and evidence;
do not resume it as repaired source. Its publication-policy fixture was fixed in
the normal checkout before the completed batch reran all required checks.

Earlier completed batches `batch-ic09DJmB`, `batch-Dvpzy0I1`, `batch-9DUaDslR`, `batch-vgM1oJ1f`, `batch-gfJA5IMg`
and `batch-z30yB8KG` retain their candidates/recovery. Failed pre-delivery batch
`batch-C8a10ddy` must not be resumed as repaired source. The delivery-receipt
chain and [retention index](../evidence/README.md) own their identities and
private-source custody. Earlier stashes `a7dbbac568a37876f37f8a89607545a5fba389b2`
and `e5bedde93b31a520a4ff282071099152cb04c555` remain untouched.

The [API inventory](../architecture/metrics-api.md) and [Metrics migration](../../releases/metrics/0.29.md)
retain downstream contract ownership. Producer #130 remains closed; Profiler
[#17](https://github.com/dragginzgame/ic-profiler/issues/17) and each consumer
retain their own outstanding acceptance. No IC cost measurement is implied.
