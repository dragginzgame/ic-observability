# Contributor tooling

The current local selection is crates.io toko-tooling **0.37.5**, pinned once
at the root and inherited as a dev-dependency by both real packages. Cargo.lock
and `.toko-tooling.snapshot` select archive SHA-256
`9fc1a752f4f8203d999c4cd593afb9ea18717b28d407492fc98aab5722526be3`.
Authenticated preview preserves all 99 roots and 169 payload files. Only the
Cargo boundary checker and its owning dependency guide change from 0.37.4.
The new allowance is limited to unconditional Candid dev-dependencies of the
unpublished `ic-wire-benchmarks` package; neither Observability package is that
owner. Both remain subject to their existing external-dependency and zero-
allowance Candid/CBOR source gates. Focused validation selects their actual
`cargo-boundaries-check` and `candid-boundary-check` Make callers alongside
installation, tooling admission, pins, formatting, links and diff checks.
Other caller qualification remains applicable to unchanged inputs. Cargo changes
only the tooling selection; the API fix and deferred syn selection were
preserved. Focused evidence is under `target/evidence/toko-tooling-0375/`.
The accumulated adoption is delivered with Metrics 0.29.9 and Logging 0.24.14;
the [release receipt](releases/omission-toko0375-20261109.md) records both full
20-stage gates, registry readback and deferred-lock custody.

The preceding 0.37.4 refresh explicitly retained engineering and RPC guides for
offline links when the baseline became standalone. It preserved all prior 97
roots, added those two roots and changed five policy/guide files. Executable
payloads were unchanged; evidence remains under `target/evidence/toko-tooling-0374/`.

The adoption review applies binding rules without exceptions or alternative
defaults. Independent package boundaries, product bounds, commands, hosts and full
release gates remain consumer-owned choices. The baseline's detailed references
are pinned to `626da7cd9626cc2e152594862a2d82ea82ef51da`; packaged dependency guides
also reflect the new core rule to select latest stable direct dependencies during
authorized scoped maintenance. No unrelated dependency update or audit is needed.

The preceding 0.37.2 authenticated refresh changed no payload bytes. Its admission
and LOC evidence remains under `target/evidence/toko-tooling-0372/`. The observed
5,490 lines include the pending omitted-only API fix and have no unclassified LOC;
the earlier 0.37.1 observation predates that fix.

The preceding 0.37.1 released-package installer previewed the migration against the prior
0.36.1 receipt, then authenticated and exported all 97 mapped roots and 169 files.
Unchanged old baseline/helper payloads retired through the exporter. The receipt
was moved only after refresh and admission succeeded; no hashes were edited.

The baseline is `TOKO-TOOLING.md`, commands use `toko-tooling-*`, and tooling
variables and LOC metadata use the Toko namespace. CI, custom deployment checks,
source selection, release fixtures and generated consumer metadata follow that
contract. There are no compatibility aliases. Historical receipts/source diaries
and their recorded commands remain historical; generic upstream helper names
such as `shared-companions.sh` retain their canonical producer filenames.

Installation and tool admission pass. Offline member/pin/lock/snapshot admission,
dependency pins, formatting and documentation checks pass. The normal root is
still virtual with two real packages; no carrier crate or Rust import was added.
Cargo changed only toko-tooling relative to the incoming graph; the pre-existing
syn 3.0.10 edit is preserved. Product versions and the complete 20-stage release
roster remained unchanged during adoption apart from the renamed tooling admission
stage. Metrics 0.29.9 and Logging 0.24.14 ledger entries are now finalized by their
subsequent releases. The 0.37.1 caller evidence is under
`target/evidence/toko-tooling-0371/`; full release qualification belongs to the
linked delivery receipt. No sibling mutation is implied.

Focused consumer checks also pass: matched full/group validation traces, actual
Make release routing and unsafe-mode refusals, custom drift refusal before
effects, publication policy with uploads substituted, generated public consumers
and their LOC roles, formatting-hook preservation/installation, CI selection,
native receipt/source selection and the selected native-evidence success row.
The dispatch fixture exposed the compiler gate's former reliance on global Make
admission; the consumer now explicitly protects compiler/Cargo and metadata
recipes under the upstream recipe-scoped guard. Diagnostic help dry runs remain
available. Existing native macOS and installed consumer acceptance are separate.

Earlier 0.36.1 local installation and unchanged LOC inventory/totals checks retain
their original evidence under `target/evidence/toko-tooling-0361/`.

## Previous 0.36.0 adoption

