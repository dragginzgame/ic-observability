# Current handoff — 2026-11-17

## State and next action

**Metrics 0.30.11 and Logging 0.25.10 are delivered and independently verified.**
[Observability #136](https://github.com/dragginzgame/ic-observability/issues/136)
is closed. Reconstruction source is `3974fd375485c133b5284255c4d09477167b8c32`.
The [delivery record](../releases/independent-releases.md#live-delivery--2026-11-17)
owns commits, tags, checksums, timings and verification scope.

Batch `batch-dZNTL4CS` completed both groups and reconciled cleanly. Its real
capture-through-publication interval was **166.8 seconds**. Both three-stage plans
passed; final-version archives and source/registry readback matched 34 Metrics
and 16 Logging maintained files. Post-push review found no actionable issue in
the delivered pipeline/callers or either group's exact metadata increment.
No product Rust/API, supplier selection or sibling was changed.

The normal checkout now contains both release commits. The completed candidate
and durable journal remain under `target/release-frozen/batch-dZNTL4CS` and
`.git/release-state/frozen/batch-dZNTL4CS/`. No retirement or cleanup ran.
Local delivery records are under `target/deploy/issue136-20261117/`.
Hosted native CI remains asynchronous; no completed hosted pass is claimed.

CI covers both products on the three supported hosts. Releases use fresh
admission, strict lint and selected-package product checks; tooling qualification
is separate. The [guarantee map](../releases/independent-releases.md#release-stage-ownership-and-triggers)
owns commands and proof boundaries. The earlier matched fixture (281 → 167 seconds)
retains its separate simulated-registry/legacy-fixture-substitution scope under
`target/qualification/issue136-rebuild/`; it is not the live measurement above.

Stopped historical batch `batch-sSjwd230` remains untouched. It delivered only
Metrics 0.30.10 at `b9d488dec7eaf40c79f665880051b2d45c68ae1a`; its Logging
0.25.10 attempt was interrupted before delivery. The new batch independently
published Logging 0.25.10. Never resume or reinterpret the old attempt with new
semantics. Its original proof and publication record remain under that candidate
and `target/deploy/issue135-20261117/`.

Toko Tooling **0.44.11** and Rust **1.100.0** remain selected. The exporter-owned
snapshot has 55 roots / 111 files after retiring the unused stage runner and
retention probe. This design does not depend on
[Toko Tooling #389](https://github.com/dragginzgame/toko-tooling/issues/389).
Historical probe evidence remains under `target/qualification/issue136/`.
Earlier delivery identities are in the [receipt chain](../evidence/releases/README.md).

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
