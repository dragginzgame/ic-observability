# Current handoff — 2026-11-05

**Metrics 0.29.2 and Logging 0.24.7 are delivered to GitHub and verified on crates.io.**
The [delivery receipt](../evidence/observability-patches-20261105.md) owns exact
source/tag/archive identities, validation and recovery locations. Delivery used
this normal `main` checkout, `origin/main`, then one verified upload per group
in Metrics-then-Logging order.
Metrics release: `3af657f0e968b8f405704633c581aa0869dee1c4`, `metrics-v0.29.2`.
Logging release: `f82bd69539387e8d7d8c0ec697b0e2e36d6c7e29`, `logging-v0.24.7`.
Each complete workspace plan passed all 21 stages, followed by final archive
compilation, publication dry run, upload and non-yanked registry/source/content
readback of all 29 maintained Metrics files and 13 maintained Logging files.
No stage reuse, gate narrowing or version projection ran. Both group ledgers
are finalized; delivery evidence alone needs no new pending release.
Use `make verify-publication RELEASE_GROUP=metrics` or `RELEASE_GROUP=logging`
for reconciliation; never upload these versions again.

Shared Tooling 0.30.0 is selected at
`b37a882314d22bf7ab393b3fe561809377ffd22d`, with 150 verified files. Its source
ledger remains Unreleased; no Shared release-tag claim is made. The
[original rule audit](../reports/audits/2026/11/05/shared-tooling-adoption/01/report.md)
retains its initial missing-document failure. The separately authorized
[remediation receipt](../evidence/shared-tooling-0300-remediation-20261105.md)
records the producer fix, canonical export, missing-target regression and passing
normal consumer documentation check.
[#355 — Complete exported documentation closure for LOC classification and audit guidance](https://github.com/dragginzgame/shared-tooling/issues/355)
is fixed, pushed and closed. No snapshot file was hand-patched and no check suppressed.
No other sibling checkout was edited by this deployment.

The allocator-link fixture lives under `tests/allocation-free/`, with an explicit
LOC test role and its unchanged historical Cargo/artifact identity. Retained private
consumer fixtures declare their test role and inherited compiler floor. Publication
carries explicit group scope to native/Wasm lint; full CI remains workspace-wide.
No Rust lint allowances were found. Library APIs and retained-data contracts stay
unchanged. Earlier [0.29.4 adoption](../evidence/shared-tooling-0294-20261104.md),
[0.29.3 cleanup](../evidence/shared-tooling-0293-20261104.md) and
[previous patch delivery](../evidence/observability-patches-20261104.md) retain their
original identities and qualification.

The pre-existing lowercase Cargo catalog comments are restored and unstaged,
with the new versions retained. Dedicated stash
`a8d87d1f41fa48a784c56ccef7302b9ed0dd12ef` and copies under
`target/deploy/observability-20261105/` remain. Earlier stashes, including
`06ee2eaf4bf79bc230b27c702fbdd62d7acd9e44`, and all original recovery evidence
remain intact. No artifact or tool-store cleanup ran.

Hosted CI continues asynchronously with ordinary supersession. Inspect the latest
retained full run for Linux, Intel macOS and ARM macOS acceptance; local release
evidence does not establish those remote outcomes. Pending/cancelled runs are not passes.

**#130 is closed for its delivered producer scope.** Remaining Profiler work is
owned by [#17 — Remove Metrics from Profiler subtotals and qualify native integration](https://github.com/dragginzgame/ic-profiler/issues/17).
Other consumer acceptance and endpoint decisions remain with their owners. The
[API inventory](../metrics-api.md) and [0.29 migration](../../releases/metrics/0.29.md)
retain the instrumentation/persistence cut and consumer map. Canic's adapter owns
report DTOs and the shared endpoint; Storage owns retained codecs and governed
stable adapters. Publication alone does not qualify siblings or installed adapters.

Full CI and release selection share one declared roster. Full CI forces workspace
scope. Shared owns baseline and fresh execution admission; local policy owns
mapping, source/index/compiler/configuration, metadata and publication authority.
Receipt `group-validation:2` binds Shared proof before preparation; late admission
checks sealed byte custody and original scope. Physical-root binding rejects
relocation. No stage reuse or version projection is enabled; completed v1 receipts
retain their adapter. Current plans/proofs/logs are
`target/release-validation/metrics-0.29.2.jtrVRS/` and
`target/release-validation/logging-0.24.7.nPU7Sl/`; protected Git-side plans are complete.
Registry proofs: `target/publication/verification.8GnHLE/` and
`target/publication/verification.97gYtZ/`. Retention admission preserves evidence
and refuses disallowed state; it authorizes no cleanup.