The 0.36.0 adoption selected crates.io toko-tooling through one exact root
workspace dependency and unconditional inherited dev-dependencies in both real
packages. Cargo.lock and the snapshot bind archive SHA-256
`de0dd05b6437061622a76942baa25d40d2181497e7ba66d9fd809132a3082936`.
All 97 roots are preserved; 168 installed files were exported from the authenticated
registry package. Managed installation and tool checks passed.

The 0.34 metadata/dedicated-lock scheme is removed, with no selection-only package,
new import or release-group member. Cargo.lock adds only toko-tooling and the two
dev edges. Every member carries the cargo-machete exemption; a narrowly documented
exact-pin exception satisfies the generic pinning gate. No unrelated dependency,
compiler/tool pin changed. Deployment subsequently released Metrics 0.29.7 and
Logging 0.24.12 because their public manifests changed. Both passed complete
20-stage workspace gates, Git delivery and verified registry publication; the
[delivery receipt](releases/observability-patches-20261108-toko036.md) owns exact
identities and recovery custody.

After intentionally editing the root pin and resolving Cargo.lock, run
`make shared-tooling-update` or `make shared-tooling-install`. Common CI/release
and custom deployment admission remain enforced. Logs are under
`target/evidence/toko-tooling-036/`; older receipts retain historical scope.

## Current decisions

- Metrics and Logging are independent release groups. The root owns common
  metadata and the full path/version catalog; publication and release require an
  explicit group. Shared mechanics admit actual source/index/configuration and
  protected receipts. Unknown/shared changes retain full validation.
- Source, formatting, hooks, release metadata and publication reuse the reviewed
  Shared helpers. The existing `group-validation:2` adapter delegates proof
  verification; optional final-candidate caching and stage reuse remain disabled.
- Group increments automatically capture committed source. An explicit group
  selects itself; multiple groups need an explicit ordered roster. Publication
  remains explicit. Candidate setup uses captured catalogs and managed owners;
  recovery and standard preflight check those tools offline without reinstalling.
  Normal edits remain deferred until explicit clean fast-forward reconciliation.
  Status/resume/reconcile/retire use Shared's saved batch context and custody.
- The 0.31 hard cut uses `RELEASE_GROUPS`, `RELEASE_PUBLISH_TARGET`,
  `RELEASE_SETUP_TARGET`, `RELEASE_SETUP_MODE` and `RELEASE_BATCH_ACTIVE`.
  Schema-2 journals record publication identity; old settings refuse. No batch
  journals existed in this checkout at adoption. Storage paths/source pins remain
  unchanged. New exports require version/entrypoint annotations; checksum readers
  reject NUL bytes before shell capture. There are no npm lockfiles to migrate.
- Both groups already classify isolated implementation paths and carry group
  selection into native/Wasm and archive argv. Shared/unknown changes retain full
  validation. The full gate has no duplicate `cargo check` after Clippy; compiler
  admission, allocator-free linking and archive compilation prove distinct inputs.
  No gate was removed or measured speed-up claimed in this refresh.
- Formatter and LOC scratch use the selected consumer target; explicit temporary
  overrides and original failure status/diagnostics remain supported.
- Source LOC is inventory, not shipped Wasm or IC cost. JSON schema 2 classifies
  library/application, tests, examples, benches, tooling and unclassified source.
  Run the current report for current-tree totals; the allocator-link fixture is
  tests despite its historical Cargo example identity.
- The shared lexical checker selects Candid and CBOR enforcement over actual
  crate and retained-consumer Rust sources. Both libraries need zero allowances.
  Group selection reaches matching roots; full CI inspects the workspace through the
  existing production-dependency gate. Macro expansion and type resolution are
  separate review obligations. Shared Cargo declarations independently reject
  forbidden codecs and external IC dependencies, including development aliases.
  The retained-client generator checks its own resolved workspace and generated
  Rust roots. There are no maintained browser or additional Cargo workspace roots;
  synthetic fixtures and dynamic/generated code retain the limits in the host guide.

## Evidence cleanup

The [retention index](README.md) owns this cleanup's scope and availability notice.
Release receipts retain their exact original observations in `releases/`.
Superseded experiment/adoption notes are compacted by topic; raw tracked bundles,
source snapshots and measurement tables are retired rather than re-archived.
The obsolete `evidence-check` Make/CI checksum stage is removed with its inputs.
Tool-download integrity, deployment/source verification and current product/recovery
checks remain. The shared checksum helper is still needed by IC tool installation.
New raw output belongs under `target/evidence/`; no new per-adoption report is needed.

