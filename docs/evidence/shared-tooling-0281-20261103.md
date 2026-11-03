# Shared Tooling 0.28.1 adoption — 2026-11-03

Adopted committed revision `d79aa0abbeafe78a2f57dc57b24e2a4641a96001`
through the canonical exporter after reviewing its impact and verifying remote
main. The source checkout was clean. Supplier VERSION is 0.28.1 with an Unreleased
ledger; no tagged supplier release is claimed. All 148 snapshot files verify.
Tool catalogs/build inputs are unchanged and prepared offline tools pass.

## Integration

- Shared now owns baseline observation, roster consistency and fresh execution
  evidence admission. The consumer no longer parses Git tag observations,
  generic events/timings/checkpoints or Make recipe text.
- `ci/release-validation.json` remains the single ordered 21-stage declaration.
  Both full CI and release selection admit it through Shared's roster interface.
  Full CI forces workspace scope through recursive Make and runs the roster once.
- Product policy retains the two independent single-package groups, complete
  source inventory, conservative scope/exclusions, host/compiler/configuration
  observation, source/index custody and metadata/publication admission.
- Consumer receipt identity advances to `group-validation:2`. Shared verifies
  pristine-source evidence, and the existing atomic receipt helper publishes its
  proof. The protected validated receipt binds that proof before version edits.
  Late checks preserve its bytes and all admitted records/logs, regenerate the
  original selection/configuration, and use existing prepared-metadata admission.
  Physical-root binding refuses relocation. This enables neither source/version
  projection nor stage reuse. Older receipts require their recorded adapter.
- Routine CI retains product/helper wiring and custody regressions. Matched
  full/selected traces and full-CI ordering/jobserver qualification run explicitly
  through `make release-validation-qualify` after relevant changes. The metadata
  fixture substitutes two ordered stages, focusing its real renderer/recovery
  proof without repeating an unrelated fake production roster.

## Focused local evidence

Executed on Linux with prepared Rust 1.99.1 and the pinned release editor:

| Check | Result |
| --- | --- |
| `make release-validation-qualify` | Passed both product mappings, full/selected command equivalence, forced workspace scope, lint failure ordering and actual pipe-jobserver propagation through the Shared dispatcher; Make gate effects substituted |
| `bash scripts/release/test-validation-plan.sh` | Passed ordinary mapping/helper wiring, required/excluded failures, drift, missing/tampered evidence, configuration/relocation refusal and sealed custody after prepared version/lock edits |
| `bash scripts/release/test-release-admission.sh` | Passed both real metadata/renderer flows, rollback, protected-proof tampering, commit/tag/resume, unrelated group identity preservation and publication selection in disposable local repositories; broad gates/archive compilation/upload substituted, retained consumers use real Rust |
| `bash scripts/release/test-standard-release.sh` | Passed actual Make routing, both native/Wasm package command selections, jobserver preservation and full-CI wrapper admission; command effects substituted |
| `bash scripts/release/test-publication-make.sh` | Passed group/package selection, lint-failure propagation and upload/readback ordering; effects substituted |
| `make tools-check shared-tooling-check` | Passed prepared selections and all 148 snapshot hashes |
| ShellCheck and Perl syntax | Passed changed callers; no Rust library code was edited |

Raw local records are `target/shared-tooling-0281-{impact,qualification,wiring,
admission,make,publication-make,tools}.log`. The integrated metadata fixture is
retained beneath `target/observability-release-groups.jgeaKk/`. Existing release
and archive receipts retain their original inputs and results. No full workspace
suite, new native macOS result or hosted qualification is claimed by these tests.

Package versions and dependency selections remain Metrics 0.28.1 and Logging
0.24.4; Cargo.lock and library sources are untouched. Pending notes target 0.28.2
and 0.24.5. The separate pre-existing root Cargo.toml comment edit is preserved.
No sibling source was changed, and no commit, release, push or publication ran.
