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
root dependency pins toko-tooling 0.41.0; both libraries inherit it only for
development, and Cargo.lock owns its registry checksum. Root dependency entries
serve actual member inheritance; no display-only aliases or lint allowances are
needed. Both product packages remain in their groups' `members` rosters, with
empty `dependencies` rosters because neither library depends on the other.
Publication derives the selected package directory from the admitted member
manifest, independently of dependency aliases.

Both groups own their versions and active release notes at the same level. The
root is virtual and has no package or aggregate product version. It supplies common metadata, dependency
selections and validation policy. Its changelog is an index linking both group
ledgers and the historical ledger. A Logging release to 0.24.0 can leave Metrics
at 0.23.1. There is no default release group.

## Maintainer commands

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
`release-verify` runs the selected plan; version preparation recompiles the selected
final archives; publication freshly admits source and selected-group Clippy,
then uploads and verifies the registry archive. Publication does not call full CI.
Whole-source proofs and disabled version projection currently prevent cross-group
stage reuse, so shared changes still require each group's complete plan. Do not
claim the new policy supplies that missing admission or collector repair.

The last delivered batch measured 528 seconds for Metrics' stages and 521 for
Logging's stages. `release-tools-check` dominated at 381 and 375 seconds; native
evidence checks took 50 and 51 seconds. These are retained stage timings,
not total deployment time or a forecast; see the
[delivery receipt](../evidence/releases/toko0410-export-20261113.md). Use the
selected attempt's current timings and explain execution/reuse scope before a
new expensive gate. Unchanged fixture evidence remains bound to its inputs.

