# Shared Tooling 0.28.2 and Observability #129 — 2026-11-03

Adopted released revision `5cf67f81c50c56ac17389ae71a3a87d46e86e8a2`
through the canonical snapshot exporter. The clean supplier checkout, remote
main and annotated `v0.28.2` target agreed; the release ledger is dated 2026-11-03.
All 148 selected files verify. Relative to the prepared 0.28.1 snapshot, selected
changes are governance/adoption guidance; the shared runtime interfaces are
unchanged. The supplier's runner-fixture depth regression stays with its owner.
No producer regression matrix was copied or replayed.

## Consumer implementation

[#129](https://github.com/dragginzgame/ic-observability/issues/129) is implemented
in the current working tree on base `6fd6efc443fd32222416081c6b7dae3d3674815c`.
No open PR covered the work at review. The
[prepared 0.28.1 implementation evidence](shared-tooling-0281-20261103.md)
retains its original source and results; this adoption completes the same batch.

- Full CI and release selection use `ci/release-validation.json` as their one
  ordered stage declaration. Shared's roster helper admits it; local Make-text
  reconstruction is removed. Full CI forces workspace scope and dispatches each
  obligation once per host.
- Shared owns annotated-baseline observation and fresh plan/policy, event,
  timing, checkpoint and log admission. The private consumer wrapper retains
  product mapping, source/configuration and protected-receipt byte custody.
- Consumer receipt identity `group-validation:2` binds the Shared proof before
  version preparation. Late recovery preserves that sealed evidence and uses
  existing metadata/index/source checks. Physical-root binding rejects proof
  relocation. No version projection, old-receipt reinterpretation or stage reuse
  was introduced.
- The [product obligations](../independent-releases.md) explicitly retain both
  packages' feature/native/Wasm/archive checks, reverse-consumer ownership, three
  native hosts, installed-artifact boundaries and conservative shared/unknown
  scope. Library APIs, transport shapes and retained-data contracts are unchanged.
- Routine CI keeps caller/mapping/custody regressions. Matched full/selected
  comparisons have the explicit `release-validation-qualify` lifecycle, renewed
  for relevant changes. The metadata fixture's two ordered substitute stages
  prove the real renderer/recovery boundary without unrelated fake gate replay;
  the production roster remains 21 stages.

## Focused acceptance evidence

Executed on Linux with prepared Rust 1.99.1 and the pinned release editor:

| Check | Result and scope |
| --- | --- |
| `VALIDATION_RUNNER_DEPTH=3 make release-validation-qualify` | Passed both group mappings, shared/unknown/manifest broadening, required/excluded failures, roster/input drift, incomplete/tampered evidence, recovery, relocation/configuration refusal, full-CI workspace enforcement, lint ordering and pipe-jobserver propagation. Uses real shared helpers/runner with substitute Make effects. |
| `bash scripts/release/test-release-admission.sh` | Passed both real consumer metadata flows, renderer rollback, protected-proof tamper rejection, hidden-index rejection, commit/tag interruption/resume and unrelated-group preservation. Broad gates, archive compilation and upload are substituted; retained consumers execute real Rust. |
| `make tools-check shared-tooling-check` | Passed existing prepared selections and all 148 snapshot hashes. No installation or tool/dependency upgrade was needed. |

Raw records: `target/shared-tooling-0282-impact.log`,
`target/shared-tooling-0282-qualification.log`,
`target/shared-tooling-0282-admission.log` and
`target/shared-tooling-0282-tools.log`. The actual metadata fixture remains under
`target/observability-release-groups.72Ap6r/`. Earlier unchanged Make/publication
routing checks retain their 0.28.1 evidence; script syntax, links and diff
consistency are checked with this batch.

Implementation and local qualification are complete. The issue remains open for
delivered-source and required native CI acceptance: an uncommitted draft has no
hosted result. No full repository suite or new native macOS acceptance is claimed.
No library source, Cargo.lock or package version changed; published identities
remain Metrics 0.28.1 and Logging 0.24.4, with pending notes for 0.28.2/0.24.5.
The pre-existing Cargo.toml comment edit is intact. No sibling checkout, real
Git refs, release or publication was mutated by this update.
