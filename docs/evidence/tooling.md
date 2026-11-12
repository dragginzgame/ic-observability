# Contributor tooling

## Current local selection

Published toko-tooling **0.39.17** is selected once in the root catalog and
inherited by both real members. Cargo.lock and the snapshot select archive
SHA-256 `aaeab49adb84ea0d66cf86ecc48d826125f9c3ac6eafaf2a362bccfeba7acbfd`.
The authenticated exporter retains all 55 roots and 111 files, updating only
the baseline. Five test modules use `tests/mod.rs` instead of sibling
`tests.rs`/`tests/` pairs under the new layout rule. Their bytes and Rust module
paths are preserved; package library test inventories and results qualify the
moves. Production Rust, public APIs, canonical files, tool pins and all existing
executable payloads remain unchanged.

The explicit `make deps-update` command and its fixture wiring retain their
0.39.15 evidence under `target/evidence/toko-tooling-03915/`; they add no CI or
release prerequisite and perform no freshness audit. The optional shared Rustdoc
baseline checker is not selected because this consumer uses warning-denied
Rustdoc, not a missing-doc baseline. Supplier review remains scoped to the
selected latest stable, non-yanked toko-tooling release. Installation/admission,
formatting, library test inventories/results and focused checks are under
`target/evidence/toko-tooling-03917/`. This work is local and uncommitted; the
existing licence edit and deferred syn selection remain preserved.

## Delivered 0.39.7 selection

The delivered selection is crates.io toko-tooling **0.39.7**, pinned once
at the root and inherited by both real members. Cargo.lock and the snapshot
select archive SHA-256
`fd795f6ef878496ac27a990a9208b87fa786a9148c18580338ef8ac79df501d7`.
The 0.39.7 authenticated exporter preserves all 54 roots and 109 files, changing
the baseline and the Make/batch retired-setting diagnostics. The preceding 0.39.5
refresh retired 71 unchanged files no longer needed by that selection. Shared reference docs,
rules, audits and task guides are read through reviewed commit-pinned upstream
links; the earlier managed-document namespace plan is superseded. Native product
docs and the canonical root distribution files remain local.

The current diagnostic change points to a reviewed online release guide.
`validation-evidence.pl` remains explicitly selected to preserve the local release
validation caller. Tool catalogs, CI/release rosters and product Rust sources are
unchanged. The consumer release adapter retains its
explicit `TOKO_TOOLING_RELEASE := 1` selection; all 20 workspace obligations and
product/qualification placement remain intact. Consumer documentation checking
now scans maintained local directories without the retired reference roots.

Metrics 0.29.11 and Logging 0.24.16 are delivered with this selection. Both
passed all 20 workspace stages, final-version archive compilation, atomic
branch/tag delivery and independent registry/source-content readback. The
[delivery receipt](releases/toko0397-docs-20261110.md) owns exact identities,
plans, verification directories and recovery custody. Installation/admission and
focused checks are under `target/evidence/toko-tooling-0397/`; documentation
organisation and CI-selection checks are under
`target/evidence/docs-cleanup-20261110/`.

The first batch stopped before delivery on an incomplete synthetic package.
Its fixture repair adds complete distribution inputs and missing/altered-input
refusals. The new batch reran both complete release plans. Failed and completed
candidates remain retained. The normal checkout is reconciled, with only the
separately preserved syn 3.0.10 edit reapplied; the delivered graph uses 3.0.9.
The [source inventory](../governance/source-origins.md) records component origins.
No sibling change or delivery was selected. Hosted native and installed consumer
acceptance remain separate from the local release gate.

## Earlier qualification

The protected receipts own exact published versions, source commits, tags,
registry checksums and release/recovery custody. Their outcomes qualify those
inputs only; they do not establish later native or installed acceptance.

| Selection | Retained outcome and record |
| --- | --- |
| 0.38.2 | Metrics 0.29.10 / Logging 0.24.15 passed both complete 20-stage workspace gates and registry/source readback. The [delivery receipt](releases/toko0382-placement-20261109.md) owns identities and deferred syn custody. |
| 0.37.5 | The changed Cargo boundary caller checks passed; omitted-only APIs and the deferred lock edit were preserved. [Delivery](releases/omission-toko0375-20261109.md) owns Metrics 0.29.9 / Logging 0.24.14 qualification. |
| 0.37.1–0.37.4 | Renamed baseline/commands, caller wiring, hook preservation, CI selection and drift refusal passed focused checks. These releases did not add a carrier package or change production dependencies. Raw logs were recorded under `target/evidence/toko-tooling-0371/` through `toko-tooling-0374/`. |
| 0.36.0 | Root Cargo selection replaced the dedicated tooling lock/metadata scheme. [Delivery](releases/observability-patches-20261108-toko036.md) owns both full gates and publication for Metrics 0.29.7 / Logging 0.24.12. |
| 0.31.0–0.31.12 | Focused batch recovery, source admission, cache ordering, hook, LOC and CI selection checks retain their original scope. [0.31 delivery](releases/observability-patches-20261106-shared0310.md) owns the complete product gates; the subsequent macOS checksum and inherited-roster repairs are recorded there. |
| 0.30.6 | Actual Cargo/source callers and generated consumers passed; scratch forbidden codec imports/renamed dependencies refused. [Delivery](releases/observability-patches-20261106.md) owns the later full gates and registry readback. |
| 0.30.4 | Snapshot and actual Candid callers passed. Publication dispatch was checked with prepared Make and Linux-built GNU Make 3.81; that parser proof did not establish macOS native acceptance. [Delivery](releases/observability-patches-20261105-tooling.md) retains the release identities. |

Earlier metadata-only 0.34 selection and old Git-snapshot instructions are
superseded. Current installation and focused commands belong to the
[development guide](../development/hosts.md); group selection and recovery belong
to the [release guide](../releases/independent-releases.md). This summary does not
maintain another command or policy catalog.

Historical setup limitations remain distinct from passes. During 0.31.11,
[CI 42470507602](https://github.com/dragginzgame/ic-observability/actions/runs/42470507602)
failed tool downloads with HTTP 504; native tests and Gitleaks were skipped.
[Upstream CI 42274707843](https://github.com/dragginzgame/shared-tooling/actions/runs/42274707843)
passed macOS preparation but failed the release-editor fixture. Neither run is
recorded as a complete pass. Older logs under ignored `target/` are not assumed
available; a 0.31.9 run's target files disappeared after observed successful checks.

## Retention and documentation cleanup

The [retention index](README.md) owns the earlier evidence cleanup's scope and
availability notice. It reduced 342 files (45,209,308 logical bytes) to 77 files,
under 0.5 MiB including protected receipts. Raw tracked bundles, source snapshots
and measurement tables were retired rather than re-archived. The distribution
JSON ledger stayed byte-identical; private originals, ignored investigations,
recovery state and Git history were outside that cleanup.

The 2026-11-10 documentation cleanup organises native guides by topic and compacts
superseded tooling diaries into this summary. It preserves protected receipts,
distribution records, audit artifacts and historical handoffs, repairing their
navigation links where needed. No raw artifact, target directory, tool store,
stash, recovery candidate or published identity is removed. Earlier diary details
remain in ordinary Git history; ignored logs do not become durable evidence by
being named here.

Focused documentation/CI caller checks are recorded under
`target/evidence/docs-cleanup-20261110/`. This is documentation organisation and
navigation validation, not a new product, native-host or release qualification.