Prepare tools explicitly with `make install-tools` after adopting this snapshot.
The managed release editor is published IC Build 0.83.0 with its cli feature.
The 0.41.0 managed builder uses Cargo 1.100's default packaged installation lock,
while retaining exact version, archive-checksum and packaged-lock admission.
Build/check/test/metadata/publication commands keep their meaningful `--locked`.
Clippy now uses qualified Cargo warning denial; Rustdoc's explicit denial remains.
Fresh captured delivery prepares its own tools through the existing managed
owners before version lookup. Recovery and validation admit that selection offline.

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
make release-batch-resume RELEASE_GROUP=metrics BATCH=batch-XXXXXXXX
make release-batch-reconcile BATCH=batch-XXXXXXXX
make release-batch-retire BATCH=batch-XXXXXXXX
```

Omitting the publication target selects Git-only delivery. Never infer the roster
from workspace membership or clear it to request live delivery. The captured
checkout under `target/release-frozen/BATCH` uses its own tools and the saved
source, group, remote and branch. Candidate setup prepares host parsers, admits
the compiler, then delegates locked fetch and Rust/editor preparation to Shared.
Subsequent preflight and resumed setup only check prepared tools offline. External
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

The selector compares the entire proposed source with the annotated ancestor
tag for the selected group's current version. Only implementation, examples,
tests and documentation confined to that independent library can narrow scope.
The other package has no dependency edge, shared public identity, runtime,
generated client or storage integration with it. Common declaration guards still
admit that architecture. Metrics keeps all-feature native/Wasm lint, Rustdoc,
tests and archives, dependency-free feature graphs, public API/persistence checks
and the allocator-free Wasm link.
Logging keeps the same package gates and its dependency-free native/Wasm graphs.
Common tools, policies, formatting, documentation, evidence and release fixtures
remain required; package-document link checks still inspect both archives.

Manifests/features, Cargo.lock, compiler policy, shared code, CI/release machinery,
other-group changes and unknown paths select the complete workspace gate. A
missing, lightweight or nonancestor baseline also broadens scope. The adoption
itself therefore requires full validation at release time. Group selection does
not establish downstream consumer or native/IC runtime acceptance. Services
retain their own Wire/report DTO qualification; IC Storage retains governed storage adapters.

The local mapping retains these product obligations for
[#129](https://github.com/dragginzgame/ic-observability/issues/129):

| Boundary | Required obligations and owner |
| --- | --- |
| Metrics | Default/all-feature native and Wasm lint/docs, all-feature tests and archive; public API/persistence client tests, dependency-free feature graphs and allocator-free Wasm linking. `recording` remains an explicitly selected feature. |
| Logging | All-target native and Wasm-library lint, native/Wasm docs, engine/example/doctests and archive; dependency-free graphs on both targets. |
| Reverse consumers | Metrics attribution/recording/reset contracts remain with the application tree under the [downstream contract checks](../architecture/extraction.md#downstream-contract-checks). Canic's adapter owns reporting; Storage owns governed persistence. The [0.29 API inventory](../architecture/metrics-api.md) tracks concrete consumer repairs. No owning acceptance is inferred from a core gate. |
| Hosts and installed artifacts | Linux x86_64, macOS x86_64 and macOS arm64 retain their [native CI obligations](../development/hosts.md). These libraries install no CLI or endpoint. Cargo archive verification and selected-package registry/source readback remain separate release/publication requirements. |
| Shared and unknown inputs | Full workspace scope, including both libraries and every common stage; unknown package membership refuses until its mapping is qualified. External contract changes still require review by their owners. |

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
policy blob and prepared bytes. Each attempt retains its canonical plan, baseline,
host/compiler/build configuration, complete source-input checkpoint, stage
decisions, raw logs and timings beneath `target/release-validation/`. A versioned
Shared proof requires every selected stage to pass with before/after input
observations. The [shared verifier](https://github.com/dragginzgame/toko-tooling/blob/12459b6029115b830b8477879d3bea2f030b6e63/docs/releases/group-validation-adoption.md) owns event,
timing, checkpoint and log admission while source is still pristine. The consumer's
`group-validation:2` validated receipt binds that proof's bytes and release intent.
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

## Focused qualification

`make release-tools-check` is an aggregate of the consumer-owned fixtures below.
The standard/internal-hook and group admission fixtures exercise the actual
adapter, shared runner/editor and
local Git remotes in disposable repositories. It checks both group directions,
missing/empty/unknown group refusal, unrelated versions/requirements/ledgers,
unchanged root bytes without display aliases, stale-alias refusal, index/history inputs,
exact changed files, rollback, receipts, resume
and publication selection. Setup, broad gates, archive compilation and
registry effects are substituted. Unchanged-group consumers use workspace-owned
source copies pinned to their prior compatible identities; this is source-level
consumer evidence, not publication of the simulated releases. Successful group
receipts and all failures remain retained at the printed evidence directory.
Other standard Make, hook and retention fixtures keep their distinct scopes.

`bash scripts/release/test-release-batch.sh` qualifies the outer automatic capture
with both groups' real candidate setup, metadata editor, source/proof admission,
native/Wasm Clippy, final archive compilation and publication content readback.
It substitutes the production validation roster with those three real stages,
uses a local bare Git remote and simulates registry upload/HTTP effects. It tests
interrupted push, offline recovery with missing tools, uncertain publication,
completed resume without another upload, deferred normal-lock custody, dirty
reconciliation refusal, clean fast-forward and explicit retirement. Successful
fixture inputs are removed; failures remain at the reported path. This proves
consumer wiring, not the full production gate, hosted macOS or live registry
delivery. Release validation still runs the complete selected production plan.

For changes confined to generated consumer code or its test layout, use
`bash scripts/release/test-release-admission.sh --consumers-only`. It freezes the
current Metrics and Logging suppliers into workspace-owned copies, generates
integration tests under each client's `tests/contract.rs`, and executes those
named targets with locked dependencies. The no-argument fixture retains the
complete group transaction, rollback, recovery and unaffected-identity checks.

`make release-validation-check` keeps lightweight product mapping, exclusion,
Shared-helper wiring and receipt-custody regressions in routine CI.
`make release-validation-qualify` additionally compares full and selected command
traces and proves full-CI workspace selection/lint ordering. Renew that matched
qualification when mapping, runner, relevant configuration or covered contracts
change, or by explicit request; it does not run permanently in every ordinary CI
change. Its Make effects are substituted, so applicable native acceptance still
belongs to the three-host CI matrix and real package gates.
