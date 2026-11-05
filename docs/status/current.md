# Current handoff — 2026-11-05

**Shared Tooling 0.30.4 is adopted locally; this batch is uncommitted.**
Revision `2aa41c7394300302fe802b69b31b855bdc89b671` matches upstream main when
reviewed and verifies all 152 selected files. Its source ledger remains Unreleased;
this is not a tagged-release claim. The [tooling summary](../evidence/tooling.md)
records current decisions and the retained conclusions from earlier adoptions.
Catalogs, package versions, Cargo.lock and compiler selections stay unchanged;
no library Rust changed, so no new build/native or full CI matrix ran.
Pending notes select Metrics 0.29.3 and Logging 0.24.8; current package versions
remain 0.29.2 and 0.24.7. No commit, release, publication or sibling edit ran.
The pre-existing Cargo comment casing remains intact. Final-candidate stage reuse
and publication caching remain disabled; the existing qualified receipt contract stays.

**The authorized evidence cleanup is complete.** The current tree has 77 evidence
files, about 267 KiB of logical content, down from 342 files and about 43 MiB.
Six compact topic summaries replace superseded diaries and raw attachments.
All 67 historical release/delivery receipts are under `docs/evidence/releases/`;
their prose and identities are preserved apart from repaired link destinations
and explicit retention notices. The distribution custody ledger is byte-identical.
The [retention index](../evidence/README.md) explains that removed raw artifacts
are no longer independently verifiable from the current tree. No new archive,
private-original cleanup, target cleanup, recovery mutation or history rewrite ran.

The obsolete raw-archive checksum stage is retired with its inputs; new release
plans have 20 stages. Tool-download integrity and recovery checks remain.
The production-dependency gate now owns the shared lexical Candid check with zero
allowances: workspace, Metrics and Logging select 34, 24 and 10 Rust files.
Actual Make callers passed; a forbidden trait in a retained Metrics fixture was
rejected for workspace/Metrics scope while Logging remained independent.
Snapshot, pin, formatting, documentation-link, receipt-preservation and validation
roster checks passed. These focused checks do not establish a new hosted/native
matrix or release qualification.

**Metrics 0.29.2 and Logging 0.24.7 are delivered to GitHub and verified on crates.io.**
The [delivery receipt](../evidence/releases/observability-patches-20261105.md) owns exact
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

The delivered patches selected Shared Tooling 0.30.0 at
`b37a882314d22bf7ab393b3fe561809377ffd22d`, with 150 verified files. Its source
ledger remains Unreleased; no Shared release-tag claim is made. The
[original rule audit](../reports/audits/2026/11/05/shared-tooling-adoption/01/report.md)
retains its initial missing-document failure. The separately authorized
[tooling summary](../evidence/tooling.md) retains the producer fix and its
canonical-export, missing-target and normal-consumer documentation results.
[#355 — Complete exported documentation closure for LOC classification and audit guidance](https://github.com/dragginzgame/shared-tooling/issues/355)
is fixed, pushed and closed. No snapshot file was hand-patched and no check suppressed.
No other sibling checkout was edited by this deployment.

The allocator-link fixture lives under `tests/allocation-free/`, with an explicit
LOC test role and its unchanged historical Cargo/artifact identity. Retained private
consumer fixtures declare their test role and inherited compiler floor. Publication
carries explicit group scope to native/Wasm lint; full CI remains workspace-wide.
No Rust lint allowances were found. Library APIs and retained-data contracts stay
unchanged. Earlier adoption diaries are compacted into the tooling summary;
the [previous patch delivery](../evidence/releases/observability-patches-20261104.md)
retains its original identities and historical qualification.

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
