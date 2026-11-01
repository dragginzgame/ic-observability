# Current handoff — 2026-11-01

The maintainer now authorizes PR delivery/integration, standard patch releases,
crates.io publication and closure of resolved owning issues. Deliver the prepared
batch through chore/verification-wire-0131 against main, then release Metrics
0.24.2 and Logging 0.23.4 separately. Use the direct group release workflow and
publish each clean release-tag checkout before advancing to the other group.
Issue #107 is the only open owning issue found; close it when integrated.
No sibling edits or artifact cleanup are authorized or needed.

The latest request adds published Wire/Derive 0.13.1 to the existing local batch.
The root requirement and isolated identity lock now select that patch. The root
lock already selected it at task entry and was preserved; all unrelated dependency
records are unchanged. The [Wire patch receipt](../evidence/wire-0131.md) records
registry identities and current native/TypeScript/identity/Wasm/graph checks.
It stays within pending Metrics 0.24.2; Logging needs no paired Wire release.

The maintainer previously accepted five improvements: prose-only CI, publication
verification, maintained Principal/Account qualification, TypeScript static
checking, and consumer/package docs. Implementation is in the working tree on
main at base 03b2bd7 (the prior delivery receipt).
No sibling checkout or own package version was changed. The earlier improvements
remain intact and are included in the authorized delivery.

## Implemented changes

- Shared 0.27.23 at 619d194875369e0f72b45477b66adb430acbf6b7 was reviewed and
  canonically exported from an isolated clean checkout, including the existing
  classifier, registry observer and package-provenance helpers. No snapshot
  payload was patched. No root VERSION/pending-file mode was introduced.
- [#107 — Adopt conservative documentation-only CI selection](https://github.com/dragginzgame/ic-observability/issues/107)
  has a local implementation. The exact allowlist excludes packaged/embedded/
  companion-controlled Markdown. Exact PR/push identities use complete history.
  Existing native/MSRV/TypeScript job names stay stable; prose runs Linux docs/
  snapshot checks and explicit scope summaries. Unknown/mixed/policy/missing-history
  inputs select full checks. Classifier job failure also runs full checks and
  remains visibly failed. Full release gates never use the shortcut.
- Publication admission now precedes Clippy and requires a clean exact group-tag
  checkout plus matching annotated tag on the declared repository. Dry runs keep
  their prior preparation role. publish-verified calls the existing publisher,
  then verify-publication for non-yanked metadata, archive checksum and clean
  source provenance through Shared helpers. Readback failures never replay an
  upload; verify-publication is independently repeatable and read-only remotely.
- qualification/wire-identities contains a probe template, integration catalog
  and independent lock. Its generated workspace owns the verbatim Metrics copy
  at version 0.0.0 and the probe; no external source-less path package is used.
  Root Wire/Serde selections are projected rather than duplicated. Wire/derive
  now resolve to published 0.13.1 in both locks; Types 0.15.1
  and facade 0.15.2 are the retained qualified pairing. Strict development Clippy,
  three real identity/schema/byte tests on Rust 1.91 and a Wasm check are maintained.
  This is source alignment, not registry acceptance of the working-tree changes.
- The pinned TypeScript 7.0.2 tool uses an independent npm lock. Generated
  runtime/report code and a typed consumer now compile before the existing five
  runtime report cases. Rejection checks cover number/bigint, option wrappers,
  missing report shapes and decoded totals. Ordinary Rust tests remain Node-free.
- Installation docs now select published package lines; crate-local README and
  changelog links no longer require files outside the archive. Cargo's actual
  file selection is staged for local-link checks. Native input hashing includes
  qualification inputs and excludes installed node_modules. Standalone probe
  Rust formatting is wired through Shared's existing formatter interface.

## Evidence and remaining delivery

Focused evidence is retained at target/improvements/20261031/:

- Selected Metrics Clippy, TypeScript static/runtime conformance, three identity
  tests plus Wasm, and four root feature/dependency profiles pass. The arithmetic
  graph and dependency-free Logging contract are unchanged.
  These affected checks were rerun for Wire 0.13.1 under
  target/audits/wire-0131-20261031/, including eight native metadata tests on
  Rust 1.91 and exact comparison with retained pre-update schema/byte outputs.
- Actual CI-selector fixtures cover prose, code, mixed, policy, absent history,
  tag refs and classifier failure. Actionlint and selected ShellCheck pass.
- Publication fixtures cover untagged/dirty/staged/later source, absent remote
  tags, 403 versus 404, yanked versions, corrupt archives and real local Git
  provenance. The actual Make wrapper proves no second upload after readback
  failure. Both real group-admission directions and standard Make adapter pass;
  broad gates/uploads are substituted in those fixtures.
- Live readback-only qualification succeeds for already-published Metrics 0.24.1
  and Logging 0.23.3, matching their existing release commits and registry checksums.
  No upload ran. Receipts: target/publication/verification.0bJGaM and
  target/publication/verification.rkTKcK.
- Snapshot integrity, dependency pins, current/package-shaped docs links and both
  pending-ledger checks pass. The actual formatting-hook/custody fixture passes
  with the standalone probe source selected. Initial fixture assembly/manifest and lint failures
  were corrected; failed logs remain alongside the passing attempts.

Pending compatible notes are Metrics 0.24.2 and Logging 0.23.4; published package
versions remain 0.24.1 and 0.23.3 before release preparation. Issue #107 remains
open pending integration. Full local ci/msrv gates will run through each standard
release command. Hosted workflow execution remains asynchronous and distinct
from the focused local evidence already recorded.
The existing [release receipt](../evidence/shared-tooling-02722-delivery.md)
retains the completed previous deployment. All journals/artifacts remain intact.
Canic #712/#100 and downstream adoption retain their separate ownership.
