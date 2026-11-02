# Current handoff — 2026-11-02

**Metrics 0.27.2 and Logging 0.24.3 are released on GitHub and published on
crates.io.** [Verified fixture-cleanup delivery](../evidence/fixture-cleanup-delivery-20261102.md)
records source/tag identities, full gates, official checksums and retained
receipts. Both uploaded once and independent readback verified all maintained
package files. No delivery blocker remains.

The [fixture/export simplifications](../evidence/fixture-export-cleanup-20261102.md)
and [follow-up fixture cleanup](../evidence/fixture-scope-cleanup-20261102.md) are
delivered: parsed retained-consumer rendering keeps real supplier versions;
Logging graph checks run independently on native/Wasm; export uses one budget
stop/error state; content refusals run directly with integrated tamper coverage;
native-evidence assertions are flat and dependency fixtures share one baseline.
Independent release/restoration checks, arithmetic and schema/byte contracts remain.

Source commit: `1a58577f2f34d38323acb99d34a09f10ef692980`.
Metrics release: `305f2dc545b147e73747cb7be83913ea6a41d794`, tag `metrics-v0.27.2`.
Logging release: `680d2acedcae3f8ad5b1102d4888b22b3374a352`, tag `logging-v0.24.3`.
Both standard patch releases completed setup-policy qualification and full
`ci msrv` validation (CI 151 s / 131 s; compiler admission passes), followed by
metadata/archive checks and atomic main/tag pushes. Publication dry runs passed;
upload/readback ran from each exact clean tag. Do not replay uploads;
use `make verify-publication RELEASE_GROUP=…` for readback-only reconciliation.

The frozen actual-registry consumer and explicit CI intent now select Metrics
0.27.2/Logging 0.24.3, with unchanged Wire/derive 0.15.0, Types 0.17.0 and Platform
0.18.0. Only those two version/checksum entries changed in its lock. Strict
Clippy, all three Principal/Account compatibility tests, executable composition
and Wasm compilation pass on Rust 1.99.1. Current qualification guides and the
[Metrics 0.27 migration](../../releases/metrics/0.27.md) agree. Source-copy proof
remains separate from registry acceptance. Arithmetic excludes Wire/Platform
without defaults; Logging remains dependency-free.

Delivery used the isolated checkout
`target/deploy/fixture-cleanup-20261102/checkout/`. Its parent retains raw logs,
source patches and original README preservation hashes. Plans/journals remain
in its `.git/release-state/`; readbacks are `target/publication/verification.xE8A3f`
and `verification.rs5ojI`; registry consumer evidence is
`target/qualification/wire-published.KJzEoF/report/` inside the checkout.
The original root/Metrics README edits remain intact and uncommitted. No sibling
mutation or artifact cleanup ran. The catalog/CI/receipt follow-up needs no
further product release. Hosted runs remain asynchronous; local gates do not
claim new macOS execution or IC performance qualification.

Shared Tooling remains the reviewed 0.27.26 snapshot at committed revision
`fd9390ef797bfad8aaa05fdba8fcddec753b572c` (142 files). Its producer ledger marks
that version Unreleased, not a tagged release claim. The
[adoption receipt](../evidence/shared-tooling-02726.md) retains its scope.
The earlier [Wire 0.15 / Metrics 0.27.0 delivery](../evidence/wire-0150-delivery-20261102.md)
retains native trait migration evidence; these patches add no new pairing.
Earlier cleanup deliveries remain recorded in
[Metrics 0.27.1/Logging 0.24.2](../evidence/flow-cleanup-delivery-20261102.md) and
[Metrics 0.26.1/Logging 0.24.1](../evidence/cleanup-patch-delivery-20261102.md).
Historical Metrics 0.24.2 is Git-only / unuploaded. Canic and stable adapters
retain separate owners. No published history was rewritten.
