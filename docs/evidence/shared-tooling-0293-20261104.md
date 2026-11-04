# Shared Tooling rules and Rust test layout — 2026-11-04

This is a local adoption and focused consumer qualification, not a release or
three-host CI receipt. Package versions stay Metrics 0.29.0 and Logging 0.24.5.
Pending compatible notes are Metrics 0.29.1 and Logging 0.24.6.

## Exact supplier selection

The canonical exporter adopted committed Shared Tooling revision
`1fa2d90879650780d23ad8f045f5825771b696ad`, whose committed VERSION is 0.29.3.
The revision was verified against remote main. Its changelog remains Unreleased;
the latest observed release tag was v0.29.0. This receipt does not claim that
Shared 0.29.3 is tagged or published.

The first reviewed main was `afccb9947d26bbae13d4c4a143d2fd5f0c2c07a4`; while
this work ran, the supplier added the classifier fix in `bab19281`. Its change
was reviewed and exported. The next requested refresh selected `1fa2d908`, whose
only further payload changes are checkout-location rules in the baseline and
contribution guide. That committed revision matched remote main; the supplier's
uncommitted 0.29.4 draft was excluded. Earlier previews/exports are retained under
`target/shared-tooling-0293-20261104/`; the latest preview, export and 148-file
integrity check are under `target/shared-tooling-0293-refresh-20261104/`.
No supplier file, branch or index was changed.
Tool catalogs and compiler policy are unchanged, and prepared tools were admitted
without reinstalling. Cargo.lock and package manifest versions are unchanged.

## Changes from the new rules

