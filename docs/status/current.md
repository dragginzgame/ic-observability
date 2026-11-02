# Current handoff — 2026-11-02

**Metrics 0.27.1 and Logging 0.24.2 are released on GitHub and published on
crates.io.** [Verified patch delivery](../evidence/flow-cleanup-delivery-20261102.md)
records exact source/tag identities, full gates, official checksums and retained
receipts. Both uploaded once and independent readback verified all maintained
package files. No delivery blocker remains.

The [five flow simplifications](../evidence/flow-cleanup-20261102.md) are delivered:
setup admission is separate from refusal fixtures; native evidence collection
converges before scenario assertions; Logging shares retained-text components;
registry rendering drops unused source inputs; browser diagnostics share one
execution owner. Setup fixtures remain in explicit TypeScript CI and standard
release validation before the unchanged complete `ci msrv` gates. API, schema,
byte, refusal, retention and feature-isolation contracts are preserved.

Source commit: `05defcb8f6fd65bdda676268a70687bedfca59dc`.
Metrics release: `1a0b89c3727b32da2b6cdcc363bcd5607eea535d`, tag `metrics-v0.27.1`.
Logging release: `787f785e3e36eabab651b28d9a081851f8e32458`, tag `logging-v0.24.2`.
Both standard patch releases completed setup-policy qualification and full
`ci msrv` validation (CI 147 s / 140 s; compiler admission passes), followed by
metadata/archive checks and atomic main/tag pushes. Both publication dry runs
passed; upload/readback ran from each exact clean tag. Do not replay uploads;
use `make verify-publication RELEASE_GROUP=…` for readback-only reconciliation.

The frozen actual-registry consumer and explicit CI intent now select Metrics
0.27.1/Logging 0.24.2, with unchanged Wire/derive 0.15.0, Types 0.17.0 and Platform
0.18.0. Only those two version/checksum entries changed in its lock. Strict
Clippy, all three real Principal/Account compatibility tests, executable
composition and Wasm compile pass on Rust 1.99.1. Current qualification guides
and the [Metrics 0.27 migration](../../releases/metrics/0.27.md) agree. Source-copy
proof remains separate from actual registry acceptance. Metrics arithmetic still
excludes Wire/Platform without defaults, and Logging remains dependency-free.

Delivery used the isolated checkout
`target/deploy/flow-cleanup-20261102/checkout/`. Its parent retains raw setup,
release/publication/acceptance logs and original README preservation hashes.
Plans/journals remain in its `.git/release-state/`; readback directories are
`target/publication/verification.WmhcnH` and `verification.8bD7J0`; actual registry
consumer evidence is `target/qualification/wire-published.nijuup/report/`.
The original root/Metrics README edits remain intact and uncommitted. No sibling
mutation or artifact cleanup ran. The catalog/CI/receipt follow-up needs no
further product release. Hosted runs remain asynchronous; local gates do not
claim new macOS execution or IC performance qualification.

Shared Tooling remains the reviewed 0.27.26 snapshot at committed revision
`fd9390ef797bfad8aaa05fdba8fcddec753b572c` (142 files). Its producer ledger marks
that version Unreleased, not a tagged release claim. The
[adoption receipt](../evidence/shared-tooling-02726.md) retains its scope.
The earlier [Wire 0.15 / Metrics 0.27.0 delivery](../evidence/wire-0150-delivery-20261102.md)
retains the native trait identity migration; these patches add no new pairing.
The ten earlier complexity reductions remain delivered through
[Metrics 0.26.1/Logging 0.24.1](../evidence/cleanup-patch-delivery-20261102.md).

The earlier Rust 1.99.1 adoption in
[#124](https://github.com/dragginzgame/ic-observability/issues/124) remains closed
and delivered through PRs #125/#126. Its
[receipt](../evidence/rust-1991-delivery-20261102.md), prior snapshot and hosted
results remain historical evidence. Historical Metrics 0.24.2 is Git-only /
unuploaded. Canic and stable adapters retain separate owners. No published
history was rewritten.
