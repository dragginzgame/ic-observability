# Contributor tooling

The current local snapshot selects committed Shared Tooling 0.30.4,
`2aa41c7394300302fe802b69b31b855bdc89b671`, matching upstream main when reviewed.
Its source ledger remains Unreleased; this is not a tagged-release claim.
The canonical exporter preserves the reviewed entrypoints and derives the Candid
checker's documented closure. The adoption left library versions, Cargo.lock and
tool/compiler catalogs unchanged; the subsequent [patch delivery](releases/observability-patches-20261105-tooling.md)
owns version preparation and publication. Explicit setup and offline admission
retain their owners.

## Current decisions

- Metrics and Logging are independent release groups. The root owns common
  metadata and the full path/version catalog; publication and release require an
  explicit group. Shared mechanics admit actual source/index/configuration and
  protected receipts. Unknown/shared changes retain full validation.
- Source, formatting, hooks, release metadata and publication reuse the reviewed
  Shared helpers. The existing `group-validation:2` adapter delegates proof
  verification; optional final-candidate caching and stage reuse remain disabled.
- Formatter and LOC scratch belong under the selected consumer target. Explicit
  temporary-directory overrides remain supported, with original failure status
  and diagnostics preserved. The 0.30.2 update handles empty options on Bash 3.2.
- Source LOC is inventory, not shipped Wasm or IC cost. JSON schema 2 classifies
  library/application, tests, examples, benches, tooling and unclassified source.
  The existing report totals 4,438 code lines with zero unclassified source; the
  allocator-link fixture is tests despite its historical Cargo example identity.
- The shared lexical Candid checker selects actual crate and retained-consumer
  Rust sources. Both libraries need zero allowances. Group selection reaches
  matching roots; full CI inspects the complete workspace once through the
  existing production-dependency gate. Macro expansion and type resolution are
  separate review obligations.

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

The uncommitted 0.30.1 selection was
`0c5eebc49534e99b09326c49b003a0adfd2348cb`. Snapshot/pin/formatting and actual
hook checks passed, LOC source hashes/classifications matched the preceding
report, custom-target scratch retained the same totals, and both draft callers
rendered into scratch. The expected formatter failure retained status 43 and its
log. Those local observations do not establish hosted/macOS or release acceptance.
Raw local logs under `target/shared-tooling-0301/` were not cleaned by this task.
Older tooling-selection diaries are retired; exact released identities remain in
release receipts and Git history rather than another current pin catalog.
