# Contributor tooling

The current local snapshot selects committed Shared Tooling 0.31.1,
`5efbda2ab81ad84e30f490f3137d8ef083c303d2`, matching upstream main when reviewed.
Its source ledger remains Unreleased; this is not a tagged-release claim.
This refresh preserves library versions, Cargo.lock and tool/compiler catalogs;
the canonical exporter retains the reviewed entrypoints and companion closure.
The [previous 0.30.7 delivery](releases/observability-patches-20261106-shared0307.md)
owns its version preparation and publication. Explicit setup and offline admission
retain their owners.

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
  The existing report totals 4,438 code lines with zero unclassified source; the
  allocator-link fixture is tests despite its historical Cargo example identity.
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

## Current focused checks

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
standard/group admission with `RELEASE_GROUPS=`. The 0.31.1 canonical refresh now
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
