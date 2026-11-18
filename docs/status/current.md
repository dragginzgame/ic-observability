# Current handoff — 2026-11-18

## State and next action

Local maintenance adopts **Toko Tooling 0.45.8**, with locked Cargo calls preserving
caller network settings, Rust test-module/import layout cleanup and removal of an
unused broad lint allowance. Product versions/APIs remain unchanged. This work is
uncommitted and unpublished; the prior handoff commit `57d4a78` remains local after
automatic approval review rejected its additional documentation push.
The full hygiene/adoption review found two independently reproduced tooling gaps,
now repaired locally with focused regression checks:
[Observability #138](https://github.com/dragginzgame/ic-observability/issues/138)
(empty package metadata passes) and
[Observability #139](https://github.com/dragginzgame/ic-observability/issues/139)
(URL fragment diagnostic redaction). Package inventory admission now requires
a complete, nonempty member roster before staging. Setup redaction uses the
authenticated Shared helper; paths, original statuses and existing secret
coverage remain consumer-owned. The 21 package-input and 72 diagnostic assertions,
real package-document check and snapshot admission passed. Evidence is under
`target/qualification/issues138-139-20261118/`. Both repairs remain uncommitted
and unpublished. The original audit remains historical pre-repair evidence.
The [audit report](../reports/audits/2026/11/18/hygiene-adoption/01/report.md)
records scope, evidence and limits. Current evidence is under
`target/qualification/toko0458-hygiene-20261118/`.

**Metrics 0.30.13 and Logging 0.25.12 are delivered and independently verified.**
The delivery selects Toko Tooling **0.45.3** through the authenticated
exporter, adding batch timing summaries and publication package-count
observations. Explicit tool installation/admission passed. No optional stage
sealer is selected and no product gate changed. Batch `batch-WcMBa4Gv` completed
both patch releases and reconciled cleanly in **170.1 seconds**. Fresh group
checks, final-version archives and registry readback passed (34 Metrics / 16
Logging files). Review of the pushed adoption and both increments found no
actionable issue. The [delivery record](../releases/independent-releases.md#tooling-0453-delivery--2026-11-18)
owns exact identities. Logs and timings are under `target/deploy/toko0453-20261118/`.
Hosted CI remains asynchronous; no completed hosted pass is claimed.
Two warm setup command passes took 14.85/15.00 seconds; Rust tool and editor
preparation/admission account for about 93%. Keep fresh checks; the
[profile](../releases/independent-releases.md#setup-command-profile--2026-11-18)
records inputs, method and the limits of possible reuse.
Observability #137's orphaned npm configuration cleanup is delivered and
[the issue](https://github.com/dragginzgame/ic-observability/issues/137) is closed;
the native-source fixture passed. Existing local node_modules artifacts are
preserved under `target/deploy/toko0453-20261118/preserved-typescript-node_modules/`.
Failed batch `batch-ahGwBRzT` remains intact: generic pending ledger headings
failed preflight before validation or metadata preparation. The corrected source
used a new batch; never resume the failed candidate as repaired.

The preceding Metrics 0.30.12 / Logging 0.25.11 delivery adopted
Toko Tooling **0.45.0** through the authenticated exporter. The supplied
AGENTS.md corrections are included. Product Rust/APIs and unrelated dependencies
remain unchanged. Adoption evidence is under
`target/qualification/toko-adoption-20261118/`.

Batch `batch-C6LML5zV` completed both groups and reconciled cleanly in **188.1
seconds**. Both three-stage release plans, final-version archives and independent
registry readback passed, matching 34 Metrics and 16 Logging maintained files.
The [delivery record](../releases/independent-releases.md#tooling-0450-delivery--2026-11-18)
owns exact identities and checksums. Focused review of the pushed adoption,
affected callers and each metadata increment found no actionable issue.

That completed candidate and
journal remain under `target/release-frozen/batch-C6LML5zV` and
`.git/release-state/frozen/batch-C6LML5zV/`. Delivery logs and timings are under
`target/deploy/toko0450-20261118/`. Hosted CI remains asynchronous; no completed
hosted pass is claimed. No sibling deployment or cleanup ran.

[Observability #136](https://github.com/dragginzgame/ic-observability/issues/136)
is closed. Its preceding reconstruction delivery, batch `batch-dZNTL4CS`, remains
intact with its [original record](../releases/independent-releases.md#live-delivery--2026-11-17).

CI covers both products on the three supported hosts. Releases use fresh
admission, strict lint and selected-package product checks; tooling qualification
is separate. The [guarantee map](../releases/independent-releases.md#release-stage-ownership-and-triggers)
owns commands and proof boundaries. The earlier matched fixture (281 → 167 seconds)
retains its separate simulated-registry/legacy-fixture-substitution scope under
`target/qualification/issue136-rebuild/`; it is not the live measurement above.

Stopped historical batch `batch-sSjwd230` remains untouched. It delivered only
Metrics 0.30.10 at `b9d488dec7eaf40c79f665880051b2d45c68ae1a`; its Logging
0.25.10 attempt was interrupted before delivery. Batch `batch-dZNTL4CS` independently
published Logging 0.25.10. Never resume or reinterpret the old attempt with new
semantics. Its original proof and publication record remain under that candidate
and `target/deploy/issue135-20261117/`.

Toko Tooling **0.45.8** and Rust **1.100.0** are selected locally. The exporter-owned
snapshot has 56 roots / 112 files after selecting the shared diagnostic helper
and previously retiring the unused stage runner and
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
