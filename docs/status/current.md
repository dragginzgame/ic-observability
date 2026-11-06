# Current handoff — 2026-11-06

**Shared Tooling 0.30.6 is adopted locally; this batch is uncommitted.** The
155-file snapshot selects `45c0295e23d3d23225e31f47c018c30ff0c75581`, matching
upstream main when reviewed. Its source ledger remains Unreleased; the sibling's
uncommitted 0.30.7 work was left untouched. The [tooling summary](../evidence/tooling.md)
owns current decisions and focused evidence. Actual Cargo/source Make callers,
CBOR import and renamed-dev-dependency refusals, group source isolation and both
independently generated retained-consumer contracts passed. Snapshot, pins and
formatting passed; docs/diff admission covers the finished batch. No production
codec migration or browser root was found. Library versions, dependency locks,
compiler/tools and the unrelated root Cargo comments are unchanged. No commit,
release, publication or broad native/CI matrix ran for this adoption.

**Metrics 0.29.3 and Logging 0.24.8 are delivered to GitHub and verified on crates.io.**
The [delivery receipt](../evidence/releases/observability-patches-20261105-tooling.md)
owns exact source/tag/archive identities and recovery locations. Delivery used
this normal `main` checkout and `origin/main`, then one verified upload per group
in Metrics-then-Logging order. Both versions are non-yanked; readback matched
29 maintained Metrics files and 13 maintained Logging files to their release commits.
Never upload these versions again. Use `make verify-publication RELEASE_GROUP=metrics`
or `RELEASE_GROUP=logging` for read-only reconciliation.

Implementation: `45c1566a8b92782246390bc9c5c3a782a64ddacf`.
Metrics release: `61e1e743863fea892cb868c6a3e481de892a8330`, `metrics-v0.29.3`.
Logging release: `b07e0540ea31375a794ea9025f7588292b8136eb`, `logging-v0.24.8`.
Both workspace plans passed all 20 stages, followed by final archive compilation,
publication dry runs, upload and independent registry/archive/source readback.
No stage reuse, version projection or gate narrowing ran. The full/selected mapping
qualification was separately renewed and passed. Local release evidence does not
establish hosted or installed downstream acceptance.

**The macOS setup-smoke failure is repaired in the repository.** The Metrics
[hosted run](https://github.com/dragginzgame/ic-observability/actions/runs/42064849516)
passed Linux but failed both macOS jobs before tools were installed: GNU Make 3.81
rejected the existing combined target-specific `override export` declaration.
Export and override are now separate. Smoke asserts both publication mode and
validation scope against hostile command-line values, stopping before real effects.
A locally built GNU Make 3.81 reproduced the error and passed the repaired caller;
prepared-Make smoke and publication ordering also passed. This Linux parser proof
is not macOS native acceptance; hosted qualification of the repair is asynchronous.
The Make/CI follow-up changes neither published payload. Future notes are pending
under Metrics 0.29.4 and Logging 0.24.9; package versions remain 0.29.3 and 0.24.8.

The published batch selected Shared Tooling 0.30.4 at
`2aa41c7394300302fe802b69b31b855bdc89b671`, with all 152 selected files verified.
Its source ledger remains Unreleased; no Shared release tag is inferred.
The current Candid/CBOR lexical guard uses zero allowances through the
production-dependency gate; workspace/Metrics/Logging select 34/24/10 Rust files.
The same gate admits Shared's Cargo declarations once, and generated retained
clients separately check their own resolved workspaces and Rust roots. Macro
expansion, dynamic code and type resolution remain separate review obligations.

**The authorized evidence cleanup reduced 342 files/about 43 MiB to 77 files
under 0.5 MiB before this delivery receipt.** Six compact topic summaries replace
superseded diaries and raw attachments. All 67 earlier release/delivery receipts
are under `docs/evidence/releases/`; their prose and identities are preserved apart
from repaired links and retention notices. The distribution JSON ledger is byte-identical.
The [retention index](../evidence/README.md) explains removed raw availability.
The obsolete archive-checksum stage is retired; tool-download, product and recovery
checks remain. No new bulk archive, private-original cleanup, target cleanup,
history rewrite or sibling mutation ran. Earlier release receipts retain their
original 21-stage results, not the new roster.

Protected Git-side release plans for both versions are complete. Sealed plans,
proofs and logs are at `target/release-validation/metrics-0.29.3.rC7ZFF/` and
`target/release-validation/logging-0.24.8.JBcZDF/`. Registry readbacks are
`target/publication/verification.ApHXEP/` and `verification.b46hlB/`.
Transcripts and the mapping/parser checks are under
`target/deploy/observability-tooling-20261105/`. Retention admission preserves
active recovery state and authorizes no cleanup. Cross-group stage/publication
caching remains disabled; the `group-validation:2` proof contract stays in force.

The pre-existing lowercase root Cargo comments are restored and unstaged, with
both new versions retained. Dedicated stash
`31c35843bcbd2ef89e2aa4ccc701509a4951755e` and the original diff under
`target/evidence/docs-cleanup-20261105/` remain. Earlier stashes, including
`a8d87d1f41fa48a784c56ccef7302b9ed0dd12ef` and
`06ee2eaf4bf79bc230b27c702fbdd62d7acd9e44`, and all earlier recovery evidence
remain intact. The [previous delivery](../evidence/releases/observability-patches-20261105.md)
retains its exact identities and Shared #355 remediation history.

**#130 is closed for its delivered producer scope.** Remaining Profiler work is
owned by [#17 — Remove Metrics from Profiler subtotals and qualify native integration](https://github.com/dragginzgame/ic-profiler/issues/17).
The [API inventory](../metrics-api.md) and [0.29 migration](../../releases/metrics/0.29.md)
retain the instrumentation/persistence cut and consumer map. Canic owns reporting;
Storage owns retained codecs and governed stable adapters. Other consumer and
endpoint acceptance remains with those owners. No new sibling qualification is claimed.