The cleanup reduced 342 files (45,209,308 logical bytes) to 77 files, under
0.5 MiB including protected receipts. All 67 moved receipts preserve their prose
and identities apart from repaired link destinations and retention notices;
the distribution JSON ledger is byte-identical. Private originals, ignored
investigations, recovery state and Git history were outside the cleanup.

## Previous 0.36.0 focused checks

0.36.0 installation/tools, member/pin/lock/snapshot checks, exact-pin admission,
Cargo boundaries and CI selection passed. Both public production profiles remain
dependency-free; all-targets native Clippy with all features passed for both
packages. Formatting/hooks, custom drift-refusal, standard release dispatch,
publication policy and retained public consumers passed. A copied consumer missing
Logging inheritance refused. Entry roots are unchanged; no obsolete tooling
selector or selection-only package remains in maintained consumer inputs.
Full product release gates, hosted CI and native macOS were not run.

### Previous 0.34.0 checks

The 0.34.0 installation and managed tool admission passed. Offline snapshot,
pin and Cargo-boundary checks passed; the application lock graph is restored.
Custom deployment drift-refusal fixtures passed before effects. Matched group
validation and the dependency-free product guard passed. The root-only tooling
package is removed and direct LOC again reports 4,438 lines without warnings.
Standard release Make dispatch, early setup smoke, publication policy, CI selection,
documentation and changed local shell lint passed. A real declaration/lock version
mismatch also refused offline. Application Cargo.lock is byte-identical to the
pre-migration graph; no tooling-only package/dependency references remain in
maintained consumer inputs. Historical reports and snapshot-owned migration
guidance retain their original scope. No cargo-machete exception was present.
Earlier 0.32/0.33 logs retain historical scope; no old dependency instructions
remain current. Full product release gates, hosted CI and native macOS were not run.

### Previous 0.31.12 checks

The 161-file 0.31.12 snapshot passed integrity, documentation and diff checks.
Actual `make cloc CLOC_DEPTH=1` terminal output emitted workspace/crate/module
colours; redirected and NO_COLOR output matched with no ANSI escapes. JSON
retained 4,438 total lines and zero unclassified lines. A two-repository disposable
fixture showed one updating progress line, with both counters and final clearing.
Raw output is under `target/evidence/shared-tooling-03112/`. This presentation
refresh changes no compiler, pins, dependencies, CI or library implementation.

### Previous 0.31.11 checks

