# Maintained source origins

Inventory updated on 2026-11-13. Scope is the current maintained product source,
tests, examples, consumer scripts, generated-fixture templates and tooling
snapshot. Build outputs, downloaded tools and historical frozen candidates are
not maintained product source.

| Component | Current location | Source record |
| --- | --- | --- |
| Metrics | `crates/ic-metrics` | Repository scaffold introduced at `975dabc`; implementations and tests developed in this repository's subsequent history. |
| Logging | `crates/ic-logging` | Heap engine introduced at `537f6d7`; subsequent engine, checkpoint and typed-history changes are recorded here. |
| Shared tooling | `vendor/toko-tooling/` and canonical root files, recorded in `.toko-tooling.snapshot` | Authenticated crates.io `toko-tooling` 0.42.1; archive SHA-256 `697b19c709eccb5f25c0abb0156766ded116abd8bde1552b20022b8af6f51dce`. |
| Local release and CI adapters | Consumer-owned files under `scripts/`, `ci/` and `Makefile` | Repository history; shared implementations are distinguished by the snapshot receipt. |

The local Git author inventory contains the `borovan` identity with two email
addresses. No submodules or maintained binary assets were found. The vendor
tree contains the authenticated shared-tooling payload. Product Rust source contains no third-party attribution
headers or imported-implementation notices. These are source-inventory findings;
the exact introduction and modification records remain in Git.

Both production libraries have no normal or build dependencies. The root catalog
selects `num-bigint` for external test oracles, `serde` for public trait-refusal
tests, and `toko-tooling` for development tooling. Their external dependencies
resolve through the tracked Cargo.lock and remain separate registry packages,
not copied implementations inside the product tree. Downloaded executables and
their source caches are likewise external inputs, not authored product code.

Validation checked Cargo's actual package inventories and both generated archives,
including the source-content verifier and refusal of modified distribution inputs.
The tooling receipt verifies its selected payload independently. Current raw
origin inventory and focused checker results are under
`target/evidence/toko-tooling-0392/`. Current tooling admission is recorded under
`target/evidence/toko-tooling-0396/`; documentation navigation and package-input
checks are under `target/evidence/docs-cleanup-20261110/`.
