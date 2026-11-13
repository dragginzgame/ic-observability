# Current handoff — 2026-11-13

## Published products

Metrics **0.30.4** and Logging **0.25.4** are delivered to GitHub and independently
verified on crates.io. Never re-upload them. The [delivery receipt](../evidence/releases/toko0424-delivery-20261113.md)
owns exact commits, annotated tags, archive hashes, complete plans and registry
readback. Batch `batch-zAj6vbFx` passed both complete 20-stage workspace plans
without narrowing or stage reuse, followed by final-version archives, source/tag
admission and maintained-source readback
(34 Metrics and 16 Logging files). Stage totals were 511 and 484 seconds;
release-tool fixtures took 366 and 343 seconds. Hosted native and installed
consumer acceptance remain separate and asynchronous. Logging delivery CI was
observed pending; pending or cancelled runs are not passes.

## Delivered 0.42.4 tooling

The root exact pin, both inherited development dependencies, Cargo.lock and the
exporter-owned snapshot select published **toko-tooling 0.42.4**, archive SHA-256
`697efc1801f8c8c3f563364984efff1b941e84eef2cfaade40aece5e09bced2b`.
Delivery source is `10bb4b09110b21d319820f96ea4535c8734fe284`. The release
advances only the selected package versions and their tooling notes; product
Rust/APIs, compiler policy and production dependencies remain unchanged.

The same 56 entrypoints/110 files remain selected. The exporter changes only the
baseline, Rust-tool installer and `OwnedTree` helper. Normal setup/admission passed
with the existing common tools and IC Build 0.83.0. The installer can retain an
activated tool after maintenance fails and retry owned cleanup without rebuilding.
Canonical files, product Rust/APIs, compiler/lints and release-stage roster remain
unchanged. The domain-library/endpoint clarification matches the existing boundary;
no codec, endpoint or consumer-ownership migration is needed here.

Snapshot/pin/format/documentation checks, package inventory and custom deployment
drift-refusal checks passed. Evidence is under `target/evidence/toko-tooling-0424/`.
Both complete release plans, final archives and registry/source readback passed.
Preserve all prior candidates/refs and the separate syn 3.0.10 edit. The latest delivered
[Logging CI](https://github.com/dragginzgame/ic-observability/actions/runs/43466158474)
was observed pending; native and installed consumer acceptance remain asynchronous.

## Delivered 0.42.1 tooling

The published source `925cdc3f661624a6a4286d523f9ee9699e8d71fb` used
0.42.1 for the vendor migration, explicit consumer-root validation and local
exit-prefix qualification. Its [receipt](../evidence/releases/toko0421-vendor-20261113.md)
owns exact identities, complete plans and registry/source readback. The local
exit-probe adapter and all 18 cleanup/retention assertions remain unchanged.

Initial batch `batch-3okIbLbo` stopped before version preparation or delivery
at the generic exit runner's retired root-layout copy. It retains original source
`66b02a8a99c8b851d1d55cdda210fe497ac2e741` and partial evidence; never resume
it as repaired. Fresh batch `batch-qiGiRmCY` passed both complete plans. No
cross-source stage reuse or collector-repair admission is enabled.

Both packages remain under `crates/` in one virtual workspace excluding the
retired `qualification` tree. Product Rust, Rust 1.100.0, lint policy, public APIs
and dependency-free production graphs are unchanged. IC Build 0.83.0 remains the
qualified editor; optional refresh dispositions stay in the last delivered ledgers
until the next applicable review. No sibling was changed or deployed.

## Product and consumer ownership

Logging's last delivered export example uses direct writes after exact UTF-8
length checks, preserving typed errors and continuation. Metrics' bounded-table
omission APIs and Logging's typed history are already published. The
[API inventory](../architecture/metrics-api.md), [extraction contract](../architecture/extraction.md)
and [Logging boundary](../architecture/logging.md) retain their ownership limits.
Producer issues #130, #133 and #134 remain closed. Canic
[#755](https://github.com/dragginzgame/canic/issues/755) and
[#756](https://github.com/dragginzgame/canic/issues/756), Profiler
[#17](https://github.com/dragginzgame/ic-profiler/issues/17), IC Storage and each
consumer retain their own outstanding adoption/acceptance. No IC cost measurement
or downstream deployment is implied.

## Deferred work and recovery custody

The separate syn 3.0.10 edit remains outside the last published syn 3.0.9 graph.
Its current durable stash is `b2ea8921ac8149c0391c3053bb51c28aee5f3fb2`, pinned by
`preserved/syn-3.0.10-toko0424-reconcile-20261113`. It remains reapplied locally.
All preceding stashes and preservation refs remain retained; the
[receipt chain](../evidence/releases/README.md) owns their exact identities.

Batch `batch-zAj6vbFx` completed at index 2 and reconciled cleanly. Execution remains
under `target/release-frozen/batch-zAj6vbFx`, with durable recovery under
`.git/release-state/frozen/batch-zAj6vbFx/`. Earlier completed batches, including
`batch-qiGiRmCY`, `batch-z8nN4ysP` and `batch-4BqGe_7B`, retain their candidates
and recovery. They keep original source, layout, catalogs, journals and proof
owners; never reinterpret them with this migration. All 20 release obligations and disabled stage/version-proof reuse remain.

Stopped/failed pre-delivery batches `batch-wmST1LGL`, `batch-9uizEjhh` and
`batch-C8a10ddy` retain original source and partial evidence. Do not resume them as
repaired source. Earlier receipts preserve their failure and repair scopes.
No retirement, protected cleanup, stash deletion or history rewrite ran. The
[retention index](../evidence/README.md) and [distribution record](../evidence/archive-distribution-072.md)
retain earlier evidence and private-original custody.
