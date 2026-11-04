# Metrics 0.29.1 and Logging 0.24.6 delivery — 2026-11-04

Both independent patches were released to GitHub and uploaded once to crates.io
under the authorized deployment. Delivery used this normal checkout on `main`,
`origin/main` and the standard direct release/publication adapters. No sibling
checkout was changed. The implementation is `997a85ec3c94f22ed3488c5a1f281db7738428bf`.

| Group | Qualified source | Release commit | Annotated tag |
| --- | --- | --- | --- |
| Metrics | `997a85ec3c94f22ed3488c5a1f281db7738428bf` | `9de6d2c656998f86b019771119f530c25e9b8618` | [metrics-v0.29.1](https://github.com/dragginzgame/ic-observability/releases/tag/metrics-v0.29.1) |
| Logging | `9de6d2c656998f86b019771119f530c25e9b8618` | `434314b0f8c3b7f70abe8388635d408309dada39` | [logging-v0.24.6](https://github.com/dragginzgame/ic-observability/releases/tag/logging-v0.24.6) |

Tag objects are `2eb5d78b664e0e61cc8b2d9f351e62e85e1bf0b5` for Metrics and
`1431d9d909ddd91599a0130d18618d2f4af80e45` for Logging. Each runner atomically
pushed its exact branch/tag and changed only the selected group's manifest,
catalog requirement, lock entry and owning ledger, finalizing the UTC date.

The [adoption receipt](shared-tooling-0294-20261104.md) and
[earlier cleanup receipt](shared-tooling-0293-20261104.md) own the changes and
focused evidence. Shared Tooling remains committed revision
`628ccc75d813bfd9bae777bfbaef55838d25b1b2`, version 0.29.4, with 149 verified files;
its Unreleased status is not reinterpreted as a tagged supplier release.
Library APIs, feature isolation and retained-data contracts are unchanged.

Both groups selected workspace scope and passed all 21 release stages: strict
native/Wasm Clippy before product tests/archives, graphs, allocator-free Wasm link,
native evidence, complete release/recovery fixtures, tests, Rustdoc and packages.
No stage reuse or version projection ran. Sealed plans/proofs and raw logs remain
under `target/release-validation/metrics-0.29.1.Ln6Eck/` and
`target/release-validation/logging-0.24.6.VvyMkQ/`. Protected matching plans under
`.git/release-state/` are complete.

Both publication dry runs passed before one upload per package. Cargo compiled
each archive. Official registry readback confirms non-yanked versions, archive
checksums and exact Git source, including all 29 maintained Metrics files and
13 maintained Logging files:

| Package | Registry | Archive SHA-256 |
| --- | --- | --- |
| ic-metrics 0.29.1 | [crates.io](https://crates.io/crates/ic-metrics/0.29.1) | `b47d4ea14ea9865bda223dc16a5411d960360ca872dc2829671f50710be0cb08` |
| ic-logging 0.24.6 | [crates.io](https://crates.io/crates/ic-logging/0.24.6) | `42df20b32c64ae2e8ea3544bf26f5f8bc1cfeb9e7d9ebeb16c5ebd611e2a7f69` |

Upload intent/arguments/status remain under `target/publication/publish.selection.rJmVEE/`
and `target/publication/publish.selection.6Dskxn/`. Registry/archive/source proof:
`target/publication/verification.OKWZn4/` and `target/publication/verification.vIQfAP/`.
Top-level logs and initial absent-version observations remain under
`target/deploy/observability-20261104/`. Use `make verify-publication RELEASE_GROUP=metrics`
or `RELEASE_GROUP=logging` for reconciliation; do not upload these versions again.

The unrelated lowercase Cargo comments were preserved in dedicated stash
`06ee2eaf4bf79bc230b27c702fbdd62d7acd9e44` and safety copies, then restored after
clean-checkout uploads with current released versions preserved. The stash and
all earlier failed/original recovery evidence remain retained; no cleanup ran.
Hosted Linux/macOS CI is asynchronous; local release evidence does not establish
current three-host acceptance. Consumer migration work remains with its owners,
including [#130 — Restrict Metrics to instrumentation](https://github.com/dragginzgame/ic-observability/issues/130).
