# Current handoff — 2026-11-08

## Installed Cargo-selected toko-tooling 0.36.0

Root `[workspace.dependencies]` declares `toko-tooling = "=0.36.0"` once.
Both real workspace packages inherit it unconditionally as a dev-dependency and
include the cargo-machete exemption, without artificial Rust imports. Cargo.lock
selects the crates.io archive SHA-256
`de0dd05b6437061622a76942baa25d40d2181497e7ba66d9fd809132a3082936`.
The installed snapshot agrees, preserving all 97 roots with 168 files. The released
producer installer downloaded authenticated registry bytes and ran tool setup
and admission. No sibling repository was changed.

The 0.34 metadata selector and `toko-tooling.lock` are removed. The root remains
a virtual workspace with only Metrics and Logging. There is no tooling-only
package or release-group member. Cargo.lock changed only for toko-tooling and its
two dev-dependency edges; unrelated selections and public versions are unchanged.
The exact-pin exception in `ci/dependency-pinning-exceptions.json` is scoped to
this required tooling pin and backed by AGENTS.md. Intentional fixture workspaces
are isolated test inputs, not additional maintained packages.

After changing the root pin deliberately, resolve Cargo.lock with Cargo, then run
`make shared-tooling-update` or `make shared-tooling-install`. The installer does
not resolve the application graph. Offline admission checks every member, pin,
lock checksum and snapshot. Common CI/release Make targets and custom candidate,
metadata and publication adapters retain admission before effects.

Focused installation, tooling checks, snapshot/pin/Cargo admission, production
graphs, native all-targets Clippy for both packages, formatting/hooks, CI selection,
standard release dispatch, publication policy and retained public consumer tests
passed. A copied consumer missing a member declaration refused. Evidence is under
`target/evidence/toko-tooling-036/`. Product release gates remain unchanged; full
CI/native macOS acceptance is not inferred. The deploy request selects this
repository only: commit the migration, then release Metrics 0.29.7 followed by
Logging 0.24.12 through the captured batch with verified crates.io publication.
Unlike the earlier tooling-only delivery, both public package manifests now
carry new dev requirements and cargo-machete metadata, so both payloads need
fresh patch identities. Shared inputs require the complete product release gate.
The normal checkout starts on main; delivery targets origin/main and both group
tags. Candidate and durable recovery paths follow the qualified batch contract.

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
