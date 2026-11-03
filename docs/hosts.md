# Host support and qualification

| Native host | Required support | Configured runner |
| --- | --- | --- |
| Linux x86_64 | Library build and development tooling | `ubuntu-24.04` |
| macOS Intel | Library build and development tooling | `macos-15-intel` |
| macOS Apple Silicon | Library build and development tooling | `macos-15` |

All three hosts run the complete native suite. Bash 3.2 checks on Linux and Wasm
cross-compilation do not establish native macOS acceptance. Routine CI retains
the latest workflow/ref run through cancellation; a cancelled run never qualifies
its source. Native jobs have a 60-minute budget for cold setup and validation.
The [shared host rules](supported-hosts.md) own the common support contract.

Native input hashing and workflow fixture copies use
`scripts/ci/native-source-files.sh`, which emits NUL-delimited maintained paths
including pending source. The workflow records common managed tool paths, hashes
and observed versions through Shared Tooling; compiler selection stays local. Failed observations retain partial diagnostics.

CI prepares pinned host parsers before reading Rust policy from TOML. The
separate `host-tools.log` and outcome survive setup failure; Rust and subsequent
common setup are skipped when parser preparation fails. The selected
`prepare-common-tools` action reuses those host tools and owns complete common installation,
offline checking and PATH publication after success. The always-run
[native evidence collector](../scripts/ci/collect-native-evidence.sh) projects
its `RUNNER_TEMP/tools-install.log` and `tools-check.log` into
the retained `tools-setup.log` and `tools-check.log` names. Setup failures keep
their actual stdout/stderr; skipped setup does not select unrelated temp logs.
Shared Tooling tests the action's installation and PATH mechanics; Metrics tests
its action reference, outcome/log projection and complete recovery evidence.

Diagnostic collection failure still allows the independently admitted native
recovery archive to be packaged and uploaded. The artifact step retains the
collection failure status; a secondary packaging failure is reported without
replacing that first error. A recovery archive does not establish complete tool
collection or turn a failed check into a successful one.

## Prerequisites and focused checks

