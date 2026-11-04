# Current handoff — 2026-11-04

**Deployment selected: Metrics 0.29.1 and Logging 0.24.6.**
The authorized plan uses this normal `main` checkout, `origin/main`, explicit
release groups and GitHub tags followed by crates.io publication/readback.
Both candidates were absent from the registry and remote tags before dispatch.
The standard runner must finish each complete selected gate before preparation.
No new version is claimed delivered until release and publication succeed.
Shared Tooling 0.29.4 and the external Rust test layout are prepared locally.
The [latest adoption receipt](../evidence/shared-tooling-0294-20261104.md) records
revision `628ccc75d813bfd9bae777bfbaef55838d25b1b2`, its Unreleased status and all
149 verified files. Retained-state admission, Make dispatch and isolated runner
refusal probes pass; no recovery evidence was deleted. Catalog/compiler selections
and package versions are unchanged. Pending notes remain Metrics 0.29.1 and Logging
0.24.6: compatible tooling and test cleanup, with no library contract change.
The [earlier cleanup receipt](../evidence/shared-tooling-0293-20261104.md) owns
external test-layout, companion-resolver and native-evidence scenario checks.
Retained consumer contracts are ordinary Rust files included in shared formatting.
Native evidence supports focused scenario selection; its complete default remains.
The [adoption-gap follow-up](../evidence/shared-tooling-0294-20261104.md#adoption-gap-follow-up)
records all five subsequent repairs: missing package-input rejection, one bounded
local process-capture owner, command-scoped CI/release scratch defaults, standard-
library test import consistency and accurate workspace/focused help labels.
Process and package-input negative regressions run in owning normal gates.
Strict affected Clippy, seven histogram/two ordinary Logging model tests, package
links, dependency graphs/refusals and publication-policy checks pass. The extended
Logging exploration stays intentionally ignored. Matched mapping/custody and both
group release/recovery fixture directions pass with substituted broad effects;
default scratch and explicit CI overrides are checked. No full/hosted CI is claimed.
No supplier checkout was changed; runtime contracts and lockfile remain unchanged.
The pre-existing lowercase Cargo comments are preserved in a dedicated Git stash
and safety copies under `target/deploy/observability-20261104/`; restore only those
comments after both clean-checkout uploads, preserving newly released versions.

**Metrics 0.29.0 is delivered to GitHub and verified on crates.io. Logging stays 0.24.5.**
The [delivery receipt](../evidence/metrics-0290-delivery-20261103.md) owns exact
source/tag/archive identities and retained evidence. Delivery used this normal
checkout on `main`, the established approved `origin/main` destination and one
verified upload. Validated source: `1048eec3526796298ef5917144c1bcbaf1ad7e74`.
Release: `0ead785d2f0c7eafa05c9f9a05a2a609f320af0d`, `metrics-v0.29.0`.
All 21 workspace-scope release stages passed (373 summed stage seconds), followed
by archive compilation, publication dry run and official registry/source readback
of all 28 maintained packaged files. No gate reuse or version projection ran.
Use `make verify-publication RELEASE_GROUP=metrics` for readback, never re-upload.

**#130 stays open for required consumer repairs and acceptance.**
The [API inventory](../metrics-api.md) accounts for every retained public
member/trait, removed arithmetic/report API and owning consumer repair. Metrics
instruments the Canic application tree. Recorder Serde, general numeric helpers
and report queries are removed; explicit `persistence` functions retain canonical
restoration for Storage. Fixed recording, overflow, reset and retention semantics
remain; all production feature/target graphs are dependency-free.
Canic's adapter owns report DTOs, Wire/TypeScript and the shared endpoint.
The [0.29 migration](../../releases/metrics/0.29.md) documents the breaking cut.
No sibling source change, installed acceptance, real retained-codec qualification
or owner-local rounding/validation repair is claimed by producer publication.

The first full-gate attempt exposed a missed local retained-client import of
removed ratio helpers. That client now tests legitimate recording/restoration and
quality. Fresh full qualification passed from the corrective commit above; the
failed plan and all recovery evidence remain retained. See the delivery receipt.
Focused producer checks also retain 50 library, three external-client, five
positive doctest and 30 compile-fail cases; strict native/Wasm Clippy, graph and
declaration refusals, allocator-free Wasm link, rustdoc and documentation checks.
Focused evidence is under `target/issue-130/` with its original source identities.

Hosted [release CI run 41699772724](https://github.com/dragginzgame/ic-observability/actions/runs/41699772724)
was running at delivery. The receipt follow-up can supersede it through normal
concurrency; inspect the latest retained full run for Linux, Intel macOS and ARM
macOS acceptance. Pending/cancelled runs are not passes. Issue #130 remains open.
The pre-existing lowercase Cargo catalog comments are restored and unstaged;
safety copies remain under `target/deploy/metrics-0290-20261103/` and the earlier
stash. No unrelated cleanup or sibling delivery ran.

The earlier Shared Tooling release was `v0.28.2`, revision
`5cf67f81c50c56ac17389ae71a3a87d46e86e8a2`, with 148 verified snapshot files.
The [earlier delivery](../evidence/shared-tooling-0282-delivery-20261103.md) owns
Metrics 0.28.2 / Logging 0.24.5 registry proof and #129's completed three-host
acceptance. #129 remains closed. Matched full/selected mapping qualification was
renewed for the Metrics 0.29 cut; command logs remain under
`target/deploy/metrics-0290-20261103/`.

Full CI and release selection share one declared stage roster through Shared's
interface. Full CI forces workspace scope. Shared owns baseline and fresh
execution admission; local policy owns product mapping, exclusions, source/index,
compiler/configuration, metadata and publication authority.
Consumer receipt `group-validation:2` binds Shared proof before preparation;
late admission checks sealed byte custody and original selection/configuration.
Physical-root binding rejects relocation. No stage reuse, version projection or
old-receipt reinterpretation is enabled. Completed v1 receipts keep their adapter.
Routine CI retains caller/mapping/custody regressions; matched full/selected
comparison has the explicit `make release-validation-qualify` lifecycle.

Current release plan/proof/logs: `target/release-validation/metrics-0.29.0.ZsBQfZ/`;
journal/protected receipts: `.git/release-state/metrics-0.29.0.plan` and matching
directory. Registry proof: `target/publication/verification.1PISmp/`.
The older Metrics 0.28.2 / Logging 0.24.5 plans and readbacks retain their recorded
identities in the linked earlier receipt. No original recovery evidence was removed.
Logging remains a dependency-free heap engine; governed stable/storage adapters
retain their upstream owner. Observability #128 remains closed for its earlier
Wire-metadata removal. Earlier consumer migrations keep their own issue/evidence;
the wider #130 repair is not complete merely because the producer is available.
