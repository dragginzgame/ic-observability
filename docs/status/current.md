# Current handoff — 2026-11-01

The maintainer now authorizes integration and deployment of the three consumer
improvements: compiled Metrics/Logging composition, safe byte-budgeted log export
and recording-table model tests. Deliver a scoped PR, then standard patch
releases/publication for Metrics **0.24.5** and Logging **0.23.6**. Respect required
reviews/checks and run full CI/MSRV through each standard release command.
Publish each clean tagged checkout before advancing the other group.
No sibling checkout or artifact was changed. The preparation base is merged
Wire qualification commit 1cb343f1a7532e794903dbaac57e3fc52ae6ab03.

The composition example lives under qualification/wire-published/examples/.
The existing private registry consumer owns its only new dependency: exact
registry Logging 0.23.5 as a development dependency. Metrics remains exact
registry 0.24.4; all earlier supplier records are unchanged. The shared acceptance
script now lints and executes the example on Rust 1.91. It counts log admission,
truncation, eviction and refusal with Metrics counters and verifies that a host
metrics-window reset preserves the log's sequence. Neither library gains a
dependency on the other. The source-copy probe selects no Logging.

The TypeScript CI job now prepares and runs the frozen registry consumer as well
as source qualification. PUBLISHED_METRICS_VERSION=0.24.4 is its explicit historical
intent. Advance that workflow intent with the catalog and lock when deliberately
selecting another published Metrics version; it is not proof of a future release.
The standalone application source is selected by the existing formatter owner;
its hook/custody and standard Make fixture callers were updated and pass.

The byte-budgeted export example is packaged with Logging and has test=true, so
ordinary Cargo tests select its regression cases. It uses the last emitted
sequence when Break consumes an un-emitted candidate, preserves filtered-empty
continuation and returns a typed oversized-first-row error. The ceiling applies
to returned UTF-8 body bytes, not temporary formatting allocations or transport
envelopes. Its walkthrough and tests use the same implementation. No engine,
cursor API or serialization format changed.

Recording tests replay an independent event journal across fixed seeded
histories and combinations of entry/per-key/total-key limits. They compare
retained values, exact omitted count/total/max, cached key bytes and window
sequences through repeated/new UTF-8 keys, zero/wide observations, table clear
and whole-window reset. The reference recomputes admission and arithmetic from
raw events rather than using the engine's map, byte cache or record method.

Evidence remains under target/improvements/consumer-recipes-20261101/.
Selected Logging/example and recording Clippy pass. Rust 1.91 passes all four
export tests and all nine recording tests. Published identity acceptance passes
Clippy, three real tests, the composition execution and Wasm compilation; the
unchanged source probe also passes. Actionlint, ShellCheck, CI selection,
standard-release/format-hook fixtures, formatting, pins and docs checks pass.
Full local CI/MSRV will run through both authorized releases. Hosted checks
remain asynchronous; known failures must be repaired before continuing.
Root Cargo.lock, production dependency declarations, package versions and library
implementations are unchanged. Pending notes are Metrics 0.24.5 and Logging
0.23.6; the Logging manifest changes only the example's test-target declaration.

[PR #113](https://github.com/dragginzgame/ic-observability/pull/113) is merged and
its [Wire qualification](../evidence/wire-0133.md) preserves the incoming 0.13.3
root lock, declared 0.13.2 minimum and Types 0.15.1/facade 0.15.2 pairing.
Earlier Metrics 0.24.4 and Logging 0.23.5 are published and verified; see the
[delivery receipt](../evidence/delivery-confidence-20261101.md). Historical Metrics
0.24.2 remains Git-only and unuploaded. Preserve prior tags, journals and logs;
no release recovery or artifact cleanup is pending. Shared remains reviewed
0.27.23 at 619d194875369e0f72b45477b66adb430acbf6b7. Canic stays separately owned.


Deployment logs belong under target/deploy/consumer-recipes-20261101/ and the
standard .git/release-state/ journals. After both publications, deliberately
advance the private registry catalog/lock to Metrics 0.24.5 and Logging 0.23.6,
plus PUBLISHED_METRICS_VERSION in the TypeScript workflow. Preserve all other
supplier records. Run explicit-version identity/composition acceptance against
those registry releases, then deliver its scoped qualification/receipt update.
Readback failures must never replay an uncertain upload. No cleanup is needed.
