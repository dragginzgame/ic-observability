# Current handoff — 2026-11-02

The accepted ten complexity reductions and reviewed Shared Tooling adoption are
delivered as **Metrics 0.26.1** and **Logging 0.24.1**, on GitHub and crates.io.
[Patch delivery evidence](../evidence/cleanup-patch-delivery-20261102.md) records
exact source/tag identities, complete release gates, official archive checksums
and retained receipts. Both uploads completed once and independent readback
verified all maintained package files. No deployment blocker remains.

[Cleanup evidence](../evidence/complexity-cleanup-20261102.md) maps every item to
implementation and focused checks. Parsed Wire fixtures and Shared graph checks
replace local rewriting/traversal; publication, retention and CI fixtures have
smaller explicit flows; native metadata and cursor state are simplified. Public
arithmetic, schema, byte, typed-refusal and Logging paging contracts are preserved.
Metrics arithmetic remains allocation-free and independent of Wire/Platform;
Logging remains dependency-free. Earlier local evidence retains its original
scope; the delivery receipt records the later release and publication effects.

Shared Tooling 0.27.26 is adopted at committed revision
`fd9390ef797bfad8aaa05fdba8fcddec753b572c`, with 142 reviewed files. Its producer
ledger marks that version Unreleased; this is an exact-commit snapshot, not a
claim of a tagged upstream release. [Adoption evidence](../evidence/shared-tooling-02726.md)
records its impact review and focused caller checks. AGENTS.md uses the adopted
baseline while retaining the product ownership overlay.

Source commit: `f73d1a7a071ccaf30f3ca5c21a12a312733dc6d5`.
Metrics release: `2db8029905a86aa56bd1934fc819f491a0322deb`, tag `metrics-v0.26.1`.
Logging release: `35119d82918325fe041b3b62024dad8af9f1abca`, tag `logging-v0.24.1`.
Each standard patch release completed full `ci msrv` validation (147/1 s and
133/0 s), metadata/archive checks and an atomic main/tag push. Each package then
passed its publication dry run and uploaded from its clean exact tag. Do not
repeat uploads; verification-only recovery remains separate. Local full gates
do not claim new hosted macOS results; subsequent hosted runs are asynchronous.

The frozen published consumer and explicit CI intent now select Metrics 0.26.1
and Logging 0.24.1, with unchanged Wire/Derive 0.14.2, Types 0.16.0 and Platform
0.17.0. Only those two published version/checksum entries changed in its lock.
Strict Clippy, three real Principal/Account compatibility tests, executable
composition and Wasm compilation pass on Rust 1.99.1. Both packages are actual
registry dependencies; source-copy alignment is separate evidence. Current
qualification guides use the new published versions. The catalog/CI/receipt
follow-up needs no further product release.

Delivery used the isolated checkout
`target/deploy/cleanup-patch-20261102/checkout/` to preserve the two pre-existing
root and Metrics README edits. Keep those edits uncommitted and intact. Their
hashes are retained in the deployment parent's `preserved-readmes.sha256`.
That parent also retains raw release/publication logs. Plans and journals remain
in the isolated `.git/release-state/`; readback receipts are
`target/publication/verification.1sgwel` and `verification.wV3Yww`. Actual
published-pair evidence is `target/qualification/wire-published.iHEhAr/report/`.
No artifact cleanup or sibling mutation ran.

The earlier Rust 1.99.1 adoption in
[#124](https://github.com/dragginzgame/ic-observability/issues/124) remains closed
and delivered through PRs #125/#126 as Metrics 0.26.0 and Logging 0.24.0. Both
current patch packages retain that exact compiler floor. Its
[delivery record](../evidence/rust-1991-delivery-20261102.md), prior Shared snapshot
identity and hosted results remain historical evidence; do not relabel them.
Migration guides remain [Metrics 0.26](../../releases/metrics/0.26.md) and
[Logging 0.24](../../releases/logging/0.24.md).

The earlier [Wire 0.14.2 delivery](../evidence/wire-0142-delivery-20261101.md)
remains complete at Metrics 0.25.1. Historical Metrics 0.24.2 is Git-only /
unuploaded. Canic and stable adapters retain separate owners. No sibling
checkout, published tag or historical receipt was rewritten.
