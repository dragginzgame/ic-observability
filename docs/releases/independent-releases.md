# Independent Metrics and Logging releases

The two libraries remain in one development workspace and share the catalog,
lockfile, compiler policy and repository-wide CI. They have no dependency
on one another. [The declared policy](../../ci/cargo-release-groups.json) owns membership;
`make deps-list` displays every package version and release group:

| Group | Members | Version owner | Canonical ledger |
| --- | --- | --- | --- |
| metrics | ic-metrics | crates/ic-metrics/Cargo.toml package.version | [Metrics changelog](../../releases/metrics/CHANGELOG.md) |
| logging | ic-logging | crates/ic-logging/Cargo.toml package.version | [Logging changelog](../../releases/logging/CHANGELOG.md) |

The root is the only maintained Cargo workspace. Both product packages already
use the standard `crates/<package-name>/` locations; their ordinary tests and
examples remain with them. The root explicitly excludes `qualification`.
That tree contains two historical README files and no maintained packages,
manifest or lock, so no qualification workspace or package move is needed.
Generated release-test workspaces beneath `target/` are disposable fixtures,
not maintained qualification packages. Cargo metadata supplies actual members;
the release policy maps those product identities to their independent groups.
Any future separate qualification package must use the independent workspace
under the [placement rule](https://github.com/dragginzgame/toko-tooling/blob/12459b6029115b830b8477879d3bea2f030b6e63/rules/rust-workspaces.md#standard-layout), without
adding it to either product group or removing required validation.

The groups were separated at the existing 0.23.0 numeric version. Logging first
converted to a literal version; Metrics followed at its released 0.23.1 version.
Neither conversion changes a package's numeric identity.
Earlier coordinated releases remain once in [shared history](../../releases/history.md), through 0.23.0;
both group ledgers link to that history. Existing tags and receipts are retained.
Tooling has no selection-only package or release-group membership. One exact
root dependency pins toko-tooling 0.45.0; both libraries inherit it only for
development, and Cargo.lock owns its registry checksum. Root dependency entries
serve actual member inheritance; no display-only aliases or lint allowances are
needed. Both product packages remain in their groups' `members` rosters, with
empty `dependencies` rosters because neither library depends on the other.
Publication derives the selected package directory from the admitted member
manifest, independently of dependency aliases.
Shared executable helpers and catalogs now live under `vendor/toko-tooling/`.
The normal Makefile, consumer metadata/candidate/publication adapters and native
workflow call that tree; release policies remain in local `ci/`. Complete old
frozen candidates retain their original layouts and source-bound recovery owners.
The vendor migration does not reinterpret their journals or enable evidence reuse.


Both groups own their versions and active release notes at the same level. The
root is virtual and has no package or aggregate product version. It supplies common metadata, dependency
selections and validation policy. Its changelog is an index linking both group
ledgers and the historical ledger. A Logging release to 0.24.0 can leave Metrics
at 0.23.1. There is no default release group.

## Maintainer commands

After a successful push, include the baseline's
[focused post-push review](../../TOKO-TOOLING.md#post-push-review) in the delivery
handoff before starting the next increment. Review delivered commits and directly
affected callers; use existing issues or design notes for deferred findings.
This is an agent review, with no additional runner hook or validation target.

Before freezing a candidate, perform the baseline's
[supplier freshness review](../../TOKO-TOOLING.md#current-dependencies-and-upstream-independence).
Include the selected native `ic-build` release editor alongside the release's
actual Cargo suppliers; record newer-supplier dispositions in the existing group
notes. Prepared-tool and pin admission do not supply that review.

The selected product libraries remain dependency-free. Actual development
suppliers are num-bigint, Serde and Toko Tooling; no testkit, PocketIC or maintained
qualification workspace is selected here. The synthetic testkit case checks
workspace/path ownership, not a fleet-wide version generation. Apply the
[shared isolation rule](../../TOKO-TOOLING.md#current-dependencies-and-upstream-independence)
to the actual selected graphs: optional test-supplier upgrade probes do not block
an otherwise qualified frozen selection. Real type/executor boundaries, required
native/product checks and consumer-owned acceptance remain required.

The [0.40.1 deployment sequence](https://github.com/dragginzgame/toko-tooling/blob/dcc51b5cab3d9993f0668bc0902252364d7dc316/docs/releases/releases.md#plan-once-recover-the-failed-phase)
owns planning and failure-specific recovery. This consumer's nested work is:
`release-verify` binds `VALIDATION_REPOSITORY_ROOT` to its consumer and runs the selected plan; version preparation recompiles the selected
final archives; publication freshly admits source and selected-group Clippy,
then uploads and verifies the registry archive. Publication does not call full CI.
Each release validates its explicitly selected product, including after shared
input changes. CI validates both packages once. Tooling implementation qualification
is a separate changed-wiring obligation; no result cache or version projection is needed.

The earlier Metrics 0.30.9 / Logging 0.25.9 batch measured 517 seconds for Metrics' stages and 500 for
Logging's stages. `release-tools-check` dominated at 364 and 355 seconds; native
evidence checks took 51 seconds each. These are retained stage timings,
not total deployment time or a forecast; see the
[delivery receipt](../evidence/releases/toko04411-delivery-20261117.md). Use the
selected attempt's current timings and explain execution/reuse scope before a
new expensive gate. Unchanged fixture evidence remains bound to its inputs.

New batches retain phase observations through failures and resumes. Read them
from the normal checkout with `make release-batch-timings BATCH=batch-n9adqUv3`.
This read-only command prints JSON without setup, validation or network effects;
it takes the existing queue lock. The example uses this deployment's retained
local batch; substitute one retained in your checkout. Older batches return
`[]` without receiving a reconstructed timing journal. Parent durations include
their children, and Cargo publication includes packaging/upload/registry wait.
Timing observations grant no proof reuse or retry authority. The reviewed
[phase-timing contract](https://github.com/dragginzgame/toko-tooling/blob/38a3b259453c56d9fb66e780e53957641f1e73b2/docs/releases/release-batches.md#phase-timings)
owns recording and interpretation. Existing historical receipt measurements keep
their original method and scope.
Consumer release/publication fixtures clear the invoking timing context, so
simulated effects do not enter a live deployment's journal. Nested frozen fixtures
record their own observations separately.

Prepare tools explicitly with `make install-tools` after adopting this snapshot.
The managed release editor is published IC Build 0.83.0 with its cli feature.
The 0.41.0 managed builder uses Cargo 1.100's default packaged installation lock,
while retaining exact version, archive-checksum and packaged-lock admission.
Build/check/test/metadata/publication commands keep their meaningful `--locked`.
Clippy now uses qualified Cargo warning denial; Rustdoc's explicit denial remains.
Fresh captured delivery prepares its own tools through the existing managed
owners before version lookup. Recovery and validation admit that selection without
installing executable tools. Cargo preserves caller-selected network settings;
select offline mode explicitly when required for an invocation.

```sh
make release-version RELEASE_GROUP=metrics   # Metrics current version
make release-version RELEASE_GROUP=logging   # Logging current version
make release-files RELEASE_GROUP=logging     # NUL-delimited exact file plan
make release-patch RELEASE_GROUP=metrics     # Metrics release
make release-patch RELEASE_GROUP=logging
make publish-check RELEASE_GROUP=logging
make publish-verified RELEASE_GROUP=logging
make verify-publication RELEASE_GROUP=logging  # Readback only; never uploads
```

Every release, batch resume, publication and group metadata command requires an explicit
RELEASE_GROUP on the command line or in the environment. Missing, empty and
unknown selections refuse before setup, Cargo, validation or mutation. PACKAGE
never supplies an implicit group. Workspace-wide read-only checks need no group.

Toko Tooling 0.31.0's [release batches](https://github.com/dragginzgame/toko-tooling/blob/12459b6029115b830b8477879d3bea2f030b6e63/docs/releases/release-batches.md) capture committed
source automatically for group increments. A single explicit `RELEASE_GROUP`
selects that group; a multiple-group batch requires an explicit ordered roster:

```sh
# Both groups, with verified publication explicitly selected:
make release-patch RELEASE_GROUP=metrics RELEASE_GROUPS=metrics,logging \
  RELEASE_PUBLISH_TARGET=publish-verified
make release-batch-status BATCH=batch-XXXXXXXX
make release-batch-summary BATCH=batch-XXXXXXXX  # Read-only timing comparison
make release-batch-resume RELEASE_GROUP=metrics BATCH=batch-XXXXXXXX
make release-batch-reconcile BATCH=batch-XXXXXXXX
make release-batch-retire BATCH=batch-XXXXXXXX
```

Omitting the publication target selects Git-only delivery. Never infer the roster
from workspace membership or clear it to request live delivery. The captured
checkout under `target/release-frozen/BATCH` uses its own tools and the saved
source, group, remote and branch. Candidate setup prepares host parsers, admits
the compiler, then delegates locked fetch and Rust/editor preparation to Shared.
Subsequent preflight and resumed setup only check prepared tools. External
tool-catalog overrides refuse; Shared also rejects unsupported Git/Cargo contexts.
This qualifies the captured catalogs and default context, not arbitrary host inputs.

The normal branch remains at its starting commit while the batch delivers. Later
source or lock edits remain deferred there and cannot alter the captured candidate.
Status is read-only; resume selects the saved batch and hooks. Reconcile explicitly
fast-forwards a clean normal branch after completion. Preserve deferred work on a
durable branch first, then reapply it deliberately. Retirement explicitly deletes
the selected completed batch's candidate and recovery state; it is never automatic.
The shared guide owns uncertain-publication acknowledgement and retention rules.

The 0.31 interface is a hard cut: use `RELEASE_GROUPS`, `RELEASE_PUBLISH_TARGET`,
`RELEASE_SETUP_TARGET`, `RELEASE_SETUP_MODE` and `RELEASE_BATCH_ACTIVE`.
Retired settings refuse, including explicitly empty values. New batch journals
use schema 2 and must record the delivered commit before publication. Complete,
reconcile and retire any pre-0.31 batch with its original reviewed tooling before
adopting this interface; do not convert its journal or infer a publication commit
from current HEAD. Existing `release-frozen`/`frozen` storage paths and source pins
retain their identities. This checkout had no batch journals at adoption.

Release and publication retain separate commands and evidence. A scoped
[ship/deploy request](https://github.com/dragginzgame/toko-tooling/blob/12459b6029115b830b8477879d3bea2f030b6e63/rules/contributions.md#delegated-delivery) can authorize
both; ordinary implementation does not. Publication selects
the chosen group's public package. A PACKAGE override must belong to that
group; cross-group selections refuse before lint or Cargo publication. No group
change republishes an existing package version. Select a new numbered candidate
through the maintainer release flow when publishing changed package metadata.

Upload from the clean checkout of the selected group's annotated release tag,
after its exact tag has reached the declared repository. The explicitly selected
batch publication target runs immediately after each group's release in the
captured checkout. For standalone publication, explicitly check out the selected
tag; the unreconciled normal branch does not contain the delivered release.
The shared publisher retains the upload command and status; `publish-verified`
then checks the non-yanked registry entry, archive checksum and clean source
identity through Shared's observation/provenance helpers. If readback fails, use
`verify-publication` to reconcile without repeating the upload. No automatic
retry, release or version change is part of either verification command.

Preflight admits prepared tools. Release validation adopts Toko Tooling's
[group-plan contract](https://github.com/dragginzgame/toko-tooling/blob/12459b6029115b830b8477879d3bea2f030b6e63/docs/releases/release-group-validation.md). The consumer-owned
[roster](../../ci/release-validation.json) is the single ordered declaration for full
CI and release selection. Shared's roster helper admits the projected Cargo group
names; neither caller parses Make recipes or maintains another stage list.
Compiler admission is the same check exposed by `msrv`, without a second compiler
matrix. Repository CI still covers both libraries on all three required hosts.

Releases always select the requested independent package. Fresh common checks
admit the dependency-free architecture, shared manifests, lock and tool selection;
there is no tag-baseline inference. CI checks both libraries. Unknown package
membership refuses until its mapping is qualified. Changed pipeline wiring gets
its own focused qualification before delivery, rather than replaying regression
fixtures as part of the release. Group selection does not establish downstream
consumer or native/IC runtime acceptance. Services retain their own Wire/report
DTO qualification; IC Storage retains governed storage adapters.

The local mapping retains these product obligations for
[Observability #129](https://github.com/dragginzgame/ic-observability/issues/129):

| Boundary | Required obligations and owner |
| --- | --- |
| Metrics | All-feature native/Wasm lint/docs, all-feature tests and archive; public API/persistence client tests, dependency-free feature graphs and allocator-free Wasm linking. `recording` remains an explicitly selected feature. |
| Logging | All-target native and Wasm-library lint, native/Wasm docs, engine/example/doctests and archive; dependency-free graphs on both targets. |
| Reverse consumers | Metrics attribution/recording/reset contracts remain with the application tree under the [downstream contract checks](../architecture/extraction.md#downstream-contract-checks). Canic's adapter owns reporting; Storage owns governed persistence. The [0.29 API inventory](../architecture/metrics-api.md) tracks concrete consumer repairs. No owning acceptance is inferred from a core gate. |
| Hosts and installed artifacts | Linux x86_64, macOS x86_64 and macOS arm64 retain their [native CI obligations](../development/hosts.md). These libraries install no CLI or endpoint. Cargo archive verification and selected-package registry/source readback remain separate release/publication requirements. |
| Shared and unknown inputs | Fresh common admission plus the selected product during release; both products in CI. Unknown package membership refuses. External contract changes still require review by their owners. |

The group-validation adoption itself altered no library API or retained-data
contract. Later product releases retain their own migration and consumer obligations;
the Metrics 0.29 hard cut does not imply sibling acceptance.

## Plans, transactions and recovery

The frozen runner owns capture and orchestration; the existing standard runner
and group-capable editor inside that checkout own metadata rendering,
selected-package lock updates, staging, commits, tags, push and resume. The local
adapter supplies group policy, existing tool preparation, planned validation and
source/receipt admission. There is no second release implementation.

Plans always include Cargo.toml and Cargo.lock. Each group additionally selects
its own literal-version manifest and ledger. There are no product dependency
aliases to update, so the current root manifest remains byte-identical during a
group version change. Other groups' versions, manifests and pending notes, plus
external dependency selections, remain preserved. Future shared consumer metadata needs an explicit shared_metadata_files
declaration plus selective rendering/qualification; none is needed for this split.

New tags are metrics-vX.Y.Z and logging-vX.Y.Z; subjects are Release metrics X.Y.Z
and Release logging X.Y.Z. The shared runner journals GROUP-X.Y.Z.plan under Git's
release-state directory, with selected files alongside it. The adapter keeps its
validated/prepared receipts in GROUP-X.Y.Z/ and binds source, destination, group,
policy blob and prepared bytes. Each attempt retains its canonical plan,
host/compiler/build configuration, complete source-input checkpoint, stage
decisions, raw logs and timings beneath `target/release-validation/`. A versioned
Shared proof requires every selected stage to pass with before/after input
observations. The [shared verifier](https://github.com/dragginzgame/toko-tooling/blob/12459b6029115b830b8477879d3bea2f030b6e63/docs/releases/group-validation-adoption.md) owns event,
timing, checkpoint and log admission while source is still pristine. The consumer's
`group-validation:3` validated receipt binds that proof's bytes and release intent.
After allowed version metadata changes, late admission regenerates the original
selection/configuration and checks byte custody of the sealed plan/context,
policy, group projection and all Shared-admitted records/logs. The caller context
binds the physical checkout root, so copying a proof to another checkout refuses.
Existing metadata,
source and index checks admit the prepared commit. It does not rerun the generic
verifier against changed metadata, project versions or relocate proof.
Missing, altered, interrupted or failed evidence refuses.
No check-result reuse or package-version projection is enabled. A failed seal or
collector has no qualified post-processing recovery in this adapter; successful
logs alone cannot replace its missing sealed proof. Diagnose the failed phase
and changed inputs against the
[shared recovery contract](https://github.com/dragginzgame/toko-tooling/blob/dcc51b5cab3d9993f0668bc0902252364d7dc316/docs/releases/release-validation-reuse.md#failure-specific-recovery)
before retrying. Metadata uses its owning transaction; uncertain uploads use
read-only `verify-publication` and the saved batch acknowledgement, never blind
re-upload. If proof cannot be admitted, explain that concrete limitation and the
resulting rerun scope before starting another full plan. Retain the attempt
directory; deleting `target/` also removes that evidence.
One repository-wide lock protects the shared lock.
Renderer failure restores original selected files; wrong-group or altered
receipts cannot resume. Older receipts remain archived rather than overwritten.

Existing tags and journals keep their original meaning, including the 0.23.1
group attempts made before this ledger migration. They are not converted to the
new file plan. Exact old-attempt recovery belongs to its recorded source, policy
and adapter. The completed 0.28.1/0.24.4 deliveries retain their version-1 consumer
receipts and recorded adapter; the new format does not reinterpret them. Both
recorded 0.23.1 attempts were complete before the group-ledger change.
New batch recovery uses `release-batch-resume`; it delegates exact-version
`release-resume` to the captured standard journal when needed. Earlier standalone
attempts retain their recorded source and adapter; do not reinterpret them as batches.

Independent releases do not make incompatible integration stacks compatible.
Services coordinate their own Wire identities and schemas; persistence
adapters retain their own integration/release owners. Arithmetic, Serde fields,
encoded bytes and Logging's retained-data contract do not change in this split.

## Tooling 0.45.15 delivery — 2026-11-19

Batch `batch-R73F5ykH` captured `1903bc0ceb4129d25af747faa4b83b5cedd95ffa`,
which includes the authenticated tooling adoption, Rust module layout cleanup,
CI redaction coverage and documentation corrections. Both selected groups
completed direct GitHub delivery and verified crates.io publication. The
normal checkout fast-forwarded cleanly to the final release commit.

| Package | Version | Source commit | Registry archive SHA-256 |
| --- | --- | --- | --- |
| `ic-metrics` | 0.30.15 | `f35515ce30f4dd14116abeb8fadec09a1a32f4bf` | `bf6dd03dec76e3e3f4fd9b415020c6588961f4968d57c333e5fae20bff1586f5` |
| `ic-logging` | 0.25.14 | `6c394593502cdd67011bc0d9e784914ade474c98` | `9dfb8e84abba7483562f11bf9101fecf00cffe5b61c1ce103b162fb46a40e17b` |

For both groups, fresh source admission, strict native and Wasm Clippy, selected
product checks and final-version archive verification passed. Registry readback
matched 34 maintained Metrics files and 16 Logging files to the tagged commits.
The follow-up check confirmed both annotated tag objects, peeled commits,
non-yanked index entries and archive checksums. Review of the delivered adoption
and both group increments found no actionable issue. Hosted CI is asynchronous.

The batch took **173.1 seconds**, compared with 204.8 seconds for
`batch-UmMkf0J8`. Outer phases totaled 124.8 seconds for release, 30.3 for setup
and 17.5 for publication. Cargo observed two uploads and no admissions were
reused. Cache warmth is unrecorded, so the difference is an observation.
Logs, phase timings and reconciliation are under
`target/deploy/toko04515-20261119/`. The completed candidate and recovery data
remain under `target/release-frozen/batch-R73F5ykH` and
`.git/release-state/frozen/batch-R73F5ykH/`.

## Tooling 0.45.8 delivery — 2026-11-18

Batch `batch-UmMkf0J8` captured `27e7516880de9669faf67479c22e4b443ac1ee06`,
published both selected groups, independently verified their registry archives,
and reconciled the normal checkout. Source includes the 0.45.8 adoption, Rust
layout/lint cleanup and fixes for
[Observability #138](https://github.com/dragginzgame/ic-observability/issues/138) and
[Observability #139](https://github.com/dragginzgame/ic-observability/issues/139).
The prior local handoff commit is also delivered. Product APIs remain unchanged.

| Package | Version | Source commit | Registry archive SHA-256 |
| --- | --- | --- | --- |
| `ic-metrics` | 0.30.14 | `e5314eb5fd035fea0339b1c0e04670236d6e831d` | `9e8a3b60fb25c50dc3d46021af953901d36c56d7d09aa5f14ca3e57d6ba69087` |
| `ic-logging` | 0.25.13 | `864c209308eb6e61dcb80c7a5089e47691668510` | `b92c305f3ce1286d458358675f321097d45c764d4be127f9f2923d3ef2eecf0a` |

Fresh admission, strict lint, selected-package product checks, final-version
archives and registry content verification passed (34 Metrics / 16 Logging
maintained files). Both annotated tags and commits reached GitHub. The earlier
21 package-inventory and 72 diagnostic regression assertions retain their exact
repair scope. Review of the pushed adoption, affected callers and both metadata
increments found no actionable issue. Hosted CI remains asynchronous; no new
completed hosted pass or downstream acceptance is claimed.

The batch took **204.8 seconds**, versus 170.1 seconds previously. Outer phases
totalled release 142.0s, setup 35.0s and publication 22.0s. Two uploaded packages
were observed and no admissions were reused. Cache warmth is unrecorded, so the
34.7-second difference does not identify a causal regression. No gate was widened.
Logs, reconciliation and phase JSON are in `target/deploy/toko0458-20261118/`.
The candidate and recovery journal remain under
`target/release-frozen/batch-UmMkf0J8/` and
`.git/release-state/frozen/batch-UmMkf0J8/`; older recovery custody is unchanged.

## Tooling 0.45.3 delivery — 2026-11-18

Batch `batch-WcMBa4Gv` captured `88ac178bb534f95a889eeeac6ae19dbbb6152789`,
delivered both groups with verified publication, and reconciled the normal
checkout cleanly. The source includes the authenticated 0.45.3 adoption,
Observability #137 cleanup and the setup profile below. Product Rust/APIs and
unrelated dependency selections remain unchanged; supplier dispositions are in
each group's ledger. No optional stage sealer or validation reuse was enabled.

| Package | Published version | Source commit | Registry archive SHA-256 |
| --- | --- | --- | --- |
| `ic-metrics` | 0.30.13 | `2407be9864a7c1af70ac32c9a745cab101509456` | `d6a7392a38636946c8d717f715062b5f8c1797eb37a548b56357e23e8930d7dc` |
| `ic-logging` | 0.25.12 | `b7a7f54610cd18ee76a6fb80f09d6930b8140886` | `f52e344254c89fd37209131929cbd36c7627daacb1a3c34ec05656882286ee78` |

Both annotated group tags and release commits reached GitHub. Fresh three-stage
group validation, final-version archive compilation and independent registry
readback passed, matching 34 Metrics and 16 Logging maintained files. Focused
review of the pushed adoption, affected callers and each metadata increment found
no actionable issue. The changed publication caller's selection, lint-failure and
upload/readback ordering fixture passed with substituted effects; the new summary
correctly read the prior retained batch. Hosted CI remains asynchronous.

The successful batch took **170.1 seconds**, compared with 188.1 seconds for
`batch-C6LML5zV`. Outer phases totalled release 121.0s, setup 29.9s and publication
18.6s. Two uploaded packages were observed; no admissions were reused. Cache
warmth was unrecorded, so this is an observation rather than a causal speedup claim.
Logs and phase JSON are under `target/deploy/toko0453-20261118/`; the candidate
and durable journal remain under `target/release-frozen/batch-WcMBa4Gv/` and
`.git/release-state/frozen/batch-WcMBa4Gv/`.

The preceding failed batch `batch-ahGwBRzT`, source
`f27a5bcd3ba382b67c430f25d2670fe72eb75a41`, stopped at ledger preflight before
validation, metadata or delivery. Generic Unreleased headings were corrected to
numbered pending entries and checked before the fresh batch. Its original
candidate and logs remain; the 170.1-second successful timing excludes that
attempt and maintenance work. No older recovery state was retired or reinterpreted.
Retired local npm artifacts were preserved under
`target/deploy/toko0453-20261118/preserved-typescript-node_modules/`.

## Setup command profile — 2026-11-18

Local maintenance adopted Toko Tooling 0.45.2 through the authenticated exporter.
The existing 111 selected files are byte-identical to 0.45.0; optional stage
sealing is not selected. Product versions, gates and other dependency selections
remain unchanged. This is not a release or a replay of the 188.1-second batch.

Two sequential warm passes timed the candidate setup's underlying commands on
Linux x86_64 with Rust 1.100.0, after explicit tool installation. Each command ran
under `/usr/bin/time`, recording elapsed seconds and exit status independently.
Make targets used `make --no-print-directory`; the fetch used `cargo fetch
--locked`. Both passes used the same normal checkout without metadata increments.
They omit the candidate wrapper's group selection, pin-guard overhead and frozen
capture context; they identify component costs, not exact release-span timings.

| Command | Pass 1 (s) | Pass 2 (s) |
| --- | ---: | ---: |
| `toko-tooling-check` | 0.77 | 0.71 |
| `install-host-tools` | 0.19 | 0.20 |
| `compiler-check` | 0.08 | 0.08 |
| `cargo fetch --locked` | 0.03 | 0.03 |
| `install-rust-tools` | 4.49 | 4.49 |
| `rust-tools-check` | 4.52 | 4.64 |
| `install-release-editor` | 2.44 | 2.41 |
| `release-editor-check` | 2.33 | 2.44 |
| Total | 14.85 | 15.00 |

All commands passed. Before/after SHA-256 checks matched for root Cargo manifest,
lockfile, compiler selection, host/Rust catalog, release-editor catalog and
candidate setup script. Installer logs report selection reuse, not compilation.
Raw timings, logs, input hashes and the measurement script are retained under
`target/qualification/toko0452-setup-20261118/`.

Common Rust tooling plus editor preparation/admission accounts for about 93% of
both passes. Fresh locked fetch is negligible here. Keep the current gates:
matching repository files alone does not bind all mutable tool-store selections,
receipts, executable bytes and native build inputs admitted by the installer.
Any future reuse should first qualify that complete boundary with Toko Tooling,
including changed-tool rejection; a generic stage seal alone is insufficient.
These measurements establish no cold-cache, other-host or IC product cost.

## Release stage ownership and triggers

[Observability #136 — Reconstruct CI and release tooling](https://github.com/dragginzgame/ic-observability/issues/136)
replaces the historical 20-stage roster and annotated-tag change classifier.
The three ordered stages in [the policy](../../ci/release-validation.json) are
mandatory for every selected group. There are no omission decisions or reusable
stage receipts. Shared owns execution, source observations and sealed evidence.

| Guarantee | Owner and trigger |
| --- | --- |
| Compiler, snapshot, prepared tools, pins, formatting, source/package links and dependency/encoding boundaries | `source-check`, every CI/release |
| Warning-free native and Wasm code, all features/targets | `clippy`, before product checks in every CI/release |
| Arithmetic, bounds, overflow, restoration, retention, paging and sequence/time continuity | Package-local tests through `product-check`, every CI/release |
| Native/Wasm documentation and dependency-free feature closures; fixed Metrics allocator-free link | `product-check`, selected package in releases, both packages in CI |
| Final-version archive compilation | `release-prepare-version`, after metadata preparation; CI checks both current-version archives once |
| Explicit group, source/index custody, independent metadata, exact commits/tags, interrupted push | Shared capture/standard release with consumer metadata hooks, every release effect |
| Registry identity, provenance and complete source readback; uncertain-upload reconciliation | Consumer publication adapter over Shared publication, every upload/readback |
| Tooling wiring, evidence failures and recovery | Focused fixtures when wiring changes; explicit `make tooling-check` or manual CI tooling input |

Ordinary development runs the affected named package tests. `make ci` runs the
three stages with workspace scope, then `package-check`; it cannot inherit a
narrow release scope. The hosted workflow retains Linux and both macOS hosts,
independent security scanning and bounded setup/failure diagnostics. Its optional
manual tooling input runs tooling qualification once on Linux.

Single-group delivery runs admission, lint and product checks for that group,
then prepares and compiles its final-version archive. A two-group batch repeats
that sequence for each independent group: neither product is compiled/tested
as the other group's gate. Current source/tool admission remains fresh after the
first commit. Compiler/download caches are performance aids, never proof reuse.
Publication still performs fresh source and lint admission and archive readback.

The old nested retention coordinator and baseline-dependent stage omissions are
removed. Generic lifecycle/EXIT permutations belong to Toko Tooling. Consumer
fixtures remain direct commands, outside routine CI and deployment:

- `make release-validation-check`: both groups and shared inputs, full-CI routing,
  strict lint ordering, missing/changed inputs, failed stages and sealed-log custody.
- `bash scripts/release/test-standard-release.sh`: actual Make dispatch and failure
  propagation; `--selection-only` selects just package/Cargo argument routing.
- `bash scripts/release/test-release-admission.sh --refusals-only`: explicit selection,
  dirty source, preparation/gate failures and input drift before effects.
- `bash scripts/release/test-release-batch.sh`: actual two-group capture, setup,
  editor, source/index admission, archives and content verification against local
  Git/registry fixtures; push failure, uncertain upload, offline resume and deferred
  lock custody. It preserves one-upload-per-package assertions.
- `bash scripts/release/test-publication-policy.sh`: actual source/tag/content policy
  with simulated HTTP; `make ci-evidence-check` qualifies diagnostic collectors.

The broader standalone admission fixture and its generated consumer tests remain
available for metadata or compatibility changes; they are not deployment gates.
No product tests, public APIs, Rust sources or storage boundaries were removed.

## Historical attempts and qualification

Interrupted batch `batch-sSjwd230` retains its original source and tools.
Metrics 0.30.10 was delivered at
`b9d488dec7eaf40c79f665880051b2d45c68ae1a`; Logging 0.25.10 was stopped
before delivery. Never resume this old batch with the replacement pipeline.
Its candidate and durable journals remain unchanged. Normal main was fast-forwarded
to the delivered Metrics prefix before starting this reconstruction.

The previous stage-reuse probe remains historical under
`target/qualification/issue136/`. This design does not use that runner or require
[Toko Tooling #389](https://github.com/dragginzgame/toko-tooling/issues/389).
The unused stage runner and retention probe were retired through the authenticated
0.44.11 exporter (55 entrypoints / 111 files); no managed bytes were hand-edited.
Historical 20-stage and Observability #135 scoped receipts retain their original
semantics; the new `group-validation:3` identity cannot admit their receipts.

Current reconstruction qualification is recorded under
`target/qualification/issue136-rebuild/`. Timings must distinguish simulated
registry/local Git effects, actual compiler/archive work and warm tool/build caches.
No live publication is required to qualify this change.

### Reconstruction qualification — 2026-11-17

The same delivery/recovery harness ran against the prior pipeline at
`b9d488dec7eaf40c79f665880051b2d45c68ae1a` and the local replacement, on
Linux x86_64 with Rust 1.100.0 and Toko Tooling 0.44.11. Both used prepared
managed tools/download caches and fresh disposable candidate target directories;
compiler outputs were reused normally within each candidate. No validation-stage
result was reused. Each run injected failed push, missing prepared tools and an
uncertain upload, then completed both groups with exactly one upload each.

| Measured interval, seconds | Prior pipeline | Replacement |
| --- | ---: | ---: |
| End-to-end fixture through completed delivery/reconciliation and report capture | 281 | 167 |
| Candidate preparation and recovery tool checks | 38.7 | 39.9 |
| Preflight | 18.1 | 17.9 |
| Validation, both groups | 164.6 | 53.0 |
| Metadata preparation and final-version archives | 28.2 | 28.4 |
| Git staging/commit/tag/push, including failed push | 9.5 | 9.4 |
| Simulated registry delivery | 5.9 | 6.4 |

These are single-run fixture observations, not live-release estimates. Git used
local bare remotes; registry upload and HTTP responses were simulated, while
source admission, setup, strict lint, product tests, docs, feature graphs,
allocator-free linking, archive compilation and archive-content readback were real.
`--measure` replaced the five old tooling-regression target bodies with no-ops on
both revisions. Those targets are absent from the new production path, so the
comparison excludes their former execution cost rather than estimating it.
The retained historical delivery above separately measured that expensive work.
Phase rows do not sum exactly to total: they exclude harness orchestration,
explicit readbacks and report capture; parent/child phase timings must not be added.

The old pipeline validated both products and compiled pre-version workspace
archives in each group plan. The replacement validates each product once and
compiles its final-version archive after preparation. Both runs recorded exactly
two successful `release-validate` phases: push/upload recovery did not repeat
validation. New stages measured Metrics 12/4/7 seconds and Logging 13/3/5 seconds
for source admission/lint/product checks. Product tests passed (146 passed,
one pre-existing ignored test). Setup, fresh source/tool admission and final-version
archives now dominate the retained work; they bind each independently prepared
source and publication identity and are intentionally not cached as evidence.

Evidence is under `target/qualification/issue136-rebuild/`: `comparison.json`,
`before-delivery.log`, `after-delivery-final.log`, `measurement-harness.sh` and
`measurement-harness.sha256` identify the same measured harness. The comparison
JSON locates each retained phase journal and validation logs. The final harness
also honors explicit `TMPDIR` for native-CI diagnostic custody; the measured runs
used its default path. Early failed fixture attempts remain retained, including
a sandbox tool-store-lock refusal and a harness edit interrupted between phases;
neither is counted as successful qualification.

Focused plan/input/evidence failures, both-group pre-effect refusals, real Make
package/profile/publication routing, CI selection/manual-tooling wiring and native
diagnostic wiring passed. Exporter admission, Perl/Bash syntax, ShellCheck, local
links and diff checks passed. Changed-wiring qualification replaces the removed
nested matrix; generic producer regression remains upstream. No hosted matrix,
live publication, product source change or sibling mutation is claimed.

### Live delivery — 2026-11-17

The separately authorized delivery completed in batch `batch-dZNTL4CS`, source
`3974fd375485c133b5284255c4d09477167b8c32`. Both packages reached GitHub and
crates.io and passed fresh independent archive/source readback:

| Package | Release commit | Annotated tag object | Registry SHA-256 |
| --- | --- | --- | --- |
| ic-metrics 0.30.11 | `68b43e14d3144511b845b6c81e42398e97c74d3c` | `0cc2e22a4cc85f0d3222c7e1ebd55caa40950bf3` (`metrics-v0.30.11`) | `668d99823f32f894f87b98c6ece3de57653f5f416d479ad4cd7faca223eb6dc3` |
| ic-logging 0.25.10 | `35833473a3620c0b50bce94bfa7b1e8d3e38ea66` | `2ad8e67b5796b6704169d77f9f1547ee5c07f81a` (`logging-v0.25.10`) | `73eb1025ecd62fc521536e2efd9995414d97cfd28b1bae6ba2402ebb70796791` |

The real batch interval was **166.8 seconds**, including prepared-tool admission,
validation, metadata/archive preparation, Git delivery and registry publication.
It used warm managed tool/download caches and a fresh captured candidate; product
compiler outputs were reused within that candidate, never as validation evidence.
No gates or registry effects were substituted. Metrics stages measured 12/5/7
seconds and Logging 12/3/4 seconds for admission/lint/product checks. Shared's
complete validation phases, including observation/sealing overhead, measured
27.8 and 23.9 seconds; metadata plus final archives took 14.5 and 13.9 seconds;
publication/readback took 8.5 and 9.5 seconds. These are one delivery's timings,
not a guarantee for cold setup or later registry conditions.

Readback matched all 34 maintained Metrics files and 16 Logging files. Evidence
is retained in the candidate's `target/publication/verification.EJ8iTk` and
`target/publication/verification.6PQ4tk`. Delivery logs, supplier review, phase
journal and focused post-push review are under `target/deploy/issue136-20261117/`.
The normal branch was reconciled to the delivered Logging commit. Both metadata
increments touched only their own manifest version, lock entry and ledger date;
no actionable post-push finding was identified. Hosted CI is asynchronous and
separate from these completed local/registry checks.

The completed candidate and durable Git journal remain intact. Historical
`batch-sSjwd230` still has its original stopped state; it is not resumed or
converted. No sibling delivery, protected cleanup or duplicate upload occurred.

### Tooling 0.45.0 delivery — 2026-11-18

Authorized batch `batch-C6LML5zV` delivered source
`e9c42adc332eda196ceab27011199ac6eb527e79` to GitHub and crates.io:

| Package | Release commit | Annotated tag object | Registry SHA-256 |
| --- | --- | --- | --- |
| ic-metrics 0.30.12 | `2647e2858ca171616d737f1627741e4b202548f3` | `86300f784e81432416e9ad44b99a11fff75fa9c6` (`metrics-v0.30.12`) | `26acd88e610363878e0c63add0cdeee183ebb506e14ac7321663c201c0c5f7ae` |
| ic-logging 0.25.11 | `f8052d992f9371062a5c81a679214c20a8f72c93` | `03cf5cbf098b3611d0a53d2e1af1e890c055643e` (`logging-v0.25.11`) | `c46acb13f261eb5ecfea855013f76d61fe05917613a3cd651c9c5a49bf22b664` |

The real capture-through-publication interval was **188.1 seconds**, with warm
managed tool/download caches and a fresh candidate. Metrics admission/lint/product
stages took 11/5/7 seconds; Logging took 12/4/5 seconds. Final-version archives,
fresh publication admission and independent registry/source readback passed.
No effects were simulated or validation results reused. Cargo briefly waited on
the shared package cache; this single observation is not a performance guarantee.

Readback matched all 34 maintained Metrics and 16 Logging files, retained under
the candidate's `target/publication/verification.wITGmE` and
`target/publication/verification.r5s1r6`. Supplier review, delivery and reconciliation
logs and phase timings remain under `target/deploy/toko0450-20261118/`.
Optional IC Build 0.87.4 and cargo-sort-derives 0.15.0 upgrades are deferred to the
next requested tooling maintenance pass, as recorded in both ledgers.

The normal branch reconciled to the delivered Logging commit. Focused post-push
review found no actionable issue in the adoption and affected callers; each
release increment changed only its own manifest version, lock entry and ledger
date. Ledger dates use UTC (2026-11-17); this record uses the maintainer's local
date. Hosted CI remains asynchronous. Original candidates, journals and stashes
remain intact; no sibling changes, retirement or duplicate uploads occurred.
