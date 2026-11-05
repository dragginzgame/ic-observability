# Shared Tooling and group-validation patch delivery — 2026-11-03

> Historical release receipt. See [evidence retention](../README.md#retired-raw-evidence)
> for current artifact availability; the original identities and observations below are not fresh qualification.

Delivered from `/home/adam/projects/ic-observability`, branch `main`, after the
maintainer explicitly approved direct delivery to `origin/main`, both group tags
and crates.io publication. No alternate delivery checkout was used.

The [qualified adoption](../tooling.md) is committed as
`973ccdfe849fc499f17988b1e296584393d2897a`. It selects Shared Tooling 0.28.0
revision `70939d3b6ca335cb718363b47f15cc616c3bed1c`, with 145 verified files.
That supplier's reviewed ledger remains Unreleased; no supplier tag is claimed.

## Released identities

| Package | Source before version preparation | Release commit | Annotated tag |
| --- | --- | --- | --- |
| [ic-metrics 0.28.1](https://crates.io/crates/ic-metrics/0.28.1) | `973ccdfe849fc499f17988b1e296584393d2897a` | `3b4c4c353dff8d7746016ceb03091c6b6e611b38` | [metrics-v0.28.1](https://github.com/dragginzgame/ic-observability/releases/tag/metrics-v0.28.1) |
| [ic-logging 0.24.4](https://crates.io/crates/ic-logging/0.24.4) | `3b4c4c353dff8d7746016ceb03091c6b6e611b38` | `97c274403b07c993a251adad85848f463c5cc805` | [logging-v0.24.4](https://github.com/dragginzgame/ic-observability/releases/tag/logging-v0.24.4) |

Each `make release-patch RELEASE_GROUP=...` completed the canonical fresh
preflight, validation, metadata/archive preparation, commit/tag and atomic
main/tag push. Each release changed only Cargo.toml, Cargo.lock, its own literal
package version and its own ledger. The other group's version and notes were
preserved. Shared history and the root changelog index retain their identities.

Both plans selected workspace scope because this batch changes shared tooling.
All 21 stages passed independently for each source/group. Summed stage durations
were 902 seconds for Metrics and 913 seconds for Logging, including source
checkpoints and fixture execution; these are CI durations, not IC performance
measurements or a claimed speed improvement. The plans retain Rust 1.99.1 native
and Wasm compilation/lint, dependency graphs, tests, documentation and archives.
No stage reuse or package-version projection was enabled.

## Official registry and archive proof

Each group passed `make publish-check`, then one `make publish-verified`
invocation uploaded the selected package and performed readback. Verification
observed a non-yanked official version, matched the downloaded archive's SHA-256,
fetched the exact GitHub source and compared every maintained packaged file.

| Package | Maintained files | Official archive SHA-256 |
| --- | ---: | --- |
| ic-metrics 0.28.1 | 32 | `36f4cee8fabc7a60bc940c0f9b964341decd2fef34ff9a572e8fefec449158d4` |
| ic-logging 0.24.4 | 12 | `51f91df8c34f3997dda62df829b222678314652bd8244f0d54fadcb35f1fb9b3` |

Metrics was published and verified before starting Logging's release. Reconcile
future uncertainty with `make verify-publication RELEASE_GROUP=...`; do not
repeat an upload as verification. Native GitHub CI remains asynchronous on Linux
and both macOS hosts. Its observed release runs were pending/in progress; this
receipt does not claim hosted or native macOS acceptance.

## Retained local evidence

- Delivery logs, initial registry observations, remote refs and the preserved
  unrelated Cargo.toml comment patch: `target/deploy/shared-tooling-0280-20261103/`.
- Metrics plan and complete runner evidence:
  `target/release-validation/metrics-0.28.1.mv9g6h/`.
- Logging plan and complete runner evidence:
  `target/release-validation/logging-0.24.4.dRb2Qp/`.
- Release journals/receipts: `.git/release-state/metrics-0.28.1.plan`,
  `.git/release-state/logging-0.24.4.plan` and their matching state directories.
- Official readbacks: `target/publication/verification.aUk32y/` and
  `target/publication/verification.3ki4fu/`.

The separate pre-existing root Cargo.toml comment edit is restored in the working
tree independently of the delivery commits. Its safety copy remains
in the local Git stash and the delivery evidence directory. No sibling checkout
was changed, and no unrelated artifact cleanup was performed.
