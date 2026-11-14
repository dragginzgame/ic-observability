# Current handoff — 2026-11-14

## Published products

Metrics **0.30.5** and Logging **0.25.5** are delivered to GitHub and independently
verified on crates.io. Never re-upload them. The [delivery receipt](../evidence/releases/toko0425-delivery-20261113.md)
owns exact commits, annotated tags, archive hashes, complete plans and registry
readback. Batch `batch-meIy8QET` passed both complete 20-stage workspace plans
without narrowing or stage reuse, followed by final-version archives, source/tag
admission and maintained-source readback
(34 Metrics and 16 Logging files). Stage totals were 505 and 521 seconds;
release-tool fixtures took 356 and 377 seconds. Hosted native and installed
consumer acceptance remain separate and asynchronous. Logging delivery CI was
observed pending; pending or cancelled runs are not passes.

## Prepared 0.43.0 delivery

Root Cargo selection, inherited dev-dependencies, lock and authenticated snapshot
select published **toko-tooling 0.43.0**, archive SHA-256
`060d3507b66eb290ce12bc2572098f7e7cb1e12e9d6697a9b1a5d1552fcb2588`.
All 56 entrypoints remain; the new PATH launcher is a required companion, for
111 managed files. Relative to the local 0.42.8 payload, only the shared Make
LOC interface and reporter change, plus the launcher. Existing CDPATH fixes carry
forward. Use `toko-cloc` and `-d N`; active docs and consumer Make help are
migrated. Baseline/canonical files, compiler/lints, product Rust/APIs and release
roster stay intact. Producer regression suites remain upstream.

Installation/tool admission, snapshot/pin/format checks, membership and deployment
drift refusal passed. The PATH launcher matches the release and successfully
reports repository JSON and recording-module detail. The actual consumer hook
fixture passed with CDPATH set against the new Make include. Cargo changed only
toko-tooling from the incoming lock; syn remains byte-identical.

Current records are under `target/evidence/toko-tooling-0430/`; prior local
CDPATH/hook evidence remains under `target/evidence/toko-tooling-0428/`.
Authorized delivery selects Metrics 0.30.6 then Logging 0.25.6, with both complete
workspace plans and verified publication. The normal checkout remains on `main`;
the managed candidate owns effects to `origin/main`. Final Git/registry results
remain pending. Preserve the separate syn 3.0.10 edit and every previous
candidate, stash and recovery ref.

## Delivered 0.42.5 tooling

Source `45689e21ef4cf4dfb2dcd6de82a8124ff9624866` delivered Metrics then
Logging with complete plans and verified registry publication. Its
[receipt](../evidence/releases/toko0425-delivery-20261113.md) owns exact identities,
archive/source readback and custody. The 18 exit checks now use Shared's repaired
vendor-aware helper. Hosted CI was observed pending/in progress; those historical
observations do not qualify this new local source.

## Delivered 0.42.4 tooling

Published source `10bb4b09110b21d319820f96ea4535c8734fe284` used 0.42.4
for managed tool activation/maintenance recovery. Its
[receipt](../evidence/releases/toko0424-delivery-20261113.md) owns complete plans,
registry/source readback and custody. The current adoption supersedes that
source's local exit-prefix workaround; product engines remain unchanged.

## Delivered 0.42.1 tooling

The published source `925cdc3f661624a6a4286d523f9ee9699e8d71fb` used
0.42.1 for the vendor migration, explicit consumer-root validation and local
exit-prefix qualification. Its [receipt](../evidence/releases/toko0421-vendor-20261113.md)
owns exact identities, complete plans and registry/source readback. The
18 cleanup/retention assertions remain; their current execution owner is Shared.

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

The separate syn 3.0.10 edit remains outside the frozen syn 3.0.9 graph.
Its current durable stash is `ed73c698f3ff895ed6ed994ac011514e0cdf67ae`, pinned by
`preserved/syn-3.0.10-toko0430-20261114`. Reapply it after clean reconciliation.
All preceding stashes and preservation refs remain retained; the
[receipt chain](../evidence/releases/README.md) owns their exact identities.

Batch `batch-meIy8QET` completed at index 2 and reconciled cleanly. Execution remains
under `target/release-frozen/batch-meIy8QET`, with durable recovery under
`.git/release-state/frozen/batch-meIy8QET/`. Earlier completed batches, including
`batch-zAj6vbFx`, `batch-qiGiRmCY`, `batch-z8nN4ysP` and `batch-4BqGe_7B`, retain their candidates
and recovery. They keep original source, layout, catalogs, journals and proof
owners; never reinterpret them with this migration. All 20 release obligations and disabled stage/version-proof reuse remain.

Stopped/failed pre-delivery batches `batch-wmST1LGL`, `batch-9uizEjhh` and
`batch-C8a10ddy` retain original source and partial evidence. Do not resume them as
repaired source. Earlier receipts preserve their failure and repair scopes.
No retirement, protected cleanup, stash deletion or history rewrite ran. The
[retention index](../evidence/README.md) and [distribution record](../evidence/archive-distribution-072.md)
retain earlier evidence and private-original custody.
