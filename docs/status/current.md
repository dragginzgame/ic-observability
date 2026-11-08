# Current handoff — 2026-11-08

**Shared Tooling 0.31.10 is adopted locally at
`c5285791991c731d266fb5c85dc3ee876d29f6b9`.** The canonical exporter refreshed
the snapshot to 161 files, adding the pinned CI installer and download-cache
action. Upstream main matched this revision on review; its ledger remains
Unreleased. CI now restores authenticated downloads before host/scanner setup,
saves after setup, and runs one independent Linux full-history Gitleaks scan,
including documentation-only changes. LOC supports crate/module selectors.

Snapshot/pin checks, workflow lint, sourced ShellCheck, actual CI selection and
scan-failure propagation, native evidence success wiring, and LOC count/refusal
checks passed. Hosted caching and the live secret scan remain unverified locally.
The deploy request selects commit/push delivery of this refresh to `origin/main`
from the normal `main` checkout. The publication-impact comparison remains valid:
crate contents, package manifests, lockfile and dependencies are unchanged since
the prior adoption. Metrics stays at 0.29.6 and Logging at 0.24.11, without new
tags or registry uploads. Hosted CI runs asynchronously after delivery.

## Previous 0.31.9 adoption and delivery

The 0.31.9 adoption was delivered to `origin/main` as
`664f7584ea3c46bf2e09604e3c9b51b706eb0c69`. Its focused evidence follows.

Snapshot integrity, pins, formatting, hook preservation/failure checks, Cargo
boundaries, standard release Make adapters and package/module LOC reports passed.
The tooling summary records the focused evidence. Package versions, Cargo.lock,
compiler and tool pins remain unchanged. Pending notes stay in both group ledgers.
The subsequent deploy request selects commit/push delivery to `origin/main` from
the normal checkout. No public release is selected: both crate trees match their
published tags (`metrics-v0.29.6`, `logging-v0.24.11`), and locked/offline Cargo
package inventories include no changed maintenance files. Shared inherited
manifest settings and external dependencies are unchanged. The intervening
Logging version advance adds no dependency to Metrics; current root changes
relative to the latest release are comment casing only. Metrics remains 0.29.6
and Logging 0.24.11, with no new tags or uploads. This publication-impact decision
supersedes the historical patch-release plan below. The GitHub
description now reflects shipped instrumentation and bounded logging libraries.
Native macOS and full release qualification are not established by these checks.

## Prior delivery and recovery context — 2026-11-07

The following preserves prior delivery requests and custody; it is historical
context, not a fresh deployment selection for this adoption.

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

**The requested deployment selects Shared Tooling 0.31.1 at
`5efbda2ab81ad84e30f490f3137d8ef083c303d2`.** Its VERSION and pending ledger say
0.31.1 despite the commit title saying 0.31.2; no tagged-release claim is made.
The canonical exporter replaces only the checksum helper in the 157-file payload.
Its reader moves outside quoted command substitution for Bash 3.2 parsing;
NUL rejection and backend failure status remain. Package versions, lockfile,
compiler and catalogs are unchanged by adoption. The current deploy request
includes the prior CI repair in local commit `9043c2a`, source follow-up, patch
releases Metrics 0.29.7 then Logging 0.24.12, and verified registry publication.
The captured release gates and live publication for those versions are pending.
Snapshot integrity, pins, formatting, host/Rust/editor checks and both retained
registry archive checksums passed; a wrong checksum refused. Explicit setup
rebound unchanged tool pins after a host-native input change. Logs are under
`target/evidence/shared-tooling-0311/`. No broad consumer/native gate was run.

Actual delivery used Shared Tooling 0.31.0 at
`74313941af2fce4399bec0e6909ca6229673c3f8`, with
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

**Hosted CI failed on the prior snapshot; new native acceptance remains pending.**
[Metrics CI 42263818593](https://github.com/dragginzgame/ic-observability/actions/runs/42263818593)
failed before application checks on both macOS hosts: Shared's checksum helper
reports an unmatched single quote under system Bash. The upstream fix is now
selected by the local 0.31.1 snapshot above; its adoption does not turn historical
failed jobs into passes. The frozen delivery source and its receipts remain intact.
[Upstream CI 42274707843](https://github.com/dragginzgame/shared-tooling/actions/runs/42274707843)
passed macOS tool preparation but failed the portable release-editor setup
fixture; the complete upstream matrix is not a pass. Actual prepared editor
admission passes here. Fresh Observability native acceptance remains pending.
[Logging CI 42265412695](https://github.com/dragginzgame/ic-observability/actions/runs/42265412695)
uses the same tooling and is not a qualification pass.

Linux CI also exposed an inherited empty `RELEASE_GROUPS` in independent release
fixtures. The follow-up clears inherited batch configuration in both owning
fixtures. Standard Make dispatch and both groups' metadata/rollback/receipt/resume
checks passed with `RELEASE_GROUPS=`. This CI-only repair changes no published
crate content and requires no repeat upload. Pending notes are Metrics 0.29.7
and Logging 0.24.12; package versions remain 0.29.6 and 0.24.11.

The latest deploy request authorizes the pending source and CI-repair delivery.
The existing Cargo comment casing edits will be included unchanged so the normal
checkout can finish clean. Published 0.29.6/0.24.11 identities remain immutable;
this deployment selects fresh versions rather than repeating those uploads.

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
