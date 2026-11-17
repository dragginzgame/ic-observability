# Current handoff — 2026-11-17

## State and next action

Latest checkpoint: `1644e86` (`on hold`). The new request authorizes Toko Tooling
adoption only; product work and delivery remain outside this task.
Metrics **0.30.8** and Logging **0.25.8** were delivered and verified on crates.io;
never re-upload them. The [delivery receipt](../evidence/releases/toko0442-delivery-20261115.md)
owns exact identities, complete plans, timing and source/archive readback.
Hosted native and downstream acceptance remain separate; past observations of
pending CI are not current qualification.

Published Toko Tooling **0.44.11** is selected in root Cargo, Cargo.lock and the
authenticated snapshot. This adoption is local and uncommitted. The exporter
retains 56 entrypoints and 112 files, replacing the unused common-tools action
with its directly called preparation helper and retiring its cache-key companion.
CI setup/scanner failures now retain bounded sanitized diagnostics with original
status and explicit collection/upload reporting; later native failures keep full
recovery custody. Focused local failure/collector tests and snapshot/tool/pin/
format/member checks passed; hosted upload/retrieval remains unobserved.
The [tooling evidence](../evidence/tooling.md) owns scope and record paths.
Both real package locations already satisfy the new layout rule. Product versions
remain 0.30.8 and 0.25.8; pending notes belong to Metrics 0.30.9 and Logging 0.25.9.
The unchanged LOC reporter retains its previous scope-relative depth behavior.

## Ownership and qualification limits

The [API inventory](../architecture/metrics-api.md),
[extraction contract](../architecture/extraction.md) and
[Logging boundary](../architecture/logging.md) own product and consumer contracts.
Production graphs remain dependency-free. IC Build 0.83.0 is the qualified
metadata editor; optional refresh dispositions stay with the delivered ledgers.
Consumer adoption/acceptance belongs to each consumer; published producer APIs
and closed producer issues do not establish IC costs or downstream deployment.

Historical delivery narratives and exact identities remain in the existing
[receipt chain](../evidence/releases/README.md) and Git history. Do not rerun or
reinterpret those releases merely to refresh this handoff. All 20 release
obligations and disabled stage/version-proof reuse remain in force.

## Deferred work and recovery custody

The checkpoint selects syn 3.0.10; this adoption preserves it. Earlier frozen
deliveries used syn 3.0.9, with the separate edit retained under its original custody.
Its current durable stash is `0a33a698131d86db2e68898949aff87045a38a97`, pinned by
`preserved/syn-3.0.10-toko0442-20261115`. Cargo restored the exact syn package block
locally after clean reconciliation; never replay the whole prior lock after version changes.
All preceding stashes and preservation refs remain retained; the
[receipt chain](../evidence/releases/README.md) owns their exact identities.

Batch `batch-ux0e618D` completed at index 2 and reconciled cleanly. Execution remains
under `target/release-frozen/batch-ux0e618D`, with durable recovery under
`.git/release-state/frozen/batch-ux0e618D/`. Earlier completed batches, including
`batch-SPBo7uq9`, `batch-gobrWzyt`, `batch-meIy8QET`, `batch-zAj6vbFx`, `batch-qiGiRmCY`, `batch-z8nN4ysP` and `batch-4BqGe_7B`, retain their candidates
and recovery. They keep original source, layout, catalogs, journals and proof
owners; never reinterpret them with this migration. All 20 release obligations and disabled stage/version-proof reuse remain.

Stopped/failed pre-delivery batches `batch-wmST1LGL`, `batch-9uizEjhh` and
`batch-C8a10ddy` retain original source and partial evidence. Do not resume them as
repaired source. Earlier receipts preserve their failure and repair scopes.
No retirement, protected cleanup, stash deletion or history rewrite ran. The
[retention index](../evidence/README.md) and [distribution record](../evidence/archive-distribution-072.md)
retain earlier evidence and private-original custody.
