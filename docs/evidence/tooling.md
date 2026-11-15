# Contributor tooling

## Local 0.44.3 selection

The authenticated crates.io payload selects published toko-tooling **0.44.3**,
archive SHA-256 `8a9bc7b6827044baac8134cada7ee6bc31f86c70beec9608d1d39d911eba15e1`.
The exporter updated only the two LOC reporter files, retaining 56 entrypoints
and 114 files. Plain `toko-cloc` and `-d 0` now show compact totals; repository
and workspace `-d 1` adds crates and `-d 2` adds top-level modules. Named crate
and module selections expand their immediate children at `-d 1`.

Installation/tool admission and actual repository/workspace/selection reports
passed. Before/after JSON reports are identical: 5,524 lines and no unclassified
source. The launcher remains unchanged; no sibling scan or producer fixture suite
was needed. Pin/lock/snapshot, member selection, formatting, documentation and
inventory checks complete this adoption; records use `target/evidence/toko-tooling-0443/`.
Only toko-tooling changed in the incoming lock graph; the separate syn 3.0.10
edit is preserved. Product versions remain Metrics 0.30.8 and Logging 0.25.8.
The baseline and all other runtime inputs are unchanged. This selection remains
local and uncommitted; no new release or deployment ran.

## Delivered 0.44.2 selection

Source `aa7e9abe93f8aea7b9ea1c95c5b86530bd7086a0` selects published
**toko-tooling 0.44.2**, archive SHA-256
`d8a17b4fb7429edc446c06b1c50149102d17cf93e15dade9f53c187a1717c373`.
The exporter retained 56 entrypoints and 114 files. Plain `toko-cloc` matches
`-d 0`; timing readback rejects malformed records. The new post-push review
is part of delivery handoff, with no extra hook or validation framework.
No local caller imports the retired Python verifier, and the Platform-only BLS
exception does not apply here. Product Rust/APIs, compiler/lints and production
graphs remain unchanged.

Metrics 0.30.8 and Logging 0.25.8 are delivered and independently verified on
crates.io. The [protected receipt](releases/toko0442-delivery-20261115.md) owns
exact identities, both complete plans, phase timings, supplier dispositions,
post-push review and recovery custody. Initial focused records remain under
`target/evidence/toko-tooling-0441/` and `target/evidence/toko-tooling-0442/`;
delivery records use `target/deploy/toko0442-20261115/`. The separate syn edit
is preserved. Hosted native and downstream acceptance remain separate.

## Delivered 0.43.2 selection

The authenticated vendor payload selects published toko-tooling **0.43.2**, with
56 entrypoints and 114 files. Frozen batches retain phase observations, read
with `make release-batch-timings`. Consumer fixtures clear the invoking timing
context; simulated effects stay separate from live deployment records. The root
release index supplies the new baseline's CLI quick start. Product Rust/APIs,
compiler/lints, legal files, production graphs and release-stage roster are unchanged.

Metrics 0.30.7 and Logging 0.25.7 are delivered and independently verified on
crates.io. The [protected receipt](releases/toko0432-delivery-20261114.md) owns exact
source/tag/archive identities, both complete plans, 30 successful live phase
observations, isolation checks, supplier dispositions and recovery custody.
Focused records remain under `target/evidence/toko-tooling-0432/`; delivery data
and official timing readback use `target/deploy/toko0432-20261114/`. Timing data
grants no proof reuse or retry authority. The separate syn edit is preserved;
hosted native and downstream consumer acceptance remain separate.

## Delivered 0.43.0 selection

The authenticated vendor payload selects published toko-tooling **0.43.0**, with
56 entrypoints and 111 files. The `toko-cloc` PATH launcher replaces the retired
Make LOC interface; active usage belongs to the [development guide](../development/hosts.md).
The carried-forward CDPATH hook fixes preserve staged formatting and local edits.
Canonical files, product Rust/APIs, compiler/lints and production graphs are unchanged.

Metrics 0.30.6 and Logging 0.25.6 are delivered and independently verified on
crates.io. The [protected receipt](releases/toko0430-delivery-20261114.md) owns exact
source/tag/archive identities, both complete 20-stage plans, phase timings,
supplier dispositions, focused LOC/hook checks and recovery custody. Focused
records remain under `target/evidence/toko-tooling-0430/` and
`target/evidence/toko-tooling-0428/`; delivery records are under
`target/deploy/toko0430-20261114/`. Hosted native acceptance stays asynchronous.
The separate syn 3.0.10 edit remains outside the published syn 3.0.9 graph.

## Delivered 0.42.5 selection

Vendor-aware fixture-retention helper resolution replaced the local workaround,
retaining all 18 exit-boundary checks. Metrics 0.30.5 and Logging 0.25.5 are
published and independently verified. The [protected receipt](releases/toko0425-delivery-20261113.md)
owns exact selections, both complete plans, archive/source readback, timings and
recovery custody. Its hosted native observations remain separate from local proof.

## Delivered 0.42.4 selection

Managed tool activation/maintenance recovery and the domain-library/endpoint
clarification were delivered with Metrics 0.30.4 and Logging 0.25.4. The
[protected receipt](releases/toko0424-delivery-20261113.md) owns exact selections,
complete validation, registry readback and recovery custody. Its original source
retains the local exit-prefix workaround, superseded by the current adoption.

## Delivered 0.42.1 selection

Vendor layout, consumer-root validation and exit-probe repair; both full plans and registry readback.
The [protected receipt](releases/toko0421-vendor-20261113.md) owns identities, validation scope and recovery custody.

## Delivered 0.41.0 selection

Cargo warning admission, actual-dependency consumers and direct bounded-export formatting.
The [protected receipt](releases/toko0410-export-20261113.md) owns identities, validation scope and recovery custody.

## Delivered 0.40.1 selection

GNU Make 3.81 prerequisite admission and full frozen delivery.
The [protected receipt](releases/toko0401-delivery-20261113.md) owns identities, validation scope and recovery custody.

## Delivered 0.40.0 selection

Rust 1.100.0 and inherited lint policy.
The [protected receipt](releases/toko0400-rust1100-20261113.md) owns identities, validation scope and recovery custody.

## Delivered 0.39.17 selection

Tooling/package layout and independent group delivery.
The [protected receipt](releases/toko03917-delivery-20261112.md) owns identities, validation scope and recovery custody.

## Delivered 0.39.7 selection

Online references, package distribution inputs and documentation organisation.
The [protected receipt](releases/toko0397-docs-20261110.md) owns identities, validation scope and recovery custody.

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
