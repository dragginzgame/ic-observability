# Current handoff — 2026-11-01

The maintainer authorized latest Wire adoption and deployment. Official sparse
registry metadata identifies **Wire/Derive 0.14.2** as the latest stable release.
Metrics **0.25.1** is selected for the compatible patch; Logging stays 0.23.7.
No Metrics 0.25.1 exists on crates.io at pre-deployment observation. Integrate the
scoped source PR, run the standard Metrics patch release with complete CI/MSRV,
then publication dry run and verified upload from its exact clean group tag.

The incoming root lock already selected Wire 0.14.2 and remains byte-identical.
Both independent locks and the published Wire catalog pin now select 0.14.2 too.
Only Wire/Derive version/checksum records change relative to committed locks;
all other records remain unchanged. Root minimum stays 0.14.0, canonical Types
0.16.0/Platform 0.17.0 stay isolated integration suppliers, and own versions are
still Metrics 0.25.0/Logging 0.23.7 until the standard release prepares metadata.

[Qualification evidence](../evidence/wire-0142.md) records non-yanked metadata,
archive checksums and identical source payloads versus published 0.14.0 (22 Core,
three Derive files). All three graph manifests pass locked metadata; each probe
selects one expected Wire/Types identity, with only workspace-owned source-less
packages and no endpoint/runtime/CDK/IC0 packages. Selected Metrics/root and both
probe Clippy checks pass. Both three-test identity probes, the existing registry
composition and both Wasm checks pass on Rust 1.91. Node/TypeScript executes all
five report cases. The full release gate remains mandatory after integration.

Source alignment uses copied Metrics 0.0.0; the separate registry check still
uses actual Metrics 0.25.0 and Logging 0.23.7 with Wire 0.14.2. After publishing
0.25.1, advance the independent catalog/lock and frozen CI intent to that exact
Metrics version and execute registry acceptance again. No source-copy or earlier
published identity is proof of that future release. No upload may be replayed
for a readback failure; use verification-only recovery.

No production Rust implementation, numeric schema, bytes, error or Rust floor
changed. Arithmetic-only and recording-only graph isolation retain their owners;
all-feature Wasm excludes native metadata. The complete release gate rechecks
these boundaries. Logging remains dependency-free; no Logging release is selected.
[Migration guidance](../../releases/metrics/0.25.md) still requires Metrics ^0.25 /
Wire ^0.14 and Types ^0.16 or Platform ^0.17 for canonical identity composition.

Raw adoption proof remains under target/adoptions/wire-0142-20261101/; deployment
logs under target/deploy/wire-0142-20261101/. Earlier [0.14.1 evidence](../evidence/wire-0141.md)
retains its original source/graph scope. No cleanup, history rewrite or sibling
edit is authorized. No open issue or existing competing adoption PR was found.

Prior [Wire 0.14 delivery](../evidence/wire-0140-delivery-20261101.md) remains
complete: Metrics 0.25.0 was uploaded once and verified, PRs #119/#121 merged,
and issue #120 closed. Do not replay that upload. Historical Metrics 0.24.2
remains Git-only/unuploaded. Canic stays separately owned. Shared stays reviewed
0.27.23 at 619d194875369e0f72b45477b66adb430acbf6b7.
