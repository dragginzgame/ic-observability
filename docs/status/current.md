# Current handoff — 2026-11-02

**Metrics 0.27.0 is released on GitHub and published on crates.io**, with native
metadata selecting Wire/derive **0.15.0**. Real identity integration selects
canonical Types **0.17.0 / Platform 0.18.0**. Logging remains **0.24.1**, unchanged
and not republished. [Verified delivery](../evidence/wire-0150-delivery-20261102.md)
records exact source/tag identities, complete gates, registry checksum and
retained receipts. No delivery blocker remains.

Source commit: `af39cd6fc48704e2e5d37b34c9ca6cdf31d41cc3`.
Release commit: `0ff6a7b9c0ff2ae7387c85c44b805eb5c200ee0a`.
Annotated tag: `metrics-v0.27.0`. The standard Metrics minor release passed full
`ci msrv` validation (150 s / 0 s), archive checks and atomic main/tag delivery.
Publication dry run passed; the clean exact tag uploaded once. Independent
readback verified non-yanked metadata, archive checksum, VCS provenance and all
39 maintained package files. Do not replay uploads; verification-only recovery
is `make verify-publication RELEASE_GROUP=metrics`.

The frozen actual-registry consumer and explicit CI intent now select Metrics
0.27.0/Logging 0.24.1 with Wire/derive 0.15.0, Types 0.17.0 and Platform 0.18.0.
Only the five changed supplier version/checksum entries differ in its lock;
Logging and all other records are unchanged. Strict Clippy, all three real
Principal/Account compatibility tests, executable composition and Wasm compile
pass on Rust 1.99.1. This proves actual published packages independently of the
[source-copy qualification](../evidence/wire-0150.md). Current qualification
guides and the [Metrics 0.27 migration](../../releases/metrics/0.27.md) agree.

Native schema consumers, including Tooling, can now adopt Metrics 0.27 with
Wire 0.15 and qualify their own report graphs. No further Observability package
publication is needed for this pairing. Arithmetic-only consumers need no Wire
trait coordination. Public arithmetic, typed refusals, schemas, encoded bytes,
feature isolation and the Rust 1.99.1 floor are preserved. No Platform runtime,
Wire endpoint or stable-memory dependency enters Metrics; Logging remains
independent and dependency-free.

Delivery used the clean isolated checkout
`target/deploy/wire-0150-20261102/checkout/`. Its parent retains raw setup,
release/publication and registry acceptance logs plus the README preservation
hashes. Plans/journals remain in the isolated `.git/release-state/`; publication
readback is `target/publication/verification.dn0KIx`; actual registry consumer
inputs/observations are `target/qualification/wire-published.dU3Egu/report/`.
The original `README.md` and `crates/ic-metrics/README.md` edits remain intact and
uncommitted. No sibling mutation or artifact cleanup ran. The final catalog/CI/
receipt follow-up requires no further product release. Hosted runs remain
asynchronous; local gates do not imply new macOS execution.

Shared Tooling remains the reviewed 0.27.26 snapshot at exact committed revision
`fd9390ef797bfad8aaa05fdba8fcddec753b572c` (142 files). Its producer ledger marks
that version Unreleased, not a tagged release claim. The
[adoption receipt](../evidence/shared-tooling-02726.md) retains its original scope.
The ten complexity reductions remain delivered through
[Metrics 0.26.1/Logging 0.24.1](../evidence/cleanup-patch-delivery-20261102.md);
[implementation evidence](../evidence/complexity-cleanup-20261102.md) is separate
from later release effects.

The earlier Rust 1.99.1 adoption in
[#124](https://github.com/dragginzgame/ic-observability/issues/124) remains closed
and delivered through PRs #125/#126 as Metrics 0.26.0/Logging 0.24.0. Its
[receipt](../evidence/rust-1991-delivery-20261102.md), prior snapshot and hosted
results remain historical evidence. The earlier
[Wire 0.14.2 delivery](../evidence/wire-0142-delivery-20261101.md) remains complete
at Metrics 0.25.1. Historical Metrics 0.24.2 is Git-only / unuploaded. Canic and
stable adapters retain separate owners. No published history was rewritten.
