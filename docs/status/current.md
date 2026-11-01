# Current handoff — 2026-11-01

Wire 0.14 deployment is authorized. It reuses existing
[PR #119](https://github.com/dragginzgame/ic-observability/pull/119), head
052c9232ec79c987f270f056af1b2303ae704cae, applied to main base
17753678d6e4fecb28a88a080f123533359d5b0d. Do not create a competing adoption PR.
Local additions clarify the breaking release note, owning issue, migration and
publication boundary. Update that existing PR with the qualified local additions,
integrate it, then run the standard Metrics minor release and verified publication.

Root native Metrics metadata now selects published Wire/Derive 0.14.0. The
source-alignment consumer selects canonical Types 0.16.0/Platform 0.17.0.
Official exact-version metadata and downloaded archive checksums verify all
four non-yanked suppliers. [Qualification evidence](../evidence/wire-0140.md)
records the reused contribution and fresh local checks with retained artifacts.

The historical registry consumer deliberately retains exact Metrics 0.24.6,
Logging 0.23.7, Wire/Derive 0.13.5 and Types 0.15.1/Platform 0.15.2. Its unchanged
lock remains independently owned; its catalog now explicitly pins Wire and
identity suppliers instead of inheriting the advancing root/source selections.
The fixture projector respects those separate owners. It continues to require
an explicit Metrics version and rejects absent/malformed/stale intent.

Full locked offline metadata admits all three graph manifests before Clippy.
Both identity graphs select exactly one expected Wire/Types family, with only
workspace-owned source-less packages and no endpoint/runtime/CDK/IC0 packages.
Strict affected Metrics/root and both probe Clippy selections pass. On Rust
1.91, 12 Wire tests, three source identity tests, three historical registry tests,
the historical composition example and native/Wasm obligations pass. Four
Serde-only tests, all four production graph profiles and the allocator-free
Wasm arithmetic link pass. Arithmetic-only/default-disabled Metrics still omits
Wire, and all-feature Wasm omits native metadata. Logging remains independent.

Generated reports/runtime, Rust/TypeScript vectors, typed consumer and tsconfig
are byte-identical to an executed Wire 0.13.5 baseline. The pinned Node 24.21.0
and TypeScript 7.0.2 run all five report cases. ShellCheck, selection refusal,
documentation links and dependency pins pass. Actual logs, baseline, archives,
metadata, policies and comparison hashes remain under target/adoptions/wire-0140-20261101/.
No production Rust implementation, numeric schema, bytes or Rust floor changed.
No broad local CI/MSRV or new hosted/macOS qualification is claimed.

Pending Metrics **0.25.0** is a minor release because native Wire trait identity
is exposed to schema consumers. [Migration notes](../../releases/metrics/0.25.md)
require aligned Metrics ^0.25/Wire ^0.14, with Types ^0.16 or Platform ^0.17 for
Principal/Account schemas. Current own versions remain Metrics 0.24.6/Logging
0.23.7. Only Metrics is selected for this deployment. Metrics 0.25.0 was absent
from crates.io at pre-deployment observation. Run full CI/MSRV through the release
adapter and retain logs under target/deploy/wire-0140-20261101/.

[#120 — Align native Metrics schemas with published Wire 0.14](https://github.com/dragginzgame/ic-observability/issues/120)
remains open: source compatibility is qualified, but its registry-only acceptance
requires published Metrics 0.25.0. Only Metrics needs publication; Logging has no
Wire dependency. After release, advance the frozen published catalog's Metrics,
Wire, Types and facade together, then run explicit acceptance. Do not mislabel
source-copy evidence or the passing historical graph as new registry acceptance.
Read-only downstream review did not authorize or perform sibling edits/builds.

The prior [qualification/model deployment](../evidence/qualification-models-delivery-20261101.md)
remains complete: Metrics 0.24.6/Logging 0.23.7 were each uploaded once and verified.
Do not replay those uploads. Earlier release plans, recovery evidence and receipts
retain their original scope; historical Metrics 0.24.2 remains Git-only/unuploaded.
Canic remains separately owned. Shared stays reviewed 0.27.23 at
619d194875369e0f72b45477b66adb430acbf6b7. No cleanup or history rewrite ran.
