# Current handoff — 2026-11-17

## State and next action

[Observability #136 — Reconstruct CI and release tooling](https://github.com/dragginzgame/ic-observability/issues/136)
is implemented locally, replacing the old caching scope. The local
pipeline now has three mandatory product stages (admission, strict lint, selected
product checks); full CI covers both packages and archives. Tooling regression
qualification is separate. The nested retention coordinator and baseline-driven
omission selector are removed. No product Rust/API or dependency changes.
The [guarantee map](../releases/independent-releases.md#release-stage-ownership-and-triggers)
owns commands, coverage and measured evidence. Focused routing, refusal, evidence
custody and two-package recovery checks passed. The matched delivery fixture took
281 → 167 seconds (real product/archive work, local Git/simulated registry, old
regression bodies stubbed in both runs). No live-release speed claim follows.
Evidence is under `target/qualification/issue136-rebuild/`; implementation is
qualified; the user has authorized delivery of both groups. A fresh batch will
select Metrics 0.30.11 and Logging 0.25.10 with verified publication.

The user stopped deployment batch `batch-sSjwd230`. Metrics **0.30.10** was
published and independently verified at commit
`b9d488dec7eaf40c79f665880051b2d45c68ae1a`; Logging remains **0.25.9**.
Logging 0.25.10 has no delivered tag/upload. The stopped candidate retains its
original adapter, partial validation and durable journal; do not resume it with
replacement semantics. Normal main was fast-forwarded to the delivered Metrics
prefix before reconstruction. Pending notes now select Metrics 0.30.11 and
Logging 0.25.10. The new batch must preserve all stopped-batch custody.

Metrics 0.30.10 checksum is
`205286dceb753a70df354e6147e858fc4bfb604815b612f64d2392ae51593d14`;
34 maintained package files matched source. Local deployment records are under
`target/deploy/issue135-20261117/` and the frozen candidate's
`target/publication/verification.sniTvi`. Its Metrics 20-stage plan passed;
Logging was stopped during the old nested tooling fixture stage.
Hosted CI [44144314472](https://github.com/dragginzgame/ic-observability/actions/runs/44144314472)
was last observed in progress; no completed native result is claimed here.

Toko Tooling **0.44.11**, Rust **1.100.0** and dependency selections remain intact.
The exporter retired the unused stage runner and retention probe: 55 roots /
111 files remain.
This reconstruction does not depend on
[Toko Tooling #389](https://github.com/dragginzgame/toko-tooling/issues/389).
The earlier probe remains historical under `target/qualification/issue136/`.
Earlier delivered identities and CI repair are in the
[delivery receipt](../evidence/releases/toko04411-delivery-20261117.md).

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
reinterpret those releases merely to refresh this handoff. Historical plans retain their original obligations. New plans use explicit selected-package scope; stage/version-proof reuse remains disabled.

## Deferred work and recovery custody

Initial `batch-ex9xCVty` stopped before metadata/delivery at the old security
fixture assertion, source `d01b3c08bdba7c77b17913715fa558576ad4ae01`. Its candidate
and partial proof remain; never resume it as repaired. The later CI correction
was preserved across reconciliation in stash `dca635bcc63ff73ec8553fdc43fcdfc442a0ad4f`,
pinned by `preserved/ci-prerequisites-toko04411-20261117`, then restored exactly
and delivered. Keep that stash/ref and all preceding recovery custody.

The checkpoint selects syn 3.0.10; this adoption preserves it. Earlier frozen
deliveries used syn 3.0.9, with the separate edit retained under its original custody.
Its current durable stash is `0a33a698131d86db2e68898949aff87045a38a97`, pinned by
`preserved/syn-3.0.10-toko0442-20261115`. Cargo restored the exact syn package block
locally after clean reconciliation; never replay the whole prior lock after version changes.
All preceding stashes and preservation refs remain retained; the
[receipt chain](../evidence/releases/README.md) owns their exact identities.

Batch `batch-n9adqUv3` completed at index 2 and reconciled cleanly. Execution remains
under `target/release-frozen/batch-n9adqUv3`, with durable recovery under
`.git/release-state/frozen/batch-n9adqUv3/`. Earlier completed batches, including
`batch-ux0e618D`,
`batch-SPBo7uq9`, `batch-gobrWzyt`, `batch-meIy8QET`, `batch-zAj6vbFx`, `batch-qiGiRmCY`, `batch-z8nN4ysP` and `batch-4BqGe_7B`, retain their candidates
and recovery. They keep original source, layout, catalogs, journals and proof
owners; never reinterpret them with this migration. Original full-roster proofs retain their scope; stage/version-proof reuse remains disabled.

Stopped/failed pre-delivery batches `batch-wmST1LGL`, `batch-9uizEjhh` and
`batch-C8a10ddy` retain original source and partial evidence. Do not resume them as
repaired source. Earlier receipts preserve their failure and repair scopes.
No retirement, protected cleanup, stash deletion or history rewrite ran. The
[retention index](../evidence/README.md) and [distribution record](../evidence/archive-distribution-072.md)
retain earlier evidence and private-original custody.
