# Shared Tooling adoption and repository rule audit

Date: 2026-11-05. Trigger: the maintainer requested latest Shared Tooling adoption,
the LOC directory naming hard cut, a complete allowance review and a repository
best-practice audit. This report records inspection and focused local execution,
not release or deployed qualification.

## Identities and verdict

Observability base: `423ddd4c845769bf742b515ba814e393f55dbfff`. The original dirty
inputs were lowercase Cargo catalog comments and the #130 ownership handoff;
both are preserved. Source, tooling, examples, maintained test/fixture generators,
Cargo declarations and normal CI/release/publication callers were in scope.
Sibling checkouts, private sibling evidence, frozen archive contents and generated
or ignored historical build/npm artifacts were excluded. No sibling was edited.

Reviewed Shared source: clean main `07dce12cbe4a798fd4a6d263095518678c4f6b45`,
VERSION 0.30.0, matching `origin/main` through `git ls-remote`. The committed
changelog still says Unreleased; this is a committed-main adoption, not proof of a
published tag. The prior snapshot was 0.29.4 at
`628ccc75d813bfd9bae777bfbaef55838d25b1b2`. Canonical preview/export selected the
existing entrypoints and added the required LOC classifier; all 150 files verify.
No vendored payload or snapshot record was edited manually. Tool catalogs and
retained Cargo dependency versions did not change.

Methods: the adopted `audits/README.md` and `audits/code-hygiene.md`, with
`tasks/snapshot-drift.md` and actual caller tracing from
`tasks/tooling-duplication.md`. The local overlay is `AGENTS.md` at the source
base plus this batch's clarification of the closed producer issue.

