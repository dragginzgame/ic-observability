# Current handoff — 2026-11-06

**Metrics 0.29.6 and Logging 0.24.11 are delivered to GitHub and verified on crates.io.**
The [delivery receipt](../evidence/releases/observability-patches-20261106-shared0310.md)
owns exact tag/archive identities, validation and recovery locations. Implementation:
`66a3c75f1568acbfeba333390258057aedc01105`. Releases:

- Metrics: `79c3c7e9695ed9ce43f7a747c3786d36c301ff5c`, `metrics-v0.29.6`.
- Logging: `6ddccd2423451f5dd3ae9cb5a3cf96114d185aba`, `logging-v0.24.11`.

Both packages are non-yanked. Readback matched 29 maintained Metrics files and
13 maintained Logging files against their exact released source. Never upload
these versions again; `make verify-publication RELEASE_GROUP=metrics` or `logging`
is read-only reconciliation, not another upload.

Shared Tooling 0.31.0 selects `74313941af2fce4399bec0e6909ca6229673c3f8`, with all
157 snapshot files verified; its ledger remains Unreleased. Actual delivery used
`RELEASE_GROUPS=metrics,logging RELEASE_PUBLISH_TARGET=publish-verified` through
the schema-2 batch runner. Each group passed all 20 workspace stages, final
archive compilation and publication lint/verification. No stage reuse, version
projection or gate narrowing ran. Library implementation, external dependencies,
compiler and catalogs are unchanged; release metadata advanced only its group.

Batch `batch-z30yB8KG` is complete at index 2. Its managed checkout is
`target/release-frozen/batch-z30yB8KG`, with durable Git/recovery state at
`.git/release-state/frozen/batch-z30yB8KG/`. Standard group plans there are complete.
The normal `main` branch was explicitly fast-forwarded after batch completion.
Candidate outputs, source pin, proofs and journals remain retained; no retirement
or cleanup ran. Do not remove evidence while recovery is still required.
Normal transcripts are under `target/deploy/observability-0310-20261106/`.

The pre-existing lowercase root Cargo comments are restored and unstaged, with
published package versions intact. Dedicated stash
`a7dbbac568a37876f37f8a89607545a5fba389b2` preserves them. Earlier stashes, including
`e5bedde93b31a520a4ff282071099152cb04c555`, earlier release evidence, private
originals and tool stores remain untouched. Prior custody and release identities
remain in the [previous receipt](../evidence/releases/observability-patches-20261106-shared0307.md)
and Git history. No sibling checkout was mutated.

**Hosted CI has known failures; local release passes do not qualify every host.**
[Metrics CI 42263818593](https://github.com/dragginzgame/ic-observability/actions/runs/42263818593)
failed before application checks on both macOS hosts: Shared's checksum helper
reports an unmatched single quote under system Bash. The selected Shared main
still contains that defect. It needs repair at Shared Tooling and canonical
snapshot adoption; do not locally patch the exported payload or weaken integrity.
[Logging CI 42265412695](https://github.com/dragginzgame/ic-observability/actions/runs/42265412695)
uses the same tooling and is not a qualification pass.

Linux CI also exposed an inherited empty `RELEASE_GROUPS` in independent release
fixtures. The follow-up clears inherited batch configuration in both owning
fixtures. Standard Make dispatch and both groups' metadata/rollback/receipt/resume
checks passed with `RELEASE_GROUPS=`. This CI-only repair changes no published
crate content and requires no repeat upload. Pending notes are Metrics 0.29.7
and Logging 0.24.12; package versions remain 0.29.6 and 0.24.11.

The CI-only repair and delivery receipt need a follow-up `origin/main` push.
Automatic approval review rejected that push as separate from package deployment;
explicit user approval is required before retrying. The packages are already
published and verified; no second upload is needed.

Hosted checks continue asynchronously with normal supersession. Pending, failed
and cancelled jobs are not passes. The [tooling summary](../evidence/tooling.md)
owns focused qualification and its Linux/substitution boundaries. No current
native macOS, installed sibling or deployed IC acceptance is inferred.

The [evidence retention index](../evidence/README.md) owns compact summaries,
retired-raw availability and the unchanged source-distribution ledger. Protected
release receipts retain their original scope; no archive/private-original cleanup
or source export was authorized.

**#130 remains closed for its delivered producer scope.** Remaining Profiler work
belongs to [Profiler #17](https://github.com/dragginzgame/ic-profiler/issues/17).
The [API inventory](../metrics-api.md) and [0.29 migration](../../releases/metrics/0.29.md)
retain the instrumentation/persistence cut and consumer map. Canic owns reporting;
Storage owns retained codecs and governed stable adapters. Other consumer and
endpoint acceptance remains with those owners.
