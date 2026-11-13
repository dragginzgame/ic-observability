# Current handoff — 2026-11-13

## Published products

Metrics **0.30.3** and Logging **0.25.3** are delivered to GitHub and independently
verified on crates.io. Never re-upload them. The [delivery receipt](../evidence/releases/toko0421-vendor-20261113.md)
owns exact commits, annotated tags, archive hashes, complete plans and registry
readback. Fresh batch `batch-qiGiRmCY` passed both complete 20-stage workspace plans
without narrowing or stage reuse,
then final-version archives, source/tag admission and maintained-source readback
(34 Metrics and 16 Logging files). Stage totals were 525 and 491 seconds;
release-tool fixtures took 371 and 349 seconds. Hosted native and installed
consumer acceptance remain separate and asynchronous. Logging delivery CI was
observed pending; the preceding 0.41.0 delivery CI is green.

## Local 0.42.4 adoption

The root exact pin, both inherited development dependencies, Cargo.lock and the
exporter-owned snapshot select published **toko-tooling 0.42.4**, archive SHA-256
`697efc1801f8c8c3f563364984efff1b941e84eef2cfaade40aece5e09bced2b`.
This adoption is uncommitted and unpushed. Metrics stays 0.30.3 and Logging stays
0.25.3; pending 0.30.4/0.25.4 notes record contributor-tooling changes only.

The same 56 entrypoints/110 files remain selected. The exporter changes only the
baseline, Rust-tool installer and `OwnedTree` helper. Normal setup/admission passed
with the existing common tools and IC Build 0.83.0. The installer can retain an
activated tool after maintenance fails and retry owned cleanup without rebuilding.
Canonical files, product Rust/APIs, compiler/lints and release-stage roster remain
unchanged. The domain-library/endpoint clarification matches the existing boundary;
no codec, endpoint or consumer-ownership migration is needed here.

Snapshot/pin/format/documentation checks, package inventory and custom deployment
drift-refusal checks passed. Evidence is under `target/evidence/toko-tooling-0424/`. Full CI,
release validation and publication are not part of this adoption. Preserve all
prior candidates/refs and the separate syn 3.0.10 edit. The latest delivered
[receipt CI](https://github.com/dragginzgame/ic-observability/actions/runs/43461154117)
was observed in progress; that source does not qualify this later adoption.

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
Its current durable stash is `6e5f2a2d58b10afd34912309d63670a313d6b3c1`, pinned by
`preserved/syn-3.0.10-toko0421-reconcile-20261113`. It remains reapplied locally.
All preceding stashes and preservation refs remain retained; the
[receipt chain](../evidence/releases/README.md) owns their exact identities.

Batch `batch-qiGiRmCY` completed at index 2 and reconciled cleanly. Execution remains
under `target/release-frozen/batch-qiGiRmCY`, with durable recovery under
`.git/release-state/frozen/batch-qiGiRmCY/`. Earlier completed batches, including
`batch-z8nN4ysP` and `batch-4BqGe_7B`, retain their candidates and recovery. They
keep original source, layout, catalogs, journals and proof owners; never reinterpret them with this
migration. All 20 release obligations and disabled stage/version-proof reuse remain.

Stopped/failed pre-delivery batches `batch-wmST1LGL`, `batch-9uizEjhh` and
`batch-C8a10ddy` retain original source and partial evidence. Do not resume them as
repaired source. Earlier receipts preserve their failure and repair scopes.
No retirement, protected cleanup, stash deletion or history rewrite ran. The
[retention index](../evidence/README.md) and [distribution record](../evidence/archive-distribution-072.md)
retain earlier evidence and private-original custody.
