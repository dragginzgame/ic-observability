# Current handoff — 2026-11-01

The authorized deployment is complete. [PR #111](https://github.com/dragginzgame/ic-observability/pull/111)
is merged. Metrics **0.24.4** and Logging **0.23.5** are Git-released, crates.io
published and verified against registry metadata, checksums, clean source
provenance and maintained package contents. The
[delivery receipt](../evidence/delivery-confidence-20261101.md) records exact
commits, tags, checksums, qualification and retained logs.

The final private consumer update selects exact published Metrics **0.24.4**.
Its catalog/lock and examples now match the completed publication. Strict Clippy,
three real Principal/Account schema/byte/refusal tests on Rust 1.91 and Wasm
compilation pass against the registry package. Only Metrics' version/checksum
changed in that lock; all other supplier identities remain unchanged. Acceptance
requires EXPECTED_METRICS_VERSION explicitly and rejects stale intent before
Cargo effects. Ordinary checks never resolve/update to a newer registry package.

This delivery adds maintained archive-content verification, early Make/Node/npm
admission, failed-observation status preservation, smoke outcomes in diagnostic/
recovery evidence, and Logging corruption/extended UTF-8 model tests. Package
APIs, production library behavior, schemas/bytes and dependency isolation are
unchanged. Node/npm must be prepared before either group release; ordinary Rust
and native CI remain Node-free. Future registry acceptance updates are deliberate
post-publication work, never a reason to replay an upload.

Both final standard releases passed complete local CI/MSRV and standard archive/
publication checks. PR-head hosted Linux, Apple Silicon, MSRV and TypeScript have
passed; Intel macOS is asynchronous at the delivery receipt's observation.
The receipt identifies that pre-release source independently of release commits.
Shared Tooling remains reviewed **0.27.23**, revision
619d194875369e0f72b45477b66adb430acbf6b7. Metrics' optional native metadata remains
on Wire/Derive **0.13.2**. Canonical Types **0.15.1**/facade **0.15.2** remain
private probes; no Platform runtime or endpoint integration enters the core.

Deployment logs remain under target/deploy/delivery-confidence-20261101/;
publication receipts are target/publication/verification.YAOIMw and
target/publication/verification.38RFWN. Plans, validation and earlier attempts
remain under .git/release-state/. No cleanup or sibling edits ran.

Earlier history remains in the [previous receipt](../evidence/verification-wire-0132-delivery.md).
Metrics 0.24.2 is Git-only and was never uploaded; preserve that tag and history.
PRs #108–#110 are merged, #107 is completed and superseded
[#105](https://github.com/dragginzgame/ic-observability/pull/105) is closed.
Canic #712/#100 retain separate ownership. No further product release is required
for the private qualification/receipt update. Do not replay completed uploads.
