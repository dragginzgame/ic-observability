# Current handoff — 2026-11-01

The authorized consumer-recipes deployment is complete. [PR #114](https://github.com/dragginzgame/ic-observability/pull/114)
and [PR #115](https://github.com/dragginzgame/ic-observability/pull/115) are merged.
Metrics **0.24.5** and Logging **0.23.6** are Git-released, crates.io published and
verified against registry metadata, checksums, clean source provenance and exact
maintained package contents. The [delivery receipt](../evidence/consumer-recipes-delivery-20261101.md)
records tags, commits, validation, failure recovery and retained evidence.

The final private consumer now selects exact registry Metrics 0.24.5 and Logging
0.23.6; CI's PUBLISHED_METRICS_VERSION intent is 0.24.5. Only their version/checksum
records changed in its lock. Strict Clippy, three Principal/Account tests,
composition execution on Rust 1.91 and Wasm checks pass against these published
packages. The source probe stays separate. Logging is a dev dependency only of
the private consumer; the two libraries retain independent production graphs.

Delivered examples cover application-owned log-admission counters and independent
metrics-window/log lifetimes, plus byte-budgeted export with continuation from
the last emitted row. Oversized first rows are typed errors, empty filtered scans
advance normally, and temporary allocations/envelopes remain host-owned. Logging's
example has test=true and runs its four regressions in ordinary Cargo tests.
Recording's independent journal model checks mixed UTF-8 identities, budgets,
omissions, clears and window resets; all nine recording tests pass on Rust 1.91.
No public API, library implementation, schema, encoded format or Rust floor changed.

The first Metrics release gate stopped before mutation on a missing copied
example target in retained-consumer qualification. PR #115 repaired the fixture;
both group directions passed and fresh full CI/MSRV gates then passed for each
release. Both standard publication dry runs and uploads passed native/Wasm Clippy
and archive verification. Both exact uploads/readbacks completed; do not replay.

Hosted repaired-source Linux, Apple Silicon, MSRV and TypeScript passed; Intel
macOS remains asynchronous at the receipt's observation. New private catalog/CI
intent changes have focused local acceptance; later hosted runs retain their own
identity. Shared stays reviewed 0.27.23 at
619d194875369e0f72b45477b66adb430acbf6b7. Wire/Derive remains 0.13.3 with the
0.13.2 minimum; canonical Types 0.15.1/facade 0.15.2 remain private integration
suppliers. No endpoint or Platform runtime enters the core.

Deployment logs remain under target/deploy/consumer-recipes-20261101/;
publication receipts are target/publication/verification.FEdTU9 and
target/publication/verification.OqQFpY. Plans and failures remain under
.git/release-state/. No artifact cleanup, sibling edit or history rewrite ran.
Prior [Wire qualification](../evidence/wire-0133.md) and
[delivery history](../evidence/delivery-confidence-20261101.md) remain intact.
Metrics 0.24.2 stays Git-only and unuploaded. Canic stays separately owned.
No further product release is needed for this qualification/receipt update.
