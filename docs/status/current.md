# Current handoff — 2026-11-02

The accepted ten complexity reductions are implemented locally, pending delivery.
[Cleanup evidence](../evidence/complexity-cleanup-20261102.md) maps every item to
its implementation and focused checks. Parsed Wire fixtures and Shared graph
checks replace local rewriting/traversal; publication, retention and CI fixtures
have explicit smaller flows; native metadata and cursor state are simplified.
Source and registry identity checks, TypeScript runtime, native/Wasm Clippy,
allocation-free linking and failure/recovery fixtures pass. Package versions and
all locks remain unchanged. Existing README edits are preserved. No actual
commit, release, publication or sibling mutation ran for this cleanup.

Shared Tooling 0.27.26 is adopted locally at committed revision
fd9390ef797bfad8aaa05fdba8fcddec753b572c, pending delivery. Its producer ledger
still marks the version Unreleased; this is an exact-commit snapshot, not a claim
of a tagged upstream release. [Adoption evidence](../evidence/shared-tooling-02726.md)
records the impact review, focused caller checks and tool preparation. Existing
README edits remain separate; AGENTS.md now uses the installed baseline while
retaining the pre-existing product ownership changes. No commit, package-version
bump, release, publication or store reclamation is part of this adoption.

The Rust 1.99.1 adoption in [#124](https://github.com/dragginzgame/ic-observability/issues/124)
is released and crates.io published as **Metrics 0.26.0** and **Logging 0.24.0**.
Both declare Rust 1.99.1 on native and Wasm, matching the pinned development/release
compiler. [Delivery evidence](../evidence/rust-1991-delivery-20261102.md) records
exact source/tag identities, complete gates, checksums and retained receipts.

[PR #125](https://github.com/dragginzgame/ic-observability/pull/125) merged the
compiler adoption. [PR #126](https://github.com/dragginzgame/ic-observability/pull/126)
corrected published-consumer admission ordering caught by the full gate. Invalid
version intent rejects before Cargo observation; valid intent still enforces the
exact compiler through the existing helper. Both are merged.

Metrics release commit: 1b6dab1d07ad92f58843ae68990e530cc572ee1f,
annotated tag metrics-v0.26.0. Logging release commit:
287a35d412e17252a470a8f94c6b4adb61d794d4, tag logging-v0.24.0.
Each standard minor release completed full `ci msrv` validation (147/0 s and
139/0 s), metadata/archive checks and atomic main/tag push. Each package passed
the publication dry run, uploaded once from its clean exact tag and passed
independent registry/archive/source-content verification. Do not replay uploads;
verification-only recovery remains separate.

The frozen published consumer and CI intent now select Metrics 0.26.0 and Logging
0.24.0 with unchanged Wire/Derive 0.14.2, Types 0.16.0 and Platform 0.17.0.
Only the two published version/checksum entries changed in that lock. Strict
Clippy, real identity compatibility tests, executable composition and Wasm checks
pass on Rust 1.99.1. Both libraries are actual registry dependencies. Source-copy
alignment remains separate evidence. The new [Metrics](../../releases/metrics/0.26.md)
and [Logging](../../releases/logging/0.24.md) migration guides record the higher
compiler requirement. No arithmetic, schema, encoded-byte or Logging contract
changed.

PR #126's [hosted run](https://github.com/dragginzgame/ic-observability/actions/runs/41422023809)
passes Linux, Intel macOS, Apple Silicon macOS and TypeScript. Those are
API-observed PR-source results, separate from exact release-source local gates
and verified published payloads. Later main runs are asynchronous.

Delivery ran in the isolated checkout
`target/deploy/rust-1991-20261102/release-checkout/` to preserve concurrent local
policy/documentation edits. Do not overwrite that unrelated working-tree work.
Raw release/publication logs remain in its parent; plans and journals remain in
its `.git/release-state/`. Readback receipts inside it are
`target/publication/verification.aA3Fhf` and `verification.yoqaAG`. No cleanup ran.
The post-publication catalog/CI/receipt update needs no further product release.

The completed Rust/compiler delivery used Shared Tooling 0.27.23 at
619d194875369e0f72b45477b66adb430acbf6b7. Its receipts retain that original
snapshot identity; the newer local adoption above does not relabel them.

The earlier [Wire 0.14.2 delivery](../evidence/wire-0142-delivery-20261101.md)
remains complete at Metrics 0.25.1. Earlier 0.25.0, PRs #119/#121 and issue #120
remain delivered; do not replay uploads. Historical Metrics 0.24.2 is Git-only /
unuploaded. Canic and stable adapters retain their separate owners. No sibling
checkout, published tag or historical receipt was rewritten.
