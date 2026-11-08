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

Both affected package groups are now delivered and published: Metrics 0.29.7
and Logging 0.24.12. Each passed the full 20-stage workspace release plan, final
archive compilation and independent registry readback. The
[delivery receipt](../evidence/releases/observability-patches-20261108-toko036.md)
owns exact source/tag/archive identities and validation locations.

Batch `batch-gfJA5IMg` is complete at index 2; execution is retained under
`target/release-frozen/batch-gfJA5IMg` with durable recovery at
`.git/release-state/frozen/batch-gfJA5IMg/`. The normal main checkout was cleanly
fast-forwarded to the Logging release. The failed pre-delivery batch
`batch-C8a10ddy` remains retained and must not be resumed as repaired source.
Its admission-order failure was fixed in `cdf8b13` and qualified before the fresh
batch. No retirement or artifact cleanup ran; no sibling repository changed.
Hosted CI remains asynchronous; missing/failed/cancelled native checks are not passes.

## Published packages and recovery custody

Metrics 0.29.7 (`metrics-v0.29.7`, `ede2825`) and Logging 0.24.12
(`logging-v0.24.12`, `eadaaa1`) are published and non-yanked. Never re-upload them.
The [current receipt](../evidence/releases/observability-patches-20261108-toko036.md)
owns exact source/tag/archive identities and publication verification.
The completed 0.29.7 and 0.24.12 ledger entries are dated; no next release is selected.

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
