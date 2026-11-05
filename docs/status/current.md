# Current handoff — 2026-11-05

**Deployment of Metrics 0.29.2 and Logging 0.24.7 is authorized and in preparation.**
Shared Tooling 0.30.0 is selected at
`b37a882314d22bf7ab393b3fe561809377ffd22d`, pushed to upstream main and verified
through the canonical 150-file snapshot. Its source ledger remains Unreleased;
no Shared release-tag claim is made. The
[rule audit](../reports/audits/2026/11/05/shared-tooling-adoption/01/report.md)
records the complete applicable rule review, local fixes, focused evidence and
original missing-link finding; the
[remediation receipt](../evidence/shared-tooling-0300-remediation-20261105.md)
records the subsequent canonical repair and passing normal documentation gate.
[#355 — Complete exported documentation closure for LOC classification and audit guidance](https://github.com/dragginzgame/shared-tooling/issues/355)
is closed with actual exported-document regression evidence. No snapshot payload
was hand-patched and no check was suppressed.

The allocator-link fixture now lives under `tests/allocation-free/`, with its
historical Cargo/artifact identity and an explicit LOC test role. Generated private
consumer fixtures declare their test role and inherited compiler floor. Publication
passes the selected group through native/Wasm lint; full CI remains workspace-wide.
No Rust lint allowances were found. Focused Clippy, real allocator-free linking,
both retained consumers, publication failure/dispatch fixtures, group-plan custody,
tools/pins, formatting and packaged-document checks pass. Full CI, matched native
release qualification and hosted macOS acceptance were not run for this batch.
Pending notes select Metrics 0.29.2 / Logging 0.24.7; package versions remain
0.29.1 / 0.24.6 until the canonical release commands run. The maintainer separately
authorized the delivered Shared documentation fix; no other sibling is selected.

**Metrics 0.29.1 and Logging 0.24.6 are delivered to GitHub and verified on crates.io.**
The [delivery receipt](../evidence/observability-patches-20261104.md) owns exact
source/tag/archive identities, gate evidence and retained recovery locations.
Delivery used this normal `main` checkout, `origin/main` and one verified upload
per group, in Metrics-then-Logging order.
Metrics release: `9de6d2c656998f86b019771119f530c25e9b8618`, `metrics-v0.29.1`.
Logging release: `434314b0f8c3b7f70abe8388635d408309dada39`, `logging-v0.24.6`.
Both complete workspace plans passed all 21 stages, followed by archive compilation,
dry runs and non-yanked registry/archive/source readback of all 29 maintained
Metrics files and 13 maintained Logging files. No stage reuse/version projection ran.
Use `make verify-publication RELEASE_GROUP=metrics` or `RELEASE_GROUP=logging`
for reconciliation; never upload these versions again.

The delivered Shared Tooling 0.29.4 selection was
`628ccc75d813bfd9bae777bfbaef55838d25b1b2`, with 149 verified files.
The [adoption receipt](../evidence/shared-tooling-0294-20261104.md)
records its committed-main/Unreleased status, retained-state admission and five
local rule repairs. No supplier checkout was changed. The
[earlier cleanup receipt](../evidence/shared-tooling-0293-20261104.md) owns external
Rust test layout, companion-resolver and focused native-evidence scenario changes.
The patches preserve library APIs, feature isolation and retained-data contracts.
Those delivered group entries remain finalized; the new pending entries cover
only the current tooling/layout/publication changes.

The pre-existing lowercase Cargo catalog comments are restored and unstaged,
with current released versions preserved. Dedicated safety stash
`06ee2eaf4bf79bc230b27c702fbdd62d7acd9e44` and copies under
`target/deploy/observability-20261104/` remain retained. Earlier stashes and all
failed/original recovery evidence remain intact. No artifact cleanup ran.

Hosted CI runs asynchronously with ordinary supersession. Inspect the latest
retained full run for Linux, Intel macOS and ARM macOS acceptance; local release
evidence does not prove those remote outcomes. Pending/cancelled runs are not passes.

**#130 is closed for its delivered producer scope.**
At the maintainer's direction, remaining Profiler work is owned by
[#17 — Remove Metrics from Profiler subtotals and qualify native integration](https://github.com/dragginzgame/ic-profiler/issues/17).
Other consumer acceptance and endpoint decisions belong to their respective owners.
The [API inventory](../metrics-api.md) accounts for every retained public
member/trait, removed arithmetic/report API and owning consumer repair. Metrics
instruments the Canic application tree. Recorder Serde, general numeric helpers
and report queries were removed in 0.29.0; explicit `persistence` functions retain
canonical restoration for Storage. Fixed recording, overflow, reset and retention
semantics remain; all production feature/target graphs are dependency-free.
Canic's adapter owns report DTOs, Wire/TypeScript and the shared endpoint.
The [0.29 migration](../../releases/metrics/0.29.md) documents that breaking cut.
Publication does not establish sibling acceptance, installed adapters, real
retained-codec qualification or owner-local rounding/validation repairs.

The [0.29.0 receipt](../evidence/metrics-0290-delivery-20261103.md) retains the earlier
missed retained-client import, corrective source, fresh gate and failed plan.
Evidence under `target/issue-130/` and `target/deploy/metrics-0290-20261103/` retains
its original scope and identities. The
[Shared Tooling 0.28.2 delivery](../evidence/shared-tooling-0282-delivery-20261103.md)
owns Metrics 0.28.2 / Logging 0.24.5 readback and #129's three-host acceptance.
#129 and #128 remain closed; #130's closure records the explicit ownership split.
Logging remains a dependency-free heap engine; Persistence owns stable adapters
and their storage qualification.

Full CI and release selection share one declared stage roster through Shared's
interface. Full CI forces workspace scope. Shared owns baseline and fresh execution
admission; local policy owns product mapping, exclusions, source/index, compiler/
configuration, metadata and publication authority. Consumer receipt `group-validation:2`
binds Shared proof before preparation; late admission checks sealed byte custody
and original selection/configuration. Physical-root binding rejects relocation.
No stage reuse, version projection or old-receipt reinterpretation is enabled;
completed v1 receipts keep their adapter. Matched mapping/custody qualification
was renewed during the local rule repairs.

Current plans/proofs/logs: `target/release-validation/metrics-0.29.1.Ln6Eck/` and
`target/release-validation/logging-0.24.6.VvyMkQ/`; protected matching Git-side plans
are complete. Registry proof: `target/publication/verification.OKWZn4/` and
`target/publication/verification.vIQfAP/`. The shared retention guard preserves
evidence and refuses disallowed state; it authorizes no cleanup.
