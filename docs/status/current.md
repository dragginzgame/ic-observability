# Current handoff — 2026-11-13

## Published products

Metrics **0.30.2** and Logging **0.25.2** are delivered to GitHub and independently
verified on crates.io. Never re-upload them. The [delivery receipt](../evidence/releases/toko0410-export-20261113.md)
owns exact commits, annotated tags, archive hashes, complete plans and registry
readback. Both passed all 20 workspace stages without narrowing or stage reuse.
The latest delivered [hosted CI](https://github.com/dragginzgame/ic-observability/actions/runs/43431374070)
is now green, including Linux and both macOS architectures. Installed consumer
acceptance remains separately owned. That source selected toko-tooling 0.41.0;
it does not qualify this later local adoption.

## Local tooling adoption

The root exact pin, both inherited development dependencies, Cargo.lock and
exporter-owned receipt now select published **toko-tooling 0.42.1**, archive SHA-256
`697b19c709eccb5f25c0abb0156766ded116abd8bde1552b20022b8af6f51dce`.
This batch is uncommitted and unpushed. Pending Metrics **0.30.3** and Logging
**0.25.3** notes record the migration; package versions remain 0.30.2 and 0.25.2.

The authenticated exporter retired the 108 prior root-layout runtime files after
proving ownership. The final 56-root/110-file snapshot keeps executables, catalogs,
Make includes, composite actions and hooks under `vendor/toko-tooling/`; root
canonical files and `.toko-tooling.snapshot` retain their roles. Consumer scripts,
workflow, release policies and `scripts/ci/CheckProcess.pm` remain local. No managed
files were hand-moved, no old-path aliases were added and canonical bytes match
the published crate. The unused generic root-layout release checker was retired
through the exporter; direct consumer dispatch/refusal/recovery checks remain.

Make, native CI/actions, source hashing, fixture copies, compiler readers and
candidate/metadata/publication adapters call the vendor tree. Validation callers
scope `VALIDATION_REPOSITORY_ROOT` to the actual consumer, rather than deriving it
from the installed helper location. `core.hooksPath` now selects
`vendor/toko-tooling/.githooks`; the old directory contained no custom hooks.
`make deps-list` shows package-first rows for both real members.

Tool installation/admission, snapshot verification, pins, formatting, local and
packaged documentation, compiler policy, native source selection, CI selection,
current/GNU Make 3.81 release/publication dispatch, standard/hook retention,
native success/recovery evidence and product dependency boundaries passed.
Sealed-plan and publication-policy fixtures passed after fixing the explicit-root
caller binding. Both group transactions and the frozen-batch fixture passed;
matched CI/selected-plan trace qualification also passed.

Deployment batch `batch-3okIbLbo` stopped before version preparation or delivery
at the generic exit-probe helper's legacy root-layout copy. Its original source
`66b02a8a99c8b851d1d55cdda210fe497ac2e741` and partial records remain retained;
never resume it as repaired source. The consumer now uses Shared's prefix renderer
with its actual root and preserves all 18 owned cleanup/retention assertions.
The focused `--kind exits` check passed. A fresh whole-source capture is required;
this adapter has no cross-source stage-reuse admission.
Raw previews, failed/fixed attempts and focused results are under
`target/evidence/toko-tooling-0421/`. No broad `make ci`, `make msrv` or actual
release/publication ran for this adoption. The [host guide](../development/hosts.md),
[release guide](../releases/independent-releases.md) and [tooling summary](../evidence/tooling.md)
record the maintained interfaces and evidence limits.

Both packages remain under `crates/` in one virtual workspace, excluding
`qualification`, which contains retired READMEs only. No selection-only package or
qualification workspace is introduced. Rust **1.100.0**, lint policy, public APIs,
features, retained-data semantics and dependency-free production graphs are
unchanged. The separate incoming syn 3.0.10 edit remains; other supplier selections
are unchanged. IC Build **0.83.0** remains the qualified editor. Optional supplier
refresh dispositions remain in the last delivered ledgers and must be revisited
at the next applicable release review. No sibling was edited or deployed.

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
Its current durable stash is `526b26f8fe13ee560cf542f3db1747a33ef746fe`, pinned by
`preserved/syn-3.0.10-toko0410-export-20261113`. It remains reapplied locally.
All preceding stashes and preservation refs remain retained; the
[receipt chain](../evidence/releases/README.md) owns their exact identities.

Batch `batch-z8nN4ysP` completed at index 2 and reconciled cleanly. Execution remains
under `target/release-frozen/batch-z8nN4ysP`, with durable recovery under
`.git/release-state/frozen/batch-z8nN4ysP/`. Earlier completed batches, including
`batch-4BqGe_7B`, retain their candidates and recovery. They keep original source,
layout, catalogs, journals and proof owners; never reinterpret them with this
migration. All 20 release obligations and disabled stage/version-proof reuse remain.

Stopped/failed pre-delivery batches `batch-wmST1LGL`, `batch-9uizEjhh` and
`batch-C8a10ddy` retain original source and partial evidence. Do not resume them as
repaired source. Earlier receipts preserve their failure and repair scopes.
No retirement, protected cleanup, stash deletion or history rewrite ran. The
[retention index](../evidence/README.md) and [distribution record](../evidence/archive-distribution-072.md)
retain earlier evidence and private-original custody.
