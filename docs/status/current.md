# Current handoff — 2026-11-06

**Metrics 0.29.4 and Logging 0.24.9 are delivered to GitHub and verified on crates.io.**
The [delivery receipt](../evidence/releases/observability-patches-20261106.md)
owns exact source/tag/archive identities and recovery locations. Delivery used
this normal `main` checkout and `origin/main`, then one verified upload per group
in Metrics-then-Logging order. Both versions are non-yanked; readback matched
29 maintained Metrics files and 13 maintained Logging files to their release commits.
Never upload these versions again. Use `make verify-publication RELEASE_GROUP=metrics`
or `RELEASE_GROUP=logging` for read-only reconciliation.

Implementation: `ed825cb256a737b2a896e364b87bd926bde414f9`.
Metrics release: `c29b292a5a3da67dc0aa2c34ef1ea3e79af83a5c`, `metrics-v0.29.4`.
Logging release: `e3bf868b6d941f5944606480e39a2da35b824d37`, `logging-v0.24.9`.
Both workspace plans passed all 20 stages, followed by final archive compilation,
publication dry runs, upload and independent registry/archive/source readback.
No stage reuse, version projection or gate narrowing ran. The full/selected mapping
qualification was separately renewed and passed. Both owning ledgers are finalized;
delivery records alone require no new pending release. No library implementation,
feature, external dependency selection, compiler or tool catalog changed.

**Shared Tooling 0.30.6 is selected at the reviewed committed revision**
`45c0295e23d3d23225e31f47c018c30ff0c75581`, with all 155 selected files verified.
Its source ledger remains Unreleased; no Shared tag is inferred. The sibling's
uncommitted 0.30.7 work was left untouched. The [tooling summary](../evidence/tooling.md)
owns decisions and focused results. Zero-allowance Candid/CBOR scanning covers
workspace/Metrics/Logging inventories of 34/24/10 Rust files. Shared Cargo
admission checks direct external-IC and CBOR declarations, including renamed dev
packages, once through the existing production-dependency gate. Independently
generated retained clients check their resolved declarations and source roots
before public contract tests; both pass (25 Metrics and 11 Logging Rust files).
Actual Make caller refusals and group source isolation passed. Macro expansion,
dynamic code and type resolution remain separate review obligations. No browser
root or production codec migration was found. Serde remains development-only for
recorder trait-refusal doctests; both libraries' production graphs are dependency-free.

**The previous macOS Make repair has successful hosted CI.**
[Run 42066741583](https://github.com/dragginzgame/ic-observability/actions/runs/42066741583)
passed at `96de8655cbe5cf545176a867e414ed1c9aecfe18`. Export and target-specific
publication override remain separate; smoke asserts mode and group scope before
effects. This older result does not qualify the new snapshot. Current hosted
Linux/Intel macOS/ARM macOS CI continues asynchronously with ordinary supersession;
inspect the retained full run. Pending/cancelled runs are not passes. Local release
and registry evidence does not qualify sibling installations or deployed IC runtime.

Protected Git-side plans for both versions are complete. Sealed plans, proofs
and logs are `target/release-validation/metrics-0.29.4.O3FJy5/` and
`target/release-validation/logging-0.24.9.Uq2bYK/`. Registry readbacks are
`target/publication/verification.ZdjwlE/` and `verification.icTN8j/`.
Transcripts and mapping qualification are under
`target/deploy/observability-0306-20261106/`. Retention admission preserves active
recovery state and authorizes no cleanup. Cross-group stage/publication caching
remains disabled; the `group-validation:2` proof contract stays in force.

The pre-existing lowercase root Cargo comments are restored and unstaged, with
both new versions retained. Dedicated stash
`bf5bb360125866c3b6a3e2c3337ce08842e1f458` and the original diff in the deployment
directory remain. Earlier stashes, including
`31c35843bcbd2ef89e2aa4ccc701509a4951755e`,
`a8d87d1f41fa48a784c56ccef7302b9ed0dd12ef` and
`06ee2eaf4bf79bc230b27c702fbdd62d7acd9e44`, and all earlier recovery evidence
remain intact. No private-original, target, artifact/store or sibling cleanup ran.

The [evidence retention index](../evidence/README.md) owns compact topic summaries
and removed-raw-availability notices. All earlier release receipts and the unchanged
source-distribution JSON ledger remain preserved. Their old identities and 21-stage
results retain their original scope; hashes do not establish current raw availability.
The [previous delivery](../evidence/releases/observability-patches-20261105-tooling.md)
retains its source identities and Make failure/repair history.

**#130 is closed for its delivered producer scope.** Remaining Profiler work is
owned by [#17 — Remove Metrics from Profiler subtotals and qualify native integration](https://github.com/dragginzgame/ic-profiler/issues/17).
The [API inventory](../metrics-api.md) and [0.29 migration](../../releases/metrics/0.29.md)
retain the instrumentation/persistence cut and consumer map. Canic owns reporting;
Storage owns retained codecs and governed stable adapters. Other consumer and
endpoint acceptance remains with those owners. No new sibling qualification is claimed.