**FAIL for complete adoption:** the normal repository documentation check has
four missing targets introduced by the producer's exported documentation.
[Shared Tooling #355 — Complete exported documentation closure for LOC classification and audit guidance](https://github.com/dragginzgame/shared-tooling/issues/355)
owns that repair. Local layout, lint and publication corrections pass their
focused checks; no library behavior defect was identified by this hygiene review.
This does not establish a security, performance or full semantic correctness audit.

## Applied corrections

- Moved the allocator-free recording link fixture into
  `crates/ic-metrics/tests/allocation-free/link.rs` and declared its LOC role as
  tests. Its bytes, Cargo example name, check command and retained Wasm identity
  are unchanged. `link.rs` avoids automatic discovery as a second integration
  target; metadata confirms exactly one fixture target, of kind example.
- Updated retained supplier copying for the actual `src`, `examples` and `tests`
  inputs. The generated consumer package is explicitly private, inherits the
  compiler floor and declares its fixture-only test role. Its public recording
  and persistence contracts still execute for both independent suppliers.
- Exported publication's explicit group scope to the actual native/Wasm lint
  commands. Both groups now lint their selected package, retaining all targets,
  features, strict warnings and fresh publication source admission. Independent
  expected command traces cover both lint-failure boundaries and upload/readback
  stopping. Full CI still forces workspace scope; missing or uncertain release
  mappings retain their complete gate.
- Updated current host guidance, command help, local ownership wording and the
  two group drafts. No package version, lock selection, public API, durable format,
  artifact cleanup, commit, release or publication changed.

## Rule coverage and retained decisions

Every current rule family was reviewed for applicability. This is a static and
caller-wiring review except for the focused execution listed below.

| Rules / principles | Actual owner and result |
| --- | --- |
| Baseline, contributions and agent maintenance | Work remains in this checkout, preserving dirty inputs, index/refs and artifacts. No release authority was inferred. #130 is closed for producer work; consumer acceptance remains owner-local. One producer documentation issue was filed, with no consumer waiting issue. |
| Rust workspaces and Cargo inheritance | The virtual root owns both members, their full path/version catalog, independent group membership and two canonical ledgers. Edition 2024 and compiler 1.99.1 remain inherited. Root has no aggregate version; neither package depends on the other. New fixture metadata is explicit. |
| Cargo roles, graphs and Platform boundary | Only development dependencies are selected. Actual declaration admission passes. Metrics and Logging retain no production dependency, Wire/Platform runtime, endpoint or stable-memory integration. No dependency upgrade was needed. |
| Dependency pinning and catalogs | Tracked lock and exact compiler remain unchanged; immutable external action pins and local catalog callers pass `check-pins`. Common tools and the selected release editor use the reviewed managed owners; offline admission succeeds without setup/download. No active npm package remains in the tracked source. |
| Rust hygiene: modules, tests and LOC | Ordinary module discovery is retained. No singular `test/` or `test.rs` source owner, path attribute, test-body relocation alias or unresolved source role remains in maintained workspace Rust. The linker fixture is explicitly tests despite its historical example target. No package/workspace is moved merely for counting. |
| Rust hygiene: lint suppressions | Reviewed maintained Rust, shell/Perl generators, Cargo lint tables and command-line configuration. No Rust `allow` suppression exists to convert, including conditional or generated attributes. No unfulfilled-expectation suppression was added. `forbid(unsafe_code)` remains; shell/publication `--allow-dirty` is not a lint level. |
| Errors, visibility and native interfaces | Public recording/restoration errors stay typed. Dependency-free `no_std` errors retain manual core Display/Error implementations; adding thiserror would violate their purpose. No new production panic, raw FFI, widened visibility or string-based Rust error decision was introduced. Test/example assertions remain scoped to fixtures. |
| Source injection and generators | Maintained Rust includes embed Markdown documentation only. Retained consumer code is ordinary Rust test source copied into fixture packages. Synthetic compiler/scanner inputs and shell command substitutes are qualification data; they do not patch generated application entrypoints. |
| Hooks and formatting | Shared `consumer.mk` owns grouped manifest sorting and Cargo formatting; the two retained standalone contract sources remain explicit inputs. Formatter admission/check passes. No independent formatter, implicit installation or hook/index mutation was introduced. |
| CI, host support and validation | One roster drives full CI and selected release plans. Native/Wasm/package selection reaches the relevant commands. Publication's workspace lint mismatch was fixed. Actual supported Linux, Intel macOS and ARM macOS jobs, bootstrap-before-tool setup and retained failure evidence remain configured. No full gate or new host claim is implied by this audit. |
| Release, reuse, changelogs and reporting | Direct delivery and explicit RELEASE_GROUP remain required. Read-only real file-plan admission passes for both groups. Existing exact-input/custody mechanisms remain; final-candidate reuse is optional and unqualified here, so no local cache or version normalization was added. New tooling notes select patches independently and retain finalized history. |
| Artifacts, filesystem and provenance | No tracked symlinks, artifact cleanup, new external path dependency or private evidence export was introduced. Existing Git recovery state, stashes, ignored historical installations and receipts retain custody. Package documentation checks admit actual maintained file selection. LOC is source inventory, not IC instructions/cycles or a Wasm/performance claim. |
| Metrics/logging, stable memory and RPC budgets | Passive heap logging, application recorders and explicit persistence admission preserve the extraction boundary. Hosts/adapters own storage, clocks, authorization and endpoints. The workspace has no owned RPC/client generator, stable store, native OS adapter or gzip application codec requiring a new integration. Historical qualification is not current adoption. |
| Simplicity, decision artifacts and reviewable changes | Reused the canonical exporter, LOC metadata and existing group selector. Scope is carried to leaf lint commands rather than re-inferred. No new framework, compatibility alias, duplicate dependency catalog or fleet migration was created. |

The only final LOC diagnostic is the linker fixture's conditional no_std/no_main
attributes. These are necessary for native tooling versus an allocator-free Wasm
link and are covered by actual native Clippy plus the real Wasm link. They do not
hide a singular test path or unclassified source. Schema-2 totals reconcile to
4,438 code lines: 1,296 application/library, 3,003 tests, 139 examples, zero
benchmarks/tooling/unclassified. The same source had 49 fixture lines classified
as examples before this correction. This is a role correction, not code deletion.

## Findings and remaining boundary

**MEDIUM — incomplete shared documentation export.** Four exported documents now
link to absent `docs/fleet-tools.md`: consuming snapshots, local setup, Make
interface and Rust hygiene. The canonical export/verifier succeeds, while normal
`make check-doc-links` fails with those exact four targets. The full fleet guide
also has central stack links, so merely importing it would pull unrelated fleet
inventory unless its own documentation boundary is addressed. #355 owns the
minimal producer repair and exported-closure regression. Vendored prose is kept
intact and the failure is neither filtered nor relabelled as a pass.

Cross-group release-stage reuse remains deliberately unqualified and disabled.
The existing conservative full gates are permitted by the new rule until a
bounded reuse contract is explicitly adopted and qualified. This review does not
invent that release optimization or execute a full matrix to promise savings.

## Focused evidence

Linux x86_64; actual Cargo/rustc 1.99.1 admitted by the allocator-link adapter.
Commands/logs, JSON inventories and export preview are retained under
`target/shared-tooling-0300/`; the historical linker source is also retrievable
from the exact base above. No lasting implementation exists only in scratch.

| Check | Result / scope |
| --- | --- |
| Canonical snapshot preview/export and verifier | 150 files verified at the exact revision; no supplier edit |
| `make fmt`, `make fmt-check` | Pass; root Cargo diff still contains only the pre-existing comment casing |
| Metrics Clippy, native all targets/features and Wasm library | Pass, `--locked --offline -- -D warnings`; earlier duplicate-target warning logs retained, corrected by the final fixture filename |
| `make allocation-free-check` | Real locked allocator-free Wasm link passes; same Cargo/artifact identity |
| `test-release-admission.sh --consumers-only` | Both real public consumer contracts pass; final mandatory-source-copy check retained at `target/observability-release-groups.XnZFez/`, earlier inputs at `target/observability-release-groups.SZNQa4/` |
| LOC workspace JSON/Make table and generated consumer JSON | Schema 2 reconciles; zero unclassified; fixture is tests; generated client contributes tests and zero library code |
| Cargo metadata and old/new fixture byte comparison | One explicit example target; fixture body unchanged |
| `test-publication-make.sh` | Pass; Metrics/Logging selected commands, native/Wasm failures, parallel routing and upload/readback stopping use substituted external effects |
| `test-validation-plan.sh` | Mapping, shared proof custody, fallback and recovery pass with substituted stages; matched native comparison not run |
| `make tools-check check-pins` | Prepared common/selected tool admission and declarations/lock inheritance pass |
| `make release-files RELEASE_GROUP=metrics` / `logging` | Real grouped catalog/file plans admitted read-only |
| `check-production-dependencies.pl` | Dependency-free production declarations admitted |
| `check-package-doc-links.pl` | Actual Cargo-selected package documentation passes for both packages |
| Shell syntax, local audit/host/handoff references and diff hygiene | Checked without changing source/index or shared payloads |
| `make check-doc-links` | FAIL: exactly four shared targets above; producer issue #355 |

Full `make ci`, release preparation, package publication, matched native gate
qualification and hosted/macOS execution were not run. No changed product
arithmetic, encoding, storage or runtime contract required an installed sibling
qualification. Broad missing release/host evidence is not a code-check pass and
is not the cause of the concrete documentation failure.