The 161-file 0.31.11 refresh changes four governance documents and its manifest.
Snapshot integrity, documentation links, overlay consistency and diff checks
qualify this adoption; unchanged code checks retain their prior scope. This
revision does not repair the HTTP 504 tool-download failures observed in
[CI 42470507602](https://github.com/dragginzgame/ic-observability/actions/runs/42470507602).
Native tests and Gitleaks were skipped after setup failed. No issue maintenance,
release or publication is selected by this governance refresh.

### Previous 0.31.10 checks

The 161-file 0.31.10 snapshot and dependency pins passed. Actionlint and sourced
ShellCheck passed for the changed workflow/local fixture. The actual CI selection
fixture verifies unconditional full-history security ownership, redacted scan
arguments and failure propagation, plus download-cache ordering around native
setup. The native evidence `success` scenario passed with external effects
substituted. Crate/module LOC selections matched the full report's classified
counts, and an unknown module refused. Raw output belongs under
`target/evidence/shared-tooling-03110/`. Hosted cache-service behavior and a live
Gitleaks scan remain CI obligations; these local checks do not claim either.
No release gate, tool pin, package version or dependency was changed.

### Previous 0.31.9 checks

The 159-file 0.31.9 snapshot passed canonical source verification and
`make shared-tooling-check check-pins fmt-check cargo-boundaries-check`.
`make hook-check` passed real formatting, preservation and failure handling.
`RELEASE_GROUPS= bash scripts/release/test-standard-release.sh` passed the actual
consumer Make adapters with substituted release effects. `make cloc CLOC_DEPTH=0`
and `CLOC_DEPTH=2` passed with unchanged totals of 4,438 lines and no unclassified
source. Documentation links and `git diff --check` passed. Raw logs were written
under `target/evidence/shared-tooling-0319/`, but `target/` disappeared after the
checks completed; the successful results were observed before that removal.
This adoption did not request or perform that cleanup.

The release roster and bootstrap ordering were reviewed: the refresh changes no
compiler, tool catalog, installer or native prerequisite. No release gate was
removed, no generic producer matrix was replayed, and no full CI/native macOS or
publication acceptance is inferred. Hashing admission uses the existing root and
generated-consumer checker routes; these dependency-free libraries need no hash
dependency or algorithm migration. Local overlay safeguards remain compatible.

### Previous 0.31.1 checks

The 157-file 0.31.1 snapshot, pins and formatting passed. The repaired helper
matched both retained registry archive checksums and refused a mismatched digest.
Prepared host/Rust/editor checks passed after explicit setup rebound the unchanged
pins to this host's changed native build identity. Raw output belongs to
`target/evidence/shared-tooling-0311/`; no broad consumer gate ran for this fix.
[Upstream CI 42274707843](https://github.com/dragginzgame/shared-tooling/actions/runs/42274707843)
passed macOS tool preparation, then failed `test-release-editor-setup.sh` in its
portable suite. This is not a full upstream or Observability native pass.

Earlier 0.31.0 actual Make smoke passed with prepared Make and Linux-built GNU
Make 3.81, including retired-setting refusal. Internal standard dispatch and both
groups' recovery fixtures passed. The schema-2 batch fixture passed real setup,
lint, archives/readback, publication identity, offline/interrupted recovery,
deferred lock custody, no repeat upload and explicit reconcile/retire.

The outer fixture substitutes the full roster with three real stages, uses local
Git and simulates registry effects. Successful fixture inputs are removed; failures
are retained. These checks do not establish the full production gate, native macOS
or live publication. Its logs belong to `target/evidence/shared-tooling-0310/`.
Matched validation-plan mapping, docs/diff and shell/Perl syntax checks passed.
The [0.31 delivery](releases/observability-patches-20261106-shared0310.md) records
both real 20-stage workspace gates, atomic pushes and live registry readback.
Hosted CI then exposed a macOS parse error in Shared's checksum helper and an
empty inherited roster in Linux release fixtures. The local fixture repair passes
standard/group admission with `RELEASE_GROUPS=`. The 0.31.1 canonical refresh
adopts the upstream parser fix; no exported payload or sibling was locally patched.
Earlier saved-state probes and release receipts retain their original scope.

## Previous 0.30.6 qualification

The 155-file snapshot, pins, formatting and actual Cargo/source Make callers
passed. Scratch caller checks rejected a CBOR import and renamed development
dependency, and preserved Metrics/Logging source isolation. Both generated public
consumer contract tests passed after their independent declaration and source
admission (25 Metrics and 11 Logging Rust files, including empty client roots).
Source scanning and root discovery found no current CBOR migration or browser
work. The declaration and lexical guards are complementary; neither proves
protocol bytes or arbitrary macro/dynamic coverage. No broad CI/native matrix,
library changes or dependency upgrade ran in that focused adoption. Subsequent
Metrics 0.29.4 and Logging 0.24.9 releases each passed all 20 workspace stages,
archive compilation, publication dry run and independent registry/source/content
readback. Exact identities and retained evidence belong to the delivery receipt.

## Previous 0.30.4 qualification

The 152-file snapshot, prepared pins and formatting checks passed. Documentation
checking includes nested release receipts. Receipt-preservation and validation
roster/recovery fixtures passed; new plans select 20 stages after removal of the
obsolete archive check. Historical releases retain their original 21-stage results.

Actual Candid Make callers passed for the workspace (34 Rust files), Metrics
(24) and Logging (10). Injecting a forbidden trait into a scratch retained-Metrics
fixture refused workspace and Metrics checks while Logging still passed.
The current production dependency declarations remain dependency-free. Default
and JSON LOC callers agree on 4,438 code lines and zero unclassified lines;
the allocator fixture's conditional-attribute diagnostic remains for review.
These are focused local checks, not a new Bash 3.2, macOS, compiler or release
qualification. No maintained library Rust, dependency graph or compiler changed.

The subsequent macOS run exposed an existing target-specific `override export`
declaration that GNU Make 3.81 cannot parse. Publication now uses a global export
and a separate target-specific override. The actual smoke checks both publication
mode and group scope against hostile command-line values before external effects.
A locally built GNU Make 3.81 reproduced the original refusal and passed the fix;
the prepared Make and publication ordering fixture passed too. That Linux parser
qualification does not establish macOS native acceptance. Published crate contents
are unchanged by the Make/CI follow-up; future group notes retain this repair.

## Historical qualification

The former 0.30.0 selection was `b37a882314d22bf7ab393b3fe561809377ffd22d`.
[Shared #355 — Complete exported documentation closure for LOC classification and audit guidance](https://github.com/dragginzgame/shared-tooling/issues/355)
was fixed and pushed there: the exported documentation regression and normal
consumer link checks passed without fleet-inventory copies. That repair is
included in the current selection.

Older tooling-selection diaries are retired; exact released identities remain in
release receipts and Git history rather than another current pin catalog.
