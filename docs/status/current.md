# Current handoff — 2026-11-10

## Local tooling adoption

Published toko-tooling **0.39.7** is installed locally through its authenticated
exporter. The exact root Cargo pin, inherited member dev-dependencies, lock and
snapshot agree on archive SHA-256
`fd795f6ef878496ac27a990a9208b87fa786a9148c18580338ef8ac79df501d7`.
The receipt selects 54 roots and 109 files. The preceding 0.39.5 refresh retired
71 unchanged files outside the retained baseline, executable and runtime selection. Shared
reference docs, rules, audits and task guides stay upstream; consumer links pin
the reviewed release commit. Product documentation and canonical root files stay
local. The [documentation index](../README.md) links the current contracts and
shared references. The previous managed-doc namespace plan is superseded.

The consumer explicitly sets `TOKO_TOOLING_RELEASE := 1` before its common Make
include. `validation-evidence.pl` remains explicitly selected because local release
validation calls it. Release requirements remain unchanged, including all 20
workspace stages. The 0.39.7 refresh changes the baseline and the Make/batch diagnostics for
retired release settings. Other executable payloads retain their earlier focused
evidence; the current delivery will run both complete release plans.
Fresh adoption checks and records are under `target/evidence/toko-tooling-0397/`;
the [tooling summary](../evidence/tooling.md) records their scope. Delivery is selected for Metrics 0.29.11 and Logging 0.24.16, with verified
publication through the frozen batch workflow. Their release notes are pending
until the standard release runner finalises each group.

Native documentation is organised under architecture, development, releases,
governance and migrations. The documentation index, caller links and CI's exact
prose path list follow those paths. Shared reference docs stay upstream. The
tooling evidence summary is compacted; protected receipts, distribution records,
historical handoffs and audit artifacts retain their original scope and custody.

The [source inventory](../governance/source-origins.md) records current component origins.
Incoming AGENTS.md edits, including the IC Storage adapter ownership changes,
remain preserved with shared reference links retargeted upstream. Only
toko-tooling changed in the incoming dependency selection; the deferred syn
3.0.10 edit remains separate.

## Published products

Metrics **0.29.10** and Logging **0.24.15** are delivered and independently
verified on crates.io. Never re-upload those versions. The
[delivery receipt](../evidence/releases/toko0382-placement-20261109.md) owns exact
commits, annotated tags, archive hashes, complete plans and registry readback.
Both passed all 20 workspace stages without narrowing or stage reuse, followed
by final archive compilation and matching maintained source (34 Metrics and
16 Logging files). Hosted/native macOS and installed consumer acceptance remain
separate and asynchronous; pending or cancelled checks are not passes.

The product crates remain independent, under `crates/`, in one virtual root
workspace excluding `qualification`. That tree contains historical README files,
not maintained packages. No qualification workspace or qualification release selection is needed.
Package-local tests and examples remain with their products. Current product
APIs, features and all existing release obligations remain unchanged.

Metrics 0.29.9 introduced `BoundedCounterTable::add_omitted(u128)` and
`LexicalMeasurementTable::record_omitted(u64)`, preserving canonical arithmetic
without constructing/comparing a key, allocation or retained-state changes.
[#133](https://github.com/dragginzgame/ic-observability/issues/133) records producer
completion/publication. Original typed tables and Logging `BoundedHistory<T>`
are recorded in the earlier delivery receipts. Canic
[#755](https://github.com/dragginzgame/canic/issues/755) and
[#756](https://github.com/dragginzgame/canic/issues/756) retain adoption and real
endpoint/report/installed acceptance. No sibling deployment is implied.

## Deferred work and recovery custody

The syn 3.0.10 Cargo.lock edit is restored and excluded from the published
syn 3.0.9 graph. Its original stash is
`de3f936fd3e93d094ddf5ff5d7129a8104119f0c`, pinned by branch
`preserved/syn-3.0.10-typed-recording-20261109`. Do not discard or mistake it for
the released selection.

Batch `batch-Dvpzy0I1` is complete at index 2. Execution remains under
`target/release-frozen/batch-Dvpzy0I1`, with durable recovery under
`.git/release-state/frozen/batch-Dvpzy0I1/`. Reconciliation completed and the
syn edit was reapplied. No retirement or protected cleanup ran.

Earlier completed batches `batch-9DUaDslR`, `batch-vgM1oJ1f`, `batch-gfJA5IMg`
and `batch-z30yB8KG` retain their candidates/recovery. Failed pre-delivery batch
`batch-C8a10ddy` must not be resumed as repaired source. The delivery-receipt
chain and [retention index](../evidence/README.md) own their identities and
private-source custody. Earlier stashes `a7dbbac568a37876f37f8a89607545a5fba389b2`
and `e5bedde93b31a520a4ff282071099152cb04c555` remain untouched.

The [API inventory](../architecture/metrics-api.md) and [Metrics migration](../../releases/metrics/0.29.md)
retain downstream contract ownership. Producer #130 remains closed; Profiler
[#17](https://github.com/dragginzgame/ic-profiler/issues/17) and each consumer
retain their own outstanding acceptance. No IC cost measurement is implied.
