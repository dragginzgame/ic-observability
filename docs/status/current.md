# Current handoff — 2026-11-17

## State and next action

[Observability #135 — Simplify release gates](https://github.com/dragginzgame/ic-observability/issues/135)
is implemented locally, pending delivery. Package-only plans now omit five
unchanged tooling regression stages (Metrics 14, Logging 13); shared/uncertain
changes and full CI retain all 20. Fresh source, archive and publication admission
remain unchanged. The [stage/fixture mapping](../releases/independent-releases.md#release-stage-ownership-and-triggers)
owns commands, proof boundaries and measured substitute dispatch counts/timings.
Pending compatible notes are Metrics 0.30.10 and Logging 0.25.10; manifests and
lock identities remain at delivered versions. Cross-group reuse remains disabled
and separately tracked in [Observability #136](https://github.com/dragginzgame/ic-observability/issues/136).
Its revised contract is investigated: the 0.44.11 stage runner is exported locally
(57 roots / 113 files), but no release stage uses it. A synthetic executed/reused
probe exposed missing non-Cargo receipt sealing;
[Toko Tooling #389](https://github.com/dragginzgame/toko-tooling/issues/389) owns that
shared interface. Observability #136 remains open, with integration and sequential
batch/recovery qualification pending. See the [reuse preparation](../releases/independent-releases.md#stage-reuse-preparation--observability-136).

Metrics **0.30.9** and Logging **0.25.9** are delivered to GitHub and independently
verified on crates.io; never re-upload them. The
[delivery receipt](../evidence/releases/toko04411-delivery-20261117.md) owns exact
commits/tags/archive identities, both complete 20-stage workspace plans and
registry/source readback. Successful batch `batch-n9adqUv3` used source
`5eb1724462892e1fb8968f192e18438e228da8eb`, with no stage reuse. Stage totals
were 517 and 500 seconds; its instrumented interval was 1,146.6 seconds.

Toko Tooling **0.44.11** is committed in root Cargo, Cargo.lock and the snapshot:
56 entrypoints and 112 files. Shared's preparation helper is called directly;
the unused action/cache-key companion and exact-pin exception retired. Product
Rust/APIs, compiler/lints, production graphs and package identities are unchanged.
Syn 3.0.10 remains the checkpoint-selected version. The
[tooling evidence](../evidence/tooling.md) owns focused scope and record paths.

Hosted Metrics CI exposed native-prerequisite shell quoting after publication;
its security scan passed. The CI-only correction and 58-test workflow-body
coverage were pushed in `19d0f200911a3a2a21fa664aacff1bf3d6c467cc`, without
changing package inputs or uploading a version again. The
[corrected run](https://github.com/dragginzgame/ic-observability/actions/runs/44065264444)
was observed in progress; no successful hosted native qualification is claimed.
One real Linux setup-failure diagnostic artifact was downloaded and verified:
eight hidden records, 873 bytes, matching checksum and original status 2.
Hosted native and downstream acceptance remain separate and asynchronous.

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
reinterpret those releases merely to refresh this handoff. Historical plans retain their original obligations. New plans use the qualified
selector above; stage/version-proof reuse remains disabled.

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
