# Current handoff — 2026-11-01

The authorized Wire 0.14 deployment is complete. Existing [PR #119](https://github.com/dragginzgame/ic-observability/pull/119)
was updated with the qualified local additions and merged. Metrics **0.25.0**
is Git-released, crates.io published and independently verified. The
[delivery receipt](../evidence/wire-0140-delivery-20261101.md) records exact source,
tag, checksum, full gates, registry acceptance and retained work/evidence.

Release commit is 90615b5123552ac325bf58873f7e181f4c112109, annotated tag
metrics-v0.25.0. Full CI/MSRV passed in 129/2 seconds before version preparation
and atomic branch/tag push. Standard dry run and actual upload passed native/Wasm
Clippy and Cargo verification. Official non-yanked metadata, archive checksum,
clean provenance, fresh source retrieval and all 38 maintained files match.
Readback receipt: target/publication/verification.56a4aq. Upload ran once; do not
replay it. Release plan/journal remains under .git/release-state/metrics-0.25.0*.

Metrics 0.25's exposed native metadata uses Wire ^0.14. The source and published
identity probes select canonical Types 0.16.0/Platform 0.17.0. All three locks
now select Wire/Derive 0.14.0. Arithmetic-only/default-disabled Metrics omits Wire;
all-feature Wasm excludes native metadata. No endpoint or Platform runtime enters
Metrics' production graph. Logging remains dependency-free at 0.23.7; its version,
manifest and ledger did not change and no Logging upload ran.

The frozen published catalog/lock and CI intent now select exact registry Metrics
0.25.0, Wire/Derive 0.14.0, Types 0.16.0 and Platform 0.17.0. Only those five
version/checksum records change in the private lock; all others, including Logging,
remain unchanged. Strict Clippy, three real Principal/Account schema/byte/error
tests, composition execution on Rust 1.91 and Wasm compilation pass. Explicit
Metrics version selection and absent/malformed/stale rejection remain enforced.

A separate minimal registry consumer of only Metrics 0.25.0 and Wire 0.14.0
passes strict Clippy and Rust 1.91 schema generation for Aggregate, Counter,
Summary and Histograms with 0/2/37 bounds. Metadata admits one registry identity
family with no Platform/Types/runtime/endpoint/CDK/IC0 package. This resolves
[#120 — Align native Metrics schemas with published Wire 0.14](https://github.com/dragginzgame/ic-observability/issues/120)
without trait bridges. The final receipt PR closes the supplier issue; downstream
applications retain their own adoption, attribution and runtime qualification.

[Migration guidance](../../releases/metrics/0.25.md) requires Metrics ^0.25 and
Wire ^0.14 together for schemas, plus canonical Types ^0.16 or Platform ^0.17
for identities. Numeric schema shapes, encoded/retained bytes, validated Serde,
arithmetic APIs and Rust 1.91 remain unchanged. No production Rust implementation changed.
Final catalog/migration/receipt updates need no additional product release.

Hosted PR-source Linux, MSRV and TypeScript have passed; both macOS jobs remain
asynchronous at the receipt's observation. Pending jobs are not passes and are
separate from completed local release gates and actual published-consumer proofs.
Deployment logs, minimal fixture, metadata and private lock comparisons remain
under target/deploy/wire-0140-20261101/. The accepted work snapshot and patches
are retained as recorded in the delivery receipt; no cleanup or history rewrite ran.

The [adoption receipt](../evidence/wire-0140.md) preserves source-alignment,
historical registry and byte-identical TypeScript/vector comparison against
executed Wire 0.13.5. Prior [model delivery](../evidence/qualification-models-delivery-20261101.md)
retains Metrics 0.24.6/Logging 0.23.7 publication evidence; do not replay those
uploads. Historical Metrics 0.24.2 remains Git-only/unuploaded. Canic stays
separately owned. No sibling checkout was changed. Shared remains reviewed
0.27.23 at 619d194875369e0f72b45477b66adb430acbf6b7.