After adopting Shared Tooling 0.27.26, rerun `make install-tools`, then
`make tools-check`: the changed build-helper policy participates in tool identity.
Linux fingerprints retain native tool/header/library providers while excluding
unrelated applications. Successful tool compilation scratch is discarded after
admission; selected executables, source archives and receipts remain. Retiring
old executable generations is explicit owner-operated maintenance under the
[shared guide](tool-store-maintenance.md), with quiescence and custody checks.
No store reclamation or application-artifact cleanup is part of this adoption.
Explicit Cargo setup waits up to 60 seconds per occupied admitted slot, while
offline checks remain immediate. The shared
[setup guide](local-setup.md#standard-cargo-tool-build-environment) owns the
wait-budget override and lock admission. The release editor retains its existing
`cli` feature without adding a library dependency.

Rust 1.99.1 is both the supported minimum and exact development/release compiler,
as approved in [#124](https://github.com/dragginzgame/ic-observability/issues/124).
Prepare it once with rustfmt, Clippy and `wasm32-unknown-unknown`:

```sh
make install-host-tools
export PATH="$PWD/.tools/host/bin:$PATH"
bash scripts/dev/prepare-rust-toolchain.sh --toolchain-file rust-toolchain.toml
make compiler-check
```

`Cargo.toml` owns the package floor; `rust-toolchain.toml` owns the exact compiler,
components and target. `compiler-check` requires these versions to agree and both
workspace members to inherit the floor. It records actual `rustc -vV` and
`cargo -vV` output and refuses failed observations, older/newer compilers, moving
channels and conflicting `MSRV` overrides. Checks disable Rustup auto-install.
Setup remains explicit and preserves the default toolchain. Help and unrelated
Make targets do not parse Cargo to choose a compiler.

`make msrv` remains a compatibility alias for compiler admission. `make ci`
provides the compilation proof once on this same compiler; see the coverage map
below. Both Metrics and Logging require Rust 1.99.1 on native and Wasm. The adopted
Shared Tooling baseline now owns this same compiler policy;
no local exception or temporary policy-reference override is needed.

Use Git, GNU Make, Bash 3.2 or newer and standard Unix utilities. The
[local setup guide](local-setup.md#bootstrap-prerequisites) owns system bootstrap,
installer dependencies and the pinned common host/Cargo-tool inventory. IC
executables remain explicit product selections for optional experiments.
The reviewed [Make interface](make-interface.md) routes common setup, formatting,
hooks and releases; product gates remain local.

```sh
make install-tools
make tools-check
cargo fetch --locked
export PATH="$PWD/.tools/host/bin:$PWD/.tools/rust/common/bin:$PATH"
make install-hooks
```

Setup is explicit; checks never install tools or unlock the selected graph.
Normal setup selects host and Cargo tools plus the release editor, with no IC
executables. For optional IC tooling, pass the same explicit `IC_TOOLS` selection
to `make install-ic-tools` and `make ic-tools-check`, such as `IC_TOOLS=wasm-opt`.
The full reviewed catalog remains intact, and previous IC bundles are retained.
The native version report uses its host/Cargo-only interface; failed setup still
retains full tool evidence, including existing unselected IC bundles.
Prepare the locked application sources before offline release-fixture checks;
common tool setup prepares different Cargo graphs. Native CI fetches explicitly
before `make ci`. A snapshot retirement leaves tracked deletions until committed;
source hashing deliberately refuses missing tracked files. Qualify that prepared
source in an isolated committed checkout without changing the real index, or run
against the committed tree. The selected-commit metadata fixture reads committed HEAD,
so its graph must also be prepared when local manifest/lock edits differ from
HEAD; a prepared working-tree graph alone cannot qualify that offline check.

Optional structural Wasm inspection follows the
[IC Host inspector guide](https://github.com/dragginzgame/ic-tooling/tree/main/apps/ic-host-wasm-inspect).
Experiments select their qualified published version, managed installation and
budgets directly. Metrics has no inspector wrapper, pin or Make targets; common
setup/check, CI, release preflight and the arithmetic library require no inspector.
Existing experiment sources, executable identities and artifacts remain frozen.
The reviewed snapshot owns default pins in `ci/tool-versions.env` and
`ci/ic-tools.tsv`; host, Rust and IC exceptions are independently selected
under the shared catalog contract. Use the same optional
`SHARED_TOOLING_STORE` setting for setup, checking and evidence collection.
Host/IC/Cargo paths select admitted shared generations; earlier sets and failed
candidates remain retained. Build-policy/compiler/native identity changes require
explicit Cargo-tool setup. Application flags and wrappers remain separate from
[the standard tool-build environment](local-setup.md#standard-cargo-tool-build-environment).

After Rust edits, run `make fmt`. It sorts workspace manifests and formats Rust;
`make fmt-check` is read-only. The common product gates cover both workspace
libraries; select direct Cargo commands when only one package or test is affected:

| Scope | Commands |
| --- | --- |
| Observability workspace | `make check check-wasm clippy docs-check test` |
| Focused library checks | `cargo check -p PACKAGE --all-targets --locked`; library Wasm: `cargo check -p PACKAGE --locked --target wasm32-unknown-unknown`; `cargo clippy -p PACKAGE --all-targets --locked -- -D warnings` |
| Named tests | `cargo test -p ic-metrics --locked <test-name>`; package doctests: `cargo test -p PACKAGE --locked --doc` |
| Logging | `cargo test -p ic-logging --lib --locked`; `cargo test -p ic-logging --doc --locked`; `cargo clippy -p ic-logging --lib --tests --examples --locked -- -D warnings` |
| Validated numeric transport | `cargo test -p ic-metrics --lib --locked --offline transport::tests` |
| Allocation-free arithmetic | `cargo test -p ic-metrics --lib --no-default-features --locked ratio::tests`; native/Wasm graphs exclude Wire and Platform under every feature selection |
| Minimal Serde and feature graphs | `make metrics-profiles-check`; runs Serde round trips/refusals, checks Metrics' native minimal, recording, default and all-feature Wasm normal/build closures, and checks dependency-free Logging once on native and Wasm |
| Log export recipe | `cargo test -p ic-logging --example byte-budgeted-export --locked --offline`; execute the walkthrough with `cargo run -p ic-logging --example byte-budgeted-export --locked --offline` |
| Recording model | `cargo test -p ic-metrics --lib --no-default-features --features recording --locked --offline recording::tests::model` |
| Logging operation model | `cargo test -p ic-logging --lib --locked --offline log::tests::mixed`; exercises journal-based state, paging and visitor stops across admission, retention and restoration |
| Histogram restoration oracle | `cargo test -p ic-metrics --lib --no-default-features --locked --offline histogram::tests::restoration`; exhaustive small-domain bounds/distributions and exact weighted overflow histories |
| Allocator-free arithmetic link | `make allocation-free-check` |
| Recording library checks | `cargo check -p ic-metrics --lib --features recording --locked`; Wasm: `cargo check -p ic-metrics --lib --features recording --locked --target wasm32-unknown-unknown`; lint: `cargo clippy -p ic-metrics --lib --tests --features recording --locked -- -D warnings` |
| Recording tests and examples | `cargo test -p ic-metrics --lib --features recording --locked <test-name>`; doctests: `cargo test -p ic-metrics --doc --features recording --locked` |
| Snapshot/pins | `make shared-tooling-check check-pins` |
| Local tools/hooks | `make tools-check hook-check` |
| Release/evidence adapters | `make release-tools-check ci-evidence-check` |
| Frozen evidence integrity | `make evidence-check` (checksums only; no replay or payload-privacy qualification) |
| Maintained docs | `make check-doc-links`, consistency review and `git diff --check` |

Default-feature commands above cover allocation-free arithmetic. Recording is
opt-in: include `--features recording` when selecting its tests, checks or examples.
A recording test-name filter without that feature can succeed with zero selected
tests; confirm that the intended cases actually ran.

Services own report DTOs, Wire metadata, generated clients and browser/runtime
qualification. Metrics maintains validated Serde, arithmetic and native/Wasm
graph admission. The [0.28 migration](../releases/metrics/0.28.md) retires
Metrics-owned Wire and TypeScript entrypoints, Node/npm setup and source/registry
pairing fixtures. Historical qualification READMEs and evidence retain their
original package identities; they do not qualify the current source.

For Logging's extended model exploration, run
`cargo test -p ic-logging --lib --locked --offline log::tests::mixed::long_utf8_histories_match_independent_event_history -- --ignored --exact`.
Fixed short histories and generated snapshot corruption cases remain in normal
Logging tests. The extended test is deterministic and reports its seed/text for
replay; it adds no dependency or performance measurement.

The exact prose allowlist in ci/docs-only-paths.txt enables Shared's conservative
classifier. Eligible prose runs real Linux docs/snapshot checks and records
skipped native scope. Unknown, mixed, policy/workflow and
missing-history inputs run full qualification.
A failed classifier job falls back to full product checks and remains visibly
failed. Packaged READMEs, embedded docs, companion declarations and new paths
remain full CI. No release gate uses the shortcut. Focused routing validation is
`make ci-selection-check`; `make package-doc-links-check` checks Cargo's actual
package file selection in staging that cannot borrow repository-only link targets.

`make allocation-free-check` links the runtime-input arithmetic example for
`wasm32-unknown-unknown`, with no standard library or global allocator. Linker
exports and dead-code retention keep the exercised arithmetic in the executable.
The check uses locked offline dependencies and this repository's `target/`;
CI runs it once on the pinned/support compiler. This is a link-contract check,
not an IC cost measurement. Each native job selects
`ALLOCATION_FREE_EVIDENCE_ROOT` to capture a successfully linked Wasm before later
checks. A failed link never captures an earlier target artifact. Standalone checks
select no additional copy; all builds use this repository's `target/`.

The former minimum/development duplication is consolidated as follows:

| Previous minimum-compiler proof | Retained Rust 1.99.1 proof |
| --- | --- |
| Minimal Metrics library | `metrics-profiles-check` compiles and tests the no-default-features Serde profile; allocator-free Wasm links separately |
| Workspace native all-targets/all-features | Native `clippy` checks all targets and `test` executes library, integration and example tests |
| Wasm workspace libraries | Wasm all-features library Clippy in each native job |
| Public doctests | Workspace all-features `test` executes both packages' doctests |
| Package archives | `package-check` prepares and verifies both package archives |

The native matrix still covers Linux x86_64, macOS x86_64 and macOS arm64.
Service owners retain browser/schema qualification. No required-check dependency in this
repository selects the retired `msrv` job. Optional installed-runtime evidence
retains its own tooling and scope. Historical evidence keeps its original compiler.
`make evidence-check` is also included in CI and
release validation. Five historical checksum manifests use archive-directory
paths; the Makefile records those working directories without rewriting receipts.
The gate checks distributed archives and retained inspection reports. Historical
source-hash receipts describe their original checkout, not today's source tree,
and are not compared with current files.

### Dependency roles and production graphs

The workspace owns independent Metrics and Logging libraries. Metrics has standard
numeric transport; Logging has no dependencies. The root catalog's
`Tests and tooling only` group selects `num-bigint` for the ratio
oracle, with default features disabled. It is inherited only by development
dependencies. IC Persistence owns stable-adapter graph admission and tests.

The root catalog uses Shared Tooling's grouped sort order.
`make fmt`, `make fmt-check` and hooks use that shared default; every release
adapter ordering check uses `--manifest-order-grouped` against its current or
selected committed source. No paired formatter override is needed here.

`make production-dependencies-check` admits both libraries through successful
locked, offline Cargo metadata. Metrics admits only required, unconditional Serde
without defaults and with `derive`. Local features may compose local switches,
never forward dependency features. The retired `native-wire` feature and all
Wire-family dependencies, including development inputs, refuse.
Logging admits no production dependencies, including Metrics itself.
Other normal/build dependencies are rejected, including optional and inactive
target-specific entries.
This constrains the production graph without
compiler-host discovery or repeated graph traversal. Development dependencies
remain separate; the existing direct stable-substrate prohibition applies there
too. Fixtures cover declaration axes, renamed dependencies, allowed development
use, transport placement/features, forwarded dependency features, failed Cargo
children and malformed/incomplete metadata. CI and release
verification use the same check.

IC Persistence owns stable-adapter dependency policy and qualification. Follow
[its guide](https://github.com/dragginzgame/ic-persistence/tree/main/crates/ic-metrics-stable)
for governed handles, collection identity and retained-data requirements.
This repository has no deployment entrypoint or final canister artifact;
applications qualify their own target, features and resolved dependency graph.
Role labels, formatting and `make check-pins` remain separate checks.

Keep compilation checks sequential when they share `target/`; check for active
builds before source mutation or compilation. Bare Cargo commands select both
libraries; use `-p ic-metrics` or `-p ic-logging` for focused work. Builds use
locked dependencies. Metrics requires only Serde for validated numeric records;
Logging has no dependencies. Neither owns platform readers or a server harness.
Stable storage qualification belongs to IC Persistence.
The inspector's CLI checks stay at IC Host; existing smoke artifacts under
`target/evidence/wasm-inspector/` remain retained historical evidence.

Formatting fixtures use Shared Tooling's current-source selector for maintained
Rust sources and Cargo manifests, including pending additions and deletions.
Metrics selects its arithmetic Rust entrypoint. Its single development dependency
has no pair to reorder, so the hook fixture uses Shared's explicit mode without
dependency-table perturbation. Generic manifest sorting remains qualified at
Shared Tooling; the local fixture retains Rust formatting, preservation, failure
diagnostics and installation checks. Failed nested checker evidence stays retained;
explicit non-Rust overlays remain local.
The shared locked release-preflight helper owns fetch/tool sequencing and pin
rechecks; Metrics admits source/recovery first and selects preparation authority,
tool targets and pin files. Checks remain offline and never install tools.

`ci/release-tools.env` selects published IC Build 0.73.0's
`ic-build-release-metadata` executable with its required `cli` feature and a
1 MiB allowance for each input document. This selects the current Host artifact,
filesystem and process implementations through Build's tool graph, without
adding library dependencies. Current manifests, lock and context are below
64 KiB. The shared managed installer owns its package/compiler identity and executable admission;
Metrics' small `release-editor.sh` adapter supplies only that selection.
`make install-tools` runs `install-release-editor` after common setup, and
`make tools-check` runs `release-editor-check`. Standalone targets are available
after host parsers are prepared. Standard release preflight prepares/checks the
editor before offline validation; standalone preflight only checks it. Metadata
preparation resolves its absolute admitted path without installation, then Shared
Tooling owns candidate preparation, validation and failure restoration. Missing
selections refuse before metadata mutation. The arithmetic library requires no IC Build.

The arithmetic library declares or imports no external IC-specific package and
needs no Platform dependency. There is no maintained Rust CLI, endpoint or messaging
codec to migrate to Clap or Wire. Tracked sources and actual package file lists
are reviewed for the no-symlink rule; managed tool-selection pointers and isolated
rejection fixtures retain their narrow exceptions. Frozen evidence keeps its
original source and dependency identities.

The Metrics profile matrix delegates resolved normal/build graph mechanics to
Shared's `scripts/ci/check-cargo-graph.pl`. Local code owns the four target/feature
profiles and package-count/exclusion rules. Logging has no feature matrix and is
checked separately once on native and Wasm; declaration admission remains a
separate guard that refuses every Logging dependency. `bash scripts/release/test-retained-consumer.sh`
verifies parsed Cargo projection across multiline manifests, quoted strings and
retained consumers' real supplier versions while preserving other catalog fields.

## Full release validation

Focused checks for changed behavior and directly affected callers are sufficient
for ordinary handoff under [the validation policy](../DRAGGINZGAME.md#validation-and-evidence).
Run full local suites only for an explicitly authorized release or an explicit
request for those checks. The full gate is `make ci`, then workspace-native/Wasm `make msrv`; reuse passing evidence only for unchanged inputs. Full CI
admits tools, pins and formatting before the native/Wasm Clippy gate. Clippy
denies warnings and runs before test suites, documentation builds and dependency
qualification fixtures. The complete gate checks both workspace libraries' builds,
docs and tests. The retired TypeScript job has no enforced required-check
reference on main; native CI retains its three hosts. Strict native all-target and Wasm library Clippy supply
CI type checking; `make check` and `make check-wasm` remain focused entrypoints.
The workspace currently contains two libraries. If other Wasm targets
are added, extend the Clippy target selection to preserve their CI coverage.
Inspection and documentation-only work use narrower
checks. [AGENTS.md](../AGENTS.md) retains product constraints and separate release
and publication authority.

Release and publication use separate commands under
[the release contract](releases.md). A scoped ship/deploy request can authorize
both through [delegated delivery](../rules/contributions.md#delegated-delivery).
Normal release commands start fresh from
clean committed metadata without scanning or replaying historical plans.
Select `RELEASE_GROUP=metrics` or `RELEASE_GROUP=logging` explicitly; see
[independent releases](independent-releases.md) for the version/ledger map.
Use `make release-resume RELEASE_GROUP=logging VERSION=X.Y.Z` for recovery of a
specific saved Logging attempt.
Standard release preflight first runs `setup-smoke-check`. Release validation
runs the complete `ci msrv` gates. Neither group requires Node/npm tooling.
The Make smoke parses the actual consumer and tests exported publication-mode
overrides, then deliberately stops before metadata, compiler or upload recipes.
Native CI runs it before tool installation on all three declared hosts, including
macOS's system Make. To qualify another already prepared Make binary directly,
run `bash scripts/ci/check-setup-smoke.sh /absolute/path/to/make`; this does not
install or select another workspace tool. A Linux parser check does not establish
native macOS execution. Standard preflight otherwise prepares the
locked dependency cache, common Cargo tools and the selected release editor before offline validation;
standalone preflight only fetches/checks offline. Preparation and late checks
bind the selected release commit rather than newer working-tree metadata.
Late metadata checks use Shared's `--manifest-order-grouped` option to check ordering
in that same selected source; literal version preparation never sorts it.
Neither validation nor release performs artifact cleanup.
With no operator overrides or filters, plain `cargo clean` removes this workspace's
entire `target/`, including nested build outputs and retained evidence. Evidence
that must survive an explicit clean belongs outside `target/`. Managed `.tools`
selections, separate tool stores and Git-owned release journals are outside that
Cargo cleanup scope. The repository does not redirect Cargo's default target.
The [shared publication Make adapter](cargo-publication.md#opt-in-make-adapter)
owns `make publish` and `make publish-check`. This consumer includes that adapter
directly, declares `crates-io` and `clippy`, and projects the selected group's
public roster only after group admission. Unrelated Make commands do not resolve
publication eligibility. The same native/Wasm Clippy gate runs before Cargo packaging or
registry effects, including under parallel Make. Publication retains its own
command and receipts; established delivery authority does not require repeated
per-command confirmation. Selection and attempt evidence stays under `target/publication`.
Readback also compares the complete maintained package roster and file contents,
including Cargo.toml.orig, against the freshly retrieved release commit. Cargo's
generated Cargo.toml, Cargo.lock and provenance JSON retain their existing
packaging/provenance checks; they are explicitly outside that byte comparison.
Verification never extracts the remote archive into a filesystem. Unexpected,
duplicate or non-regular members refuse, and a failed readback never retries an
upload. The local archive-content policy requires all tracked package files to
be shipped; deliberate future Cargo exclusions must update that policy explicitly.
`bash scripts/release/test-publication-policy.sh` checks archive-content refusals
directly against retrieved source, plus a complete tampered readback with matching
checksum/provenance. Its registry responses and remote repository are local fixtures.

Both commands require an explicit group; missing, empty and unknown selections
refuse before setup, validation or mutation. A `PACKAGE` override must belong to
that group and never selects it implicitly. Group release tags advance only
the selected version, without uploading either package. The focused publication
Make fixture checks explicitly selected Metrics and Logging rosters and
both exact lint-failure boundaries before delegation. Shared Tooling owns generic
selection, metadata, upload-status and retained-attempt fixtures. Local effects
are substituted and do not publish packages.

## Native evidence

Native host admission uses Shared's read-only validator with the local matrix's
OS, architecture and explicit macOS major. Failed observations refuse before
local PATH changes; the portable fixture does not establish native macOS support.

The workflow captures exact source inputs and host/compiler identities before
setup, records setup/check/native outcomes and keeps stdout/stderr on failures.
The Make smoke step has its own setup_smoke outcome in both diagnostic and
recovery archives, including success, failure and skipped states. A failed smoke
keeps its stdout/stderr log and prevents later setup/compiler steps.
Tool candidate selection preserves admitted failed inputs and diagnostics;
collection failure remains nonzero. Formatter logs outside the fixture scratch
root are included. Uploads retain `native-ci.tar.gz` and its checksum for 30 days,
including hidden release/index/configuration evidence inside the outer tar.
A separately uploaded `native-diagnostics.tar.gz` and checksum contain only
explicit available top-level logs and source/tool/outcome identities. No tool
payload, source tree, scratch directory or nested archive is selected. It is
collected before the complete archive so full collection failures still leave
readable diagnostics; neither archive silently truncates selected logs.

Shared Tooling owns generic installer, formatting, metadata, release-engine and
fixture mechanics. Its [producer/consumer boundaries](verification-helpers.md#producer-and-consumer-fixture-boundaries),
[flow qualification](verification-helpers.md#consumer-flow-qualification),
[retention probes](verification-helpers.md#consumer-fixture-retention-probes) and
[hook checker](verification-helpers.md#consumer-formatting-hook-adoption) describe
those contracts and producer tests. Metrics verifies its reviewed snapshot and
actual callers; it does not replay those generic matrices in its own gates.

| Local entrypoint | Metrics-owned qualification |
| --- | --- |
| `make release-tools-check` | Separate release/publication Make dispatch, grouped release admission, hook and failure/custody fixtures. The actual group adapter, renderer and runner exercise local Git releases, exact staging/commits, rollback, receipts/resume, publication selection and consumers pinned to the unaffected identity. Broad gates and registry uploads are substituted. |
| `make hook-check` | Standalone hook adoption; the actual baseline formatter failure must retain and replay its diagnostic log. |
| `make ci-evidence-check` | Source selection/hash inputs, actual workflow setup bodies, collector wiring and direct collector/recovery-packager execution with substituted external effects. |

Retention is the single CI entry for release, publication and hook bodies. Each
full success route runs once; publication-specific child/assertion failures run
only its focused fixture, keeping unrelated release checks out of those probes. The admission fixture isolates inherited parent
validation/failure logs and summaries. Each group checks source and tool refusal,
failed validation, transactional rollback, wrong-group/altered receipts and
resumption after a real disposable commit/tag. Successful grouped inputs and
receipts remain retained alongside failed inputs under caller-selected `TMPDIR`,
defaulting to native CI evidence. The publication fixture owns its assertion-failure
case and retained-input checksum manifest; the parent verifies both. External
command failures and nested hook logs remain separately checked. These fixtures
perform no release in the maintained checkout or registry publication and do not
qualify hosted execution.

`scripts/release/metadata.sh files` projects the shared admitted group's exact
NUL-delimited file plan through `make release-files`. Plan admission uses the
prepared parsers and locked offline Cargo metadata. Consumer fixtures retain
unsafe Make-mode refusal before effects, explicit tool-catalog routing and
selected-source checks. The old coordinated metadata/admission helpers have been
replaced by the actual grouped integration fixture.

Native input selection includes pending maintained files, excludes generated and
private evidence, and keeps missing tracked source selected so hashing refuses
an incomplete checkout. The native-evidence fixture checks thin workflow wiring,
then directly runs the owned source-input recorder and collector. Scenario inputs
and expected boundary statuses stay together; archive assertions retain separate
sanitized-diagnostic and full-recovery contracts. It covers unusual filenames,
OS/architecture/macOS admission, TOML-selected compiler/components/targets,
failed setup and action-outcome/log projection. Substitute rustup/Make actions
establish routing and failure propagation, not native macOS or live release proof.

Metrics owns `scripts/ci/package-native-recovery-evidence.sh`, including the full
scratch tree, hidden Git recovery state and top-level checksum inventory. Its
round-trip fixture checks payloads, containment, occupied destinations and retained
inputs/partial output after inventory, tar or checksum failure. The workflow
publishes sanitized diagnostics first; fatal collector status stops the outer
archive, while partial collection keeps that archive and remains nonzero.
Readable diagnostics must survive an outer-archive failure. Formatter logs outside
scratch and failed/skipped tool setup remain covered. Both uploads disable ZIP
compression for their gzip payloads; archive/checksum pairing and 30-day retention
remain unchanged.

### Compiler evidence

The native job records compiler admission in `target/evidence/native-ci/compiler.txt`
before managed-tool preparation or application compilation. Its outcome is
included in diagnostic and recovery archives, including partial output on failure.
The allocator-free Wasm is retained inside the full native recovery archive after
a successful link. Historical TypeScript, source and registry probes retain
their original compiler receipts. Existing historical
`msrv-ci` evidence is preserved; new runs no longer produce a duplicate archive.

`make compiler-policy-check` exercises policy mismatches, failed executable
observations and successful/failed link custody with substituted compiler effects.
`make ci-evidence-check` executes retained workflow bodies and proves compiler
failure prevents later tool/application effects while keeping its partial log.
These local fixtures do not establish hosted native passes.

[Released 0.8.1 acceptance](evidence/release-081.md) verifies all three native
receipts and the complete Rust-floor run on its exact published source.
[The current handoff](status/current.md) binds pending work to separate local
qualification. Earlier host/reader/release observations remain in their evidence
owners and the verbatim guides retained by [the cleanup receipt](evidence/cleanup-082.md).
They are not current platform readers, validation commands or acceptance of a
later dependency graph. Actual IC execution and callback attribution belong to
the owning consumers under [the extraction contract](extraction.md#downstream-contract-checks).

`make package-check` builds and verifies both workspace package archives offline.
IC Persistence owns stable-adapter compilation, tests and archive qualification.
It allows pending source changes for review, never uploads, and runs after
Clippy in CI and again after release metadata preparation before staging.
Prepared dependency sources are required; it does not install or update them.
