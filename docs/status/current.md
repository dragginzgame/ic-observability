# Current handoff — 2026-11-19

## State and next action

Local work adopts Toko Tooling **0.45.16** and reviews the Rust and Cargo
configuration guards. The allocator-free Metrics fixture shares its recording
code across native and Wasm and selects each target's entry point and panic
handling. The native executable and Wasm link passed. Guard-removal probes and
feature-specific test logs are under `target/qualification/toko04516-cfg/`.

**Metrics 0.30.15 and Logging 0.25.14 are published and independently verified.**
Batch `batch-R73F5ykH` delivered Toko Tooling **0.45.15** to both groups and
reconciled the normal checkout. The authenticated snapshot retains 56 entrypoints
and 112 files. Rust **1.100.0** and the prepared tool catalog remain selected.
The [delivery record](../releases/independent-releases.md#tooling-04515-delivery--2026-11-19)
owns the exact identities and validation limits. Evidence is under
`target/deploy/toko04515-20261119/`. Hosted CI is asynchronous.
The [hygiene report](../reports/audits/2026/11/19/hygiene-adoption/02/report.md)
records the rules pass.

The [0.45.8 delivery record](../releases/independent-releases.md#tooling-0458-delivery--2026-11-18)
retains the Metrics 0.30.14 and Logging 0.25.13 identities.
[Observability #138](https://github.com/dragginzgame/ic-observability/issues/138)
and [Observability #139](https://github.com/dragginzgame/ic-observability/issues/139)
are closed. Their pre-repair findings remain in the
[0.45.8 audit](../reports/audits/2026/11/18/hygiene-adoption/01/report.md) and
repair verification is under `target/qualification/issues138-139-20261118/`.

The [receipt chain](../evidence/releases/README.md) and the
[prior handoff at dced966](https://github.com/dragginzgame/ic-observability/blob/dced96619bf812bf6bb29e6f7c10e9e18e4e8ad7/docs/status/current.md)
retain completed delivery history and evidence locations. The
[setup profile](../releases/independent-releases.md#setup-command-profile--2026-11-18)
owns the setup timing evidence and limits.

## Ownership and qualification limits

The [API inventory](../architecture/metrics-api.md),
[extraction contract](../architecture/extraction.md) and
[Logging boundary](../architecture/logging.md) own product and consumer contracts.
Production graphs are dependency-free. Consumer acceptance belongs to each
consumer. Review the current Storage contract before planning a governed adapter.

IC Build 0.83.0 and cargo-sort-derives 0.14.1 remain the qualified selections.
The [0.45.13 review](../reports/audits/2026/11/19/hygiene-adoption/01/report.md)
records the optional supplier refresh disposition. CI covers both packages on
three hosts. Fresh admission, strict lint and selected-package product checks
belong to the [release plan](../releases/independent-releases.md#release-stage-ownership-and-triggers).
Tooling qualification is separate. Stage and version-proof reuse remain disabled.

## Deferred work and recovery custody

Keep the original source, journals and partial proofs of stopped attempts.
`batch-ahGwBRzT` stopped before validation on generic pending ledger headings.
`batch-sSjwd230` delivered Metrics 0.30.10 before its Logging attempt stopped.
`batch-dZNTL4CS` separately delivered Logging 0.25.10. Do not resume either
stopped candidate as repaired. The prior handoff records the remaining stopped
batches, including `batch-ex9xCVty`, `batch-wmST1LGL`, `batch-9uizEjhh` and
`batch-C8a10ddy`.

Preserve stash `dca635bcc63ff73ec8553fdc43fcdfc442a0ad4f` and ref
`preserved/ci-prerequisites-toko04411-20261117`. Preserve the syn 3.0.10 stash
`0a33a698131d86db2e68898949aff87045a38a97` and ref
`preserved/syn-3.0.10-toko0442-20261115`. The current lock selects syn 3.0.10.
Never replay a whole prior lock across version changes.

Preserve completed candidates under `target/release-frozen/`, their durable
journals under `.git/release-state/frozen/`, and preceding stashes and
preservation refs. The [retention index](../evidence/README.md) and
[distribution record](../evidence/archive-distribution-072.md) own earlier
evidence and private-original custody.
