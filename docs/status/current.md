# Current handoff — 2026-10-31

The maintainer delegated deployment of the Wire 0.13 adoption. Only Metrics uses
Wire here, so Metrics 0.24.0 was released and published; Logging remains 0.23.2.
Source preparation is commit 6e770c7a380778375dce484dc3dc076ee08d2a31.
The standard minor release created metrics-v0.24.0 at
2a18f93a8d2e80d60279fe29ad626dc0ea5810f1 and atomically pushed main/tag to GitHub.
No sibling checkout or sibling release was touched.

## Delivered identity

[Published Metrics 0.24.0](https://crates.io/crates/ic-metrics/0.24.0) supplies
Wire/Derive 0.13 native schemas. Official index/archive checksum is
`70544c4dc1ae7697e22f2a3dd23a96de8fbcd722e7c320d72fda0c7760c2b9c6`;
the archive's clean VCS identity matches the release tag. Both upload status
records are zero under target/publication/publish.selection.pcrdC2. The real
metrics-0.24.0 journal is complete with validated/prepared receipts retained.

[Migration](../../releases/metrics/0.24.md) explains the native trait identity cut
from Wire 0.12 to 0.13. Principal/Account schema consumers align canonical Types
0.15 identities; tested suppliers are Types 0.15.1 and facade 0.15.2 principal only.
Published Metrics 0.23.2 continues to supply the old Wire 0.12 pairing. Logging
and arithmetic-only consumers need no paired upgrade.

Root Metrics still selects optional native Wire/typescript, with no Types,
Platform, Endpoint or runtime integration dependency. Minimal/recording and Wasm
profiles exclude Wire. Logging remains dependency-free. Arithmetic, typed errors,
schema shapes, encoded bytes and feature boundaries are unchanged. Only Wire/
Derive and the selected Metrics version/lock identity advanced in this adoption.

## Validation and delivery evidence

The [qualification receipt](../evidence/wire-0130/README.md) distinguishes the
original source-aligned probe from subsequent registry-only acceptance.
Deployment evidence is under target/audits/deploy-wire013-20261031/:

- Standard release full local ci/msrv gates passed (116s/2s), followed by prepared
  archive verification, exact staging/commit/tag and atomic GitHub delivery.
- Publication native/Wasm Clippy and real Cargo dry run passed; the selected
  ic-metrics 0.24.0 upload completed successfully. Logging was not uploaded.
- Official index, downloaded registry crate, checksum/VCS verification and refs
  remain in metrics-after.jsonl, ic-metrics-0.24.0.registry.crate,
  registry-verification.txt and remote-after.txt.
- A separate registry-only consumer selects Metrics 0.24.0, Core 0.13.0,
  Types 0.15.1 and facade 0.15.2. All three identity/composition tests pass on
  Rust 1.91, with strict Clippy and a Rust 1.91 Wasm check. Its locked graph
  contains one of each supplier and no Endpoint, runtime guard, CDK or IC0.
  It uses no copied Metrics source or external path supplier.

Earlier focused source evidence at target/audits/wire-update-20261031/ retains
its original scope: eight transport/schema tests, 15 doctests, four production
profiles, four minimal Serde tests, allocator-free Rust 1.91 Wasm linking and
exact before/after five-report Rust/TypeScript vectors/generated code. The earlier
transient disk-full interruption recovered without agent cleanup of artifacts.
All previous release/failure/evidence records remain retained.

## Ownership and remaining scope

Canonical release ledgers remain under releases/<group>; root changelog is an
index and root Cargo has no version. Explicit RELEASE_GROUP is required for
release/resume/publication. Shared Tooling stays snapshot 0.27.17 at 99d04d1,
and Build stays 0.73.0; no tooling update was bundled.

This deployment completes the requested publication prerequisite for native
Wire 0.13 consumers. Downstream applications and persistence adapters retain
complete integration acceptance. Wire #36 keeps its separate hosted acceptance;
Tooling #274's older completed scope must not reopen. Hosted native CI remains
asynchronous, and no installed IC/browser qualification is inferred from local
results. A final documentation-only commit records delivery without changing
package payloads. No further numeric bump or sibling effect is pending here.
