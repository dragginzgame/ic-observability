# Current handoff — 2026-11-15

## Published products

Metrics **0.30.7** and Logging **0.25.7** are delivered to GitHub and independently
verified on crates.io. Never re-upload them. The [delivery receipt](../evidence/releases/toko0432-delivery-20261114.md)
owns exact commits, annotated tags, archive hashes, complete plans and registry
readback. Batch `batch-SPBo7uq9` passed both complete 20-stage workspace plans
without narrowing or stage reuse, followed by final-version archives, source/tag
admission and maintained-source readback. The retained
[native CI run](https://github.com/dragginzgame/ic-observability/actions/runs/43623329723)
subsequently passed Linux, macOS Intel and macOS ARM, including native checks.
Earlier superseded runs were cancelled; the protected receipt retains its original
pending-at-delivery observation. Downstream acceptance remains consumer-owned.

## Local 0.44.2 tooling adoption

Root Cargo selection, Cargo.lock and the authenticated vendor payload now agree
on published **toko-tooling 0.44.2**, archive SHA-256
`d8a17b4fb7429edc446c06b1c50149102d17cf93e15dade9f53c187a1717c373`.
The exporter retained 56 entrypoints and 114 files. This patch changes only the
baseline: review delivered commits and directly affected callers after each push,
before the next increment. Use the normal delivery response and existing follow-up
records; no hook or validation target is added. The local release guide links it.

The unchanged 0.44.1 runtime retains passing LOC defaults/module, timing-reader,
external-IC dependency and deployment drift-refusal evidence. Plain `toko-cloc`
matches `-d 0`; retained live timing records are unchanged and malformed copies
were refused with bytes intact. Current installation, snapshot/tool/pin/format,
documentation and inventory checks passed and are recorded in
[the tooling evidence](../evidence/tooling.md), with focused records under
`target/evidence/toko-tooling-0442/`. Compiler/lints, legal files, product Rust/APIs
and release gates remain unchanged. Pending notes belong to Metrics 0.30.8
and Logging 0.25.8; package versions remain 0.30.7 and 0.25.7.
This adoption is local and uncommitted; no new release or deployment ran.

## Delivered 0.43.2 tooling

Source `2138f76c237a1af23ab00061b06d9b7b4e578838` delivered 0.43.2 tooling
with Metrics 0.30.7 and Logging 0.25.7. The
[receipt](../evidence/releases/toko0432-delivery-20261114.md) owns exact source,
plans, timing observations, supplier dispositions and custody. Consumer fixtures
clear invoking timing context; live records exclude simulated effects.
Old batches still return `[]`; never backfill journals or infer proof reuse.
Delivery records use `target/deploy/toko0432-20261114/`; original adoption checks
remain under `target/evidence/toko-tooling-0432/`. Normal `main` subsequently reached
receipt commit `a93e3b6a5f9ee91aca8641a04b7bf90e46824615`.

## Delivered 0.43.0 tooling

Source `7d9c1a2c75932374e828b799c91f04c26c32a192` delivered Metrics then
Logging with both complete plans and verified publication. Its
[receipt](../evidence/releases/toko0430-delivery-20261114.md) owns exact identities,
phase measurements and custody. LOC uses `toko-cloc`; CDPATH hook fixes remain.
Hosted CI was observed in progress; that historical observation does not qualify
this new local source.

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
Its current durable stash is `10a7bac2485e4217206bdf01ef62a11425e1a28f`, pinned by
`preserved/syn-3.0.10-toko0432-20261114`. It is reapplied locally after clean reconciliation.
All preceding stashes and preservation refs remain retained; the
[receipt chain](../evidence/releases/README.md) owns their exact identities.

Batch `batch-SPBo7uq9` completed at index 2 and reconciled cleanly. Execution remains
under `target/release-frozen/batch-SPBo7uq9`, with durable recovery under
`.git/release-state/frozen/batch-SPBo7uq9/`. Earlier completed batches, including
`batch-gobrWzyt`, `batch-meIy8QET`, `batch-zAj6vbFx`, `batch-qiGiRmCY`, `batch-z8nN4ysP` and `batch-4BqGe_7B`, retain their candidates
and recovery. They keep original source, layout, catalogs, journals and proof
owners; never reinterpret them with this migration. All 20 release obligations and disabled stage/version-proof reuse remain.

Stopped/failed pre-delivery batches `batch-wmST1LGL`, `batch-9uizEjhh` and
`batch-C8a10ddy` retain original source and partial evidence. Do not resume them as
repaired source. Earlier receipts preserve their failure and repair scopes.
No retirement, protected cleanup, stash deletion or history rewrite ran. The
[retention index](../evidence/README.md) and [distribution record](../evidence/archive-distribution-072.md)
retain earlier evidence and private-original custody.