The shared [test-layout rule](../principles/rust-code-hygiene.md#tests) prefers
Rust test bodies/support under `tests.rs` or `tests/`, with ordinary module
resolution and private access. The review found two remaining inline modules:

- `crates/ic-metrics/src/window/mod.rs` now wires `window/tests.rs` with only
  `#[cfg(test)] mod tests;`.
- Logging's export example now uses
  `crates/ic-logging/examples/byte-budgeted-export/main.rs` and adjacent `tests.rs`.
  The directory entrypoint keeps normal module discovery for the example crate.
  Cargo still declares `byte-budgeted-export`; existing commands are unchanged.

The extracted bodies, assertions and names exactly match the committed originals
after removing their former indentation. The production text exactly matches its
original apart from test-module wiring and the example entrypoint location.
No visibility was widened, `#[path]` added or test-only production branch created.
Other library tests and integration tests already use the preferred paths.
Executable API documentation remains beside the API, as the rule explicitly allows.
File-based test LOC still treats doctests and generated fixture source separately;
no new LOC counter or structural test gate was added.

The continuation reviewed the repository-owned generators too. The release
fixture's two public supplier clients now put their test bodies under
`client/tests/contract.rs` with empty library entrypoints. Both default release
qualification and the focused `--consumers-only` entry execute `--test contract`,
preserving the assertions and public-only access. The focused entry constructs
and tests both workspace-owned copies before any release-editor, Git transaction,
publication sentinel or recovery scenario setup. It preserves the frozen lock
bytes and leaves the complete no-argument qualification intact. The native
Logging fixture uses `std::num` consistently with its standard-library client.

Shared's Metrics instrumentation boundary now matches this repository's 0.29 cut;
the overlay refers to that common owner while retaining its concrete API/storage
safeguards. The catalog already puts local release groups before external test
inputs, and the root changelog already remains a navigation index with issue
coverage in owning group ledgers. No extra index or dependency changes were needed.
The stricter dependency-free product policy is retained.

The newer classifier imports its declared StableVersion companion. The consumer
CI fixture now uses `prepare-script-fixture.sh` instead of copying only two files,
so the actual classifier's dependencies follow their shared owner. Observability
retains its strict prose allowlist and full fallback. Shared's optional root
VERSION-bump shortcut stays disabled: this workspace owns independent Cargo groups
and has no aggregate VERSION.

The remaining compiler-policy and publication-policy fixture loaders now use the
same resolver for their explicit roots. The local allocator-free link checker
declares its compiler/Make helpers, and the compiler checker declares its floor
reader, so dependency knowledge stays at the caller. Explicit product inputs,
synthetic tools, the publication metadata stub and the independent native-source
selector fixture remain intentional substitutions rather than dependency copies
to merge. No Shared-owned payload was edited to make those fixtures pass.

Five repository-owned standalone fixtures now default to `target/qualification`:
production dependencies, native source selection, native recovery archives,
formatting hooks and standard release dispatch. Explicit `TMPDIR` selections
retain precedence. The existing lifecycle helper still owns successful cleanup,
exact failure propagation and retained inputs. Shared-owned helpers and the native
collector's workflow-protocol temporary root were left intact. No existing evidence
or unrelated artifacts were removed.

## Focused evidence

- Snapshot verification: 148 files at the final revision; tools and dependency pins pass.
- Native Clippy, warnings denied: Metrics library/tests with all features, and
  Logging's affected example.
- Runtime: both named reset-window tests, all four export tests and the export
  walkthrough pass. Cargo metadata retains exactly the existing example targets.
- Package file selection includes the example's `main.rs` and `tests.rs`, with
  updated repository/package links. Documentation and formatting checks pass.
- Grouped metadata admission passes for both current groups and a selected
  committed source. A controlled formatter refusal returns its exact status 37,
  before graph admission or mutation.
- The existing consumer full/selected mapping, shared evidence-custody and
  recovery qualification passes. The final classifier-only supplier increment
  does not change those release/evidence executables, so that evidence is reused.
- The actual CI selector fixture passes prose, source/mixed, policy, missing-history
  and failed-classifier cases through the final snapshot's companion closure.
- The generated Metrics and Logging integration contracts each ran one test and
  passed through `test-release-admission.sh --consumers-only`. Shell syntax and
  ShellCheck (following the existing helper) pass; unknown options refuse before
  fixture creation. Evidence is under `target/shared-tooling-0293-20261104/continuation/`
  and `target/observability-release-groups.9rh0U4/`. The complete release/recovery
  scenario suite was not replayed for this generator-only continuation.
- Compiler-policy and publication-policy fixtures pass after their loader changes.
  Compiler refusals and link custody retain the same cases; publication admission,
  archive tampering, registry uncertainty and provenance use the existing local
  substitutes. Shell syntax and ShellCheck pass for the affected scripts. Logs
  remain under `target/shared-tooling-0293-20261104/fixture-loaders/`.
- All five scratch-default fixture bodies pass with `TMPDIR` unset. Bash syntax
  and ShellCheck pass. Existing prefix-only lifecycle probes independently check
  all five initialization/EXIT boundaries with an explicit `TMPDIR`: status 23
  and its payload are retained, while completed success removes only its inputs.
  These probes do not replay fixture bodies or the full release-retention matrix.
  Logs and failed-probe payloads remain under
  `target/shared-tooling-0293-refresh-20261104/fixtures/`.

The last supplier increment changes governance only. Prior executable, compiler,
runtime and release-mapping evidence above remains applicable to unchanged inputs.

## Further fixture cleanup

The next authorized batch keeps the same Shared snapshot and changes only local
fixture inputs, selection and formatting wiring:

- The retained Metrics/Logging test bodies now live in
  `scripts/release/fixtures/retained-consumer/tests/`. Both execution paths copy
  them into the existing generated integration target. Their contents exactly
  match the former heredocs after applying Rustfmt. The root Makefile selects
  both through Shared's standalone Rustfmt interface.
- `test-native-evidence.sh --scenario NAME` runs one recovery row from the same
  15-row roster, with common source/workflow wiring checks. The no-argument entry
  retains the full roster and standalone host/compiler setup checks. Invalid
  arguments refuse with status 2 before fixture allocation. The scenario rows
  and independently specified expectations match their pre-edit originals.
- Synthetic dependency suppliers are created once when first required, rather
  than recreated for every workspace case. Only the Serde substitute needs the
  `std` feature for the existing dependency-feature forwarding refusal. Other
  unused transport features were removed; declaration/refusal cases are unchanged.

The first selected native run exposed the fixture's use of the live Git index
with a pending source deletion. Its evidence is retained at
`target/evidence/native-ci/native-evidence.uLATw3/`. The fixture now prepares its
own temporary index from HEAD and removes only paths missing in the maintained
worktree. Pending source copies/untracked inputs remain included, while missing
copied inputs still fail hashing. The maintained source selector and live index
were not changed. This is local fixture qualification, not hosted acceptance.

Focused checks pass: `make fmt`, the two generated consumer tests, all dependency
admission/refusal cases, formatting/hook preservation and failure checks, Bash
syntax and ShellCheck. The selected `collection-archive-failure` case passes at
`target/evidence/native-ci/native-evidence.YCXtSw/`; the no-argument native fixture
passes all 15 cases plus its setup checks at
`target/evidence/native-ci/native-evidence.lHBYe4/`. Four malformed/unknown selector
checks return status 2. Logs, original fixture copies and formatted source
comparisons remain under `target/fixture-cleanup-20261104/`.

No producer regression matrix, full workspace CI, MSRV duplicate or hosted/native
matrix was run for this local adoption. Existing source-bound publication and
recovery receipts keep their original snapshots. No sibling acceptance, commit,
push, version bump, release or publication is claimed. The user's existing
lowercase Cargo catalog comments remain untouched and unstaged.
