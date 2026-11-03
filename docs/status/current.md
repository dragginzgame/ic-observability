# Current handoff — 2026-11-03

**Metrics 0.28.1 and Logging 0.24.4 are released and verified on crates.io.**
[Delivery evidence](../evidence/shared-tooling-0280-delivery-20261103.md) records
the approved direct delivery from this normal checkout to `origin/main`, both
annotated tags, official checksums and exact maintained-file comparisons.
Source preparation: `973ccdfe849fc499f17988b1e296584393d2897a`.
Metrics release/tag: `3b4c4c353dff8d7746016ceb03091c6b6e611b38`, `metrics-v0.28.1`.
Logging release/tag: `97c274403b07c993a251adad85848f463c5cc805`, `logging-v0.24.4`.
Each group changed only its selected four release metadata files and preserved
the other group's identity/ledger. Both publication dry runs passed; each package
was uploaded once and verified before moving to the next group. Do not replay
uploads; `make verify-publication RELEASE_GROUP=...` is readback-only.

**Shared Tooling 0.28.0 and release-group validation are delivered.**
The snapshot selects 145 files from committed revision
`70939d3b6ca335cb718363b47f15cc616c3bed1c`; the producer ledger is Unreleased.
[Adoption evidence](../evidence/shared-tooling-0280-groups-20261103.md) describes
the consumer mapping and qualification. Managed tools were explicitly refreshed;
offline checks pass. Application dependency selections and Rust source are unchanged.
The unrelated root Cargo.toml comment edit is restored independently of release
commits, with safety copies in the local stash and delivery evidence directory.

Confined library changes select that release group's package checks and dedicated
native/Wasm graphs. Shared/manifests/locks, another group, unknown inputs or missing
baseline history select the full roster. The complete baseline-to-source diff,
host/compiler/configuration and every source input are retained. A versioned
successful-execution proof is bound to the release receipt and re-admitted on
prepare/resume. Old receipts keep their original meaning. No stage reuse or
version projection is enabled. The adoption itself selects full scope at release.
Repository CI remains full on Linux and both macOS hosts.

Both fresh workspace-scope release plans passed all 21 stages on Linux,
Rust 1.99.1, including native/Wasm lint, production graphs, allocator-free linking,
documentation, tests, archives and real metadata/rollback/resume fixtures.
Summed stage durations were 902 seconds for Metrics and 913 for Logging.
Scope/failure/drift/recovery checks remain qualified. Hosted CI is asynchronous;
no new hosted/macOS or IC runtime acceptance is claimed. No delivery blocker remains.

**Earlier Metrics 0.28.0 qualification remains retained.**
[Verified delivery](../evidence/metrics-0280-delivery-20261103.md) records the full
release gate, source/tag, official checksum and independent archive/consumer proof.
[#128 — Remove Metrics' Wire metadata dependency](https://github.com/dragginzgame/ic-observability/issues/128)
was closed as completed after that delivery. The current patch batch changes
release tooling and package identities, with no further library contract change.

Metrics owns measurement arithmetic, state validation and validated Serde.
Services own frontend/report DTOs, Wire metadata, codecs and generated clients.
The breaking `native-wire` feature and public Wire trait implementations are
removed. No integration crate, reverse dependency or second arithmetic owner
was introduced. Use [the 0.28 migration](../../releases/metrics/0.28.md) when adopting.
Serde field names/order, u128 totals, fixed arrays, canonical numeric admission,
error precedence and arithmetic remain intact; no supplier-owned state reset is
required. Independent restoration/recording oracles remain qualified.

Source commit: `1b47cab2fc4b6dcebe0686308b54fa01249a95e1`.
Release commit: `54a92f45c1008a56599ee42786d84553ca950215`.
Annotated tag: `metrics-v0.28.0`.
The standard minor release passed complete `ci msrv` validation (CI 136 seconds),
metadata/archive checks and atomic main/tag push. Publication dry run passed;
one upload was followed by official non-yanked/checksum/provenance verification,
fresh GitHub source retrieval and exact comparison of all 32 maintained files.
Do not replay uploads; `make verify-publication RELEASE_GROUP=metrics` is readback-only.

A fresh exact registry Metrics 0.28.0 consumer passes strict Clippy, default and
recording runtime tests, Serde/admission checks and all-feature Wasm compilation
on Rust 1.99.1. Its native default and Wasm recording normal/build graphs require
Metrics/Serde and exclude Wire/Platform families. This is actual registry proof,
separate from [implementation evidence](../evidence/metrics-wire-separation-20261103.md)
and its temporary comparison to published Metrics 0.27.2 / Wire 0.15.0.
No test DTO or Wire dependency entered the maintained graph or current CI.

Metrics-owned Node/npm setup, the browser job and source/registry pairing fixtures
are retired. Historical receipts/artifacts and retired qualification READMEs keep
their original scope. Native CI retains Linux and both macOS hosts; no enforced
required-check reference targeted the removed job at the 2026-11-03 inspection.
Hosted CI remains asynchronous; local gates claim no new macOS or IC runtime pass.

Consumer migrations remain with Blob #113, IcyDB #614, Relay #22, Storage #154 and
Canic #523, linked in the migration guide. Toko Miner also needs its explicit
feature selection removed by its owner. No sibling edits, releases or acceptance
are claimed. Timers was unavailable locally; its arithmetic-only assessment stays
with the earlier owning inspection. Producer closure does not close consumers.

Deployment used `target/deploy/metrics-0280-20261103/checkout/`. Its parent retains
source patches, reviewed paths, setup/release/publication logs and consumer proof.
Plans remain in `.git/release-state/`; readback is
`target/publication/verification.Rk6wQt/`, and the registry caller is
`target/publication/metrics-0280-consumer/` inside that checkout.
Original pre-existing inputs remain backed up under `target/issue-128/`; README
guidance was reconciled with this cut and the Wire lock refresh is superseded.
No artifact cleanup ran. The receipt/handoff follow-up needs no product release.

The earlier [Metrics 0.27.2 / Logging 0.24.3 delivery](../evidence/fixture-cleanup-delivery-20261102.md)
retains its independent package identities and checksums. The earlier
[Shared Tooling 0.27.26 adoption](../evidence/shared-tooling-02726.md)
keeps its original evidence and scope.
Historical Metrics 0.24.2 remains Git-only / unuploaded. Published history is intact.
