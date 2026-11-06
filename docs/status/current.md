# Current handoff — 2026-11-06

**Metrics 0.29.5 and Logging 0.24.10 are delivered to GitHub and verified on crates.io.**
The [delivery receipt](../evidence/releases/observability-patches-20261106-shared0307.md)
owns exact source/tag/archive identities and recovery locations. Delivery used
this normal `main` checkout and `origin/main`, then one verified upload per group
in Metrics-then-Logging order. Both versions are non-yanked; readback matched
29 maintained Metrics files and 13 maintained Logging files to their release commits.
Never upload these versions again. Use `make verify-publication RELEASE_GROUP=metrics`
or `RELEASE_GROUP=logging` for read-only reconciliation.

Implementation: `f0725c6be95c3b9eaf746fd1acb1d3cbb86e67e6`.
Metrics release: `bd822af0d074c3cda28d709aa71b7f6c6b72e72e`, `metrics-v0.29.5`.
Logging release: `b6457ab30b85ea8dd16e712de9b7e1f6b2f31500`, `logging-v0.24.10`.
Both plans selected workspace scope because shared inputs changed and passed all
20 stages, followed by final archive compilation, publication dry runs, upload
and independent registry/archive/source readback. No stage reuse, version
projection or gate narrowing ran. Full/selected mapping qualification was renewed
and passed. Both owning ledgers are finalized; delivery records alone require no
new pending release. No library implementation, feature, external dependency
selection, compiler or tool catalog changed. Cargo package-cache lock waits
occurred; no speed-up is claimed.

**Shared Tooling 0.30.7 is selected at the reviewed committed revision**
`22a853e26c05ec323f06c57fa316c08b808f252b`, with all 157 selected files verified.
Its source ledger remains Unreleased; no Shared tag is inferred. The
[tooling summary](../evidence/tooling.md) owns decisions and focused evidence.
Actual Make smoke and direct dispatch/status probes passed with prepared Make
and locally built GNU Make 3.81, with runner effects substituted. Normal direct
release uses the existing runner. Nonempty `RELEASE_FROZEN_GROUPS` refuses before
either runner: independent-checkout hooks remain unqualified and no managed
delivery checkout was created. The `group-validation:2` proof contract stays in
force; cross-group stage/publication caching remains disabled.

The encoding guards are unchanged: zero-allowance Candid/CBOR scanning covers
workspace/Metrics/Logging inventories of 34/24/10 Rust files. Shared Cargo
admission checks direct external-IC and CBOR declarations, including renamed dev
packages, through the existing production-dependency gate. Generated retained
clients separately check declarations and source roots before public contract tests.
Macro expansion, dynamic code and type resolution remain separate review obligations.
Serde remains development-only for trait-refusal doctests; both production graphs
are dependency-free. No browser root or production codec migration was introduced.

Hosted Linux/Intel macOS/ARM macOS CI continues asynchronously with ordinary
supersession; inspect the retained full run. Pending/cancelled runs are not passes.
The previous main revision `016f615761ba351d0a2e1846398d665bba9cfb1b` has successful
[CI run 42216362684](https://github.com/dragginzgame/ic-observability/actions/runs/42216362684),
which does not qualify the new snapshot. Local release and registry evidence
also does not qualify installed siblings or deployed IC runtime.

Protected Git-side plans for both versions are complete. Sealed plans, proofs
and logs are `target/release-validation/metrics-0.29.5.QPNutC/` and
`target/release-validation/logging-0.24.10.jDFZTY/`. Registry readbacks are
`target/publication/verification.ds1mF6/` and `verification.FLy36O/`.
Transcripts and mapping qualification are under
`target/deploy/observability-0307-20261106/`. Retention admission preserves active
recovery state and authorizes no cleanup.

The pre-existing lowercase root Cargo comments are restored and unstaged, with
both new versions retained. Dedicated stash
`e5bedde93b31a520a4ff282071099152cb04c555` and the original diff in the deployment
directory remain. Earlier stashes, including
`bf5bb360125866c3b6a3e2c3337ce08842e1f458`,
`31c35843bcbd2ef89e2aa4ccc701509a4951755e`,
`a8d87d1f41fa48a784c56ccef7302b9ed0dd12ef` and
`06ee2eaf4bf79bc230b27c702fbdd62d7acd9e44`, and all earlier recovery evidence
remain intact. No private-original, target, artifact/store or sibling cleanup ran.

The [evidence retention index](../evidence/README.md) owns compact topic summaries
and removed-raw-availability notices. Earlier release receipts and the unchanged
source-distribution JSON ledger remain preserved; old stage results and hashes
retain their original scope, not current raw availability. The
[previous delivery](../evidence/releases/observability-patches-20261106.md)
retains its exact identities and 0.30.6 adoption evidence.

**#130 is closed for its delivered producer scope.** Remaining Profiler work is
owned by [#17 — Remove Metrics from Profiler subtotals and qualify native integration](https://github.com/dragginzgame/ic-profiler/issues/17).
The [API inventory](../metrics-api.md) and [0.29 migration](../../releases/metrics/0.29.md)
retain the instrumentation/persistence cut and consumer map. Canic owns reporting;
Storage owns retained codecs and governed stable adapters. Other consumer and
endpoint acceptance remains with those owners. No new sibling qualification is claimed.
