# Current handoff — 2026-11-01

Deployment of the accepted improvement batch is now authorized: integrate
published-consumer CI artifact retention, Wire 0.13.5 qualification,
Logging visitor/topic model extensions and exhaustive histogram bound-set
coverage. [Evidence and limitations](../evidence/qualification-models-20261101.md)
record exact dependencies, checks and retained failures.

The incoming root Wire/Derive 0.13.5 lock update is preserved byte-for-byte.
Both independent qualification locks now select that published patch too; only
their two version/checksum records change. Official metadata and archive hashes
agree and report non-yanked versions. All other dependencies and package versions
remain unchanged: Metrics 0.24.5, Logging 0.23.6, Wire minimum 0.13.2, canonical
Types 0.15.1/facade 0.15.2. No endpoint or runtime enters Metrics' production graph.

Both identity probes pass strict Clippy, three Principal/Account schema/byte/error
tests on Rust 1.91 and Wasm compilation. The published probe composes actual
registry Metrics 0.24.5/Logging 0.23.6 and runs that application on the Rust floor;
the separate source probe remains workspace-owned Metrics 0.0.0 alignment.
Generated TypeScript/runtime, Rust/TypeScript vectors and consumer inputs match
an executed 0.13.3 baseline byte-for-byte. Production graph profiles, minimal
Serde tests and the Rust 1.91 allocation-free Wasm link pass.

The earlier recommendation overlooked existing independent models. This batch
extends those owners: Logging checks visitor Break progress and absent versus
empty topics during mixed admission/retention/restoration histories; histogram
restoration enumerates all 16 bound subsets of the 0..=3 observation domain.
Strict selected Clippy, both short Logging model tests and all seven histogram
restoration tests pass. The ignored long Logging exploration remains unrun.
No production Rust implementation, public API, schema, bytes or Rust floor changed.

The workflow retains published fixture manifests/locks, expected identity,
metadata and probe sources alongside logs, including on failure. Actual path
expansion, Actionlint and the existing CI selection fixture pass. These are local
checks; no fresh hosted upload/native macOS result is claimed. The first Metrics
lint failure and incomplete baseline compiler attempt remain retained alongside
their corrected successful checks under target/improvements/qualification-models-20261101/.

Pending notes reserve Metrics 0.24.6 and Logging 0.23.7; own versions have not
advanced yet. Deliver the source PR, then run each group's standard patch release,
publication dry run and verified upload. Complete full CI/MSRV at each release;
then advance and execute the separate registry consumer against the new pair.
Neither selected candidate exists on crates.io at pre-deployment observation.
Retain deployment logs under target/deploy/qualification-models-20261101/.
No new owning issue or unresolved product defect was found; cleanup stays excluded.

The previous authorized deployment remains complete: [PR #114](https://github.com/dragginzgame/ic-observability/pull/114),
[PR #115](https://github.com/dragginzgame/ic-observability/pull/115) and
[PR #116](https://github.com/dragginzgame/ic-observability/pull/116) are merged.
Metrics 0.24.5 and Logging 0.23.6 are Git-released, crates.io published and
verified; [the delivery receipt](../evidence/consumer-recipes-delivery-20261101.md)
retains exact source/checksum evidence and hosted status at its observation.
Do not replay those uploads. Standard journals, original failed release logs
and publication readbacks remain under .git/release-state/ and target/ as recorded
there. Metrics 0.24.2 stays Git-only and unuploaded; Canic stays separately owned.

Shared stays reviewed 0.27.23 at 619d194875369e0f72b45477b66adb430acbf6b7.
No sibling checkout was modified. No Observability publication is required solely
for the compatible Wire patch; already-published Metrics permits it. Retained
historical [Wire evidence](../evidence/wire-0133.md) keeps its original scope.
