# Current handoff — 2026-11-08

## Installed root-owned toko-tooling 0.34.0

Root `[workspace.metadata.toko-tooling]` declares exact version 0.34.0.
`toko-tooling.lock` pins registry archive SHA-256
`5ca8ad09ad9359bc4945a4afdaafce301dd5a4b4955cd5c9f5058d7a54ffcf10`.
The installed snapshot records the same identity with all 97 prior entrypoints
and 167 files. The new producer installer bootstrapped this registry-to-registry
update; no Git ownership source was needed. Installation and tool checks passed.

The old Cargo-dependency scheme is completely undone: the root is virtual,
only Metrics and Logging are workspace members, Cargo.lock matches its original
application graph, and no tooling-only package, source, dependency, group entry
or dependency-policy exception remains. No real product tools or tests were removed.
The earlier root-package LOC inflation and catalog-alias blocker are resolved by
removing that package; the direct LOC report returns 4,438 lines.

Change the root metadata version and run `make shared-tooling-update` to resolve
and install; `make shared-tooling-install` reinstalls the selected tooling lock.
Application Cargo updates no longer affect tooling selection. Offline
`make shared-tooling-check` admits the declaration, tooling lock and snapshot.
The custom candidate, metadata and publication adapters now call this check
before effects; the standard Make CI and release commands inherit the shared guard.

Focused checks and evidence are in `target/evidence/toko-tooling-034/`.
Snapshot/pin/Cargo boundaries, custom drift-refusal tests, application dependency
admission, matched release-plan mapping and direct LOC checks passed.
Standard release dispatch, setup smoke, publication policy, CI selection, changed
local shell lint and documentation checks also passed. No obsolete dependency or
tooling-only package references remain in maintained consumer configuration;
snapshot-owned migration guides and older reports retain historical explanations.
Product release requirements remain unchanged; no broad CI or native macOS acceptance
is inferred. The deploy request selects commit/push delivery to `origin/main`
from the normal `main` checkout. Published package trees, dependency contracts
and Cargo.lock are unchanged; Metrics remains 0.29.6 and Logging 0.24.11.
No new package tags or crates.io uploads are selected. Hosted CI runs
asynchronously after delivery.

## Published packages and recovery custody

Metrics 0.29.6 (`metrics-v0.29.6`, `79c3c7e`) and Logging 0.24.11
(`logging-v0.24.11`, `6ddccd2`) are published and non-yanked. Never re-upload them.
The [delivery receipt](../evidence/releases/observability-patches-20261106-shared0310.md)
owns exact source/tag/archive identities and publication verification.
Pending notes remain 0.29.7 and 0.24.12 for the next actual package releases.

Completed batch `batch-z30yB8KG` used
`target/release-frozen/batch-z30yB8KG`; durable recovery state is under
`.git/release-state/frozen/batch-z30yB8KG/`. No retirement or cleanup is selected.
Preserve saved plans, journals, source pins and publication custody. Earlier
receipts and stashes, including `a7dbbac568a37876f37f8a89607545a5fba389b2` and
`e5bedde93b31a520a4ff282071099152cb04c555`, remain untouched. The
[evidence retention index](../evidence/README.md) owns retained evidence and the
unchanged private-source distribution ledger.

The HTTP 504 setup failures in
[CI 42470507602](https://github.com/dragginzgame/ic-observability/actions/runs/42470507602)
prevented native tests and the secret scan from running. Those historical
failures are not passes, and no subsequent native acceptance is inferred here.
The [tooling summary](../evidence/tooling.md) records focused evidence and limits.

#130 remains closed for its producer scope. Remaining Profiler work belongs to
[Profiler #17](https://github.com/dragginzgame/ic-profiler/issues/17). The
[API inventory](../metrics-api.md) and [0.29 migration](../../releases/metrics/0.29.md)
retain the consumer map: Canic owns reporting, Persistence owns governed stable
adapters, and each downstream owner retains acceptance.
