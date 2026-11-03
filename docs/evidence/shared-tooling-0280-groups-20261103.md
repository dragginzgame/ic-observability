# Shared Tooling 0.28.0 and release-group validation — 2026-11-03

Adopted committed Shared Tooling revision
`70939d3b6ca335cb718363b47f15cc616c3bed1c` through the canonical exporter.
Remote main matched that revision when reviewed. Its committed VERSION is
0.28.0, with an **Unreleased** producer changelog; no tagged-release claim is made.
The snapshot verifies all 145 selected files. Managed setup was refreshed and
offline `tools-check` passes; no application dependency was upgraded.

## Consumer mapping

The [versioned roster](../../ci/release-validation.json) exhaustively matches the
21 sequential full-CI targets. The selector checks that equivalence and the
Cargo release-group roster and single-package membership before generating a
plan. An annotated ancestor tag
for the selected current version supplies the baseline; missing/unusable history
selects workspace scope. The entire baseline-to-source diff is classified.

For confined Metrics changes, 20 stages remain required and Logging's dedicated
graph stage is excluded. For confined Logging changes, 19 remain required and
Metrics' graph/transport and allocator-free link stages are excluded. All other
admission, tool, policy, formatting, evidence and release-fixture stages remain.
Native/Wasm Clippy, Rustdoc, tests and archive recipes select only that package.
The declaration guard continues to admit the two independent production graphs.
Manifests/features, locks, shared machinery, other-group changes and unknown
inputs select all 21 stages and workspace Cargo commands. Adoption itself is a
shared change, so its first release uses that fallback.

Full repository CI keeps both packages and all three native hosts. Its recursive
Make calls explicitly force workspace scope. This adoption enables no stage
reuse, package-version projection, downstream acceptance or performance claim.
Publication admission, archive provenance and registry checks retain their owners.

## Recovery boundary

Each unique attempt under `target/release-validation/` retains the canonical
plan/context, baseline/source, host/compiler/build configuration and Shared
runner logs, complete source checkpoints, observations, stage decisions and
timings. Consumer proof schema 1 requires every selected obligation to have
passed with matching before/after observations. The validated release receipt
binds that proof's SHA-256 and retains the existing release/destination identity.
Preparation and resume regenerate the same scope and re-admit the proof.
Legacy full-gate receipts are not reinterpreted. Prior attempts remain retained.

## Local qualification

Executed on Linux x86_64, Rust/Cargo 1.99.1:

| Proof | Result |
| --- | --- |
| `bash scripts/release/test-validation-plan.sh` | Passed both groups, shared/manifests/other-group/unknown expansion, full-CI command equivalence, excluded failure, required failure, stale source, input drift, missing evidence, configuration drift, group/roster refusals and exact recovery |
| `bash scripts/release/test-standard-release.sh` | Passed actual Make routing for both packages, native/Wasm flags, strict lint ordering, recursive full scope and jobserver propagation; Cargo/Git effects substituted |
| `bash scripts/release/test-release-admission.sh` | Passed both groups' real metadata rendering, rollback, disposable commit/tag/push, proof tampering, resume, other-group identity/ledger preservation and real retained-consumer tests; broad gates, archive compilation and registry upload substituted |
| `make clippy docs-check test package-check RELEASE_GROUP=metrics OBSERVABILITY_RELEASE_VALIDATION_SCOPE=group` | Passed real package commands: strict native/Wasm lint, native/Wasm docs, 79 unit tests, 15 doctests and verified archive |
| Same selected commands with `RELEASE_GROUP=logging` | Passed: 30 unit tests, 4 doctests and 2 export-example tests; 1 existing ignored test; strict native/Wasm lint, docs and verified archive |
| `make metrics-profiles-check logging-profiles-check` | Passed separate native/Wasm production graphs and 6 minimal transport tests |
| Managed tool checks, snapshot, links, pins, formatting, ShellCheck and Perl syntax | Passed |

Raw local logs remain under `target/`: `group-validation-plans.log`,
`release-validation-standard.log`, `group-validation-metrics.log`,
`group-validation-logging.log`, the corresponding `*-graph.log` files,
`shared-tooling-0280-install.log`, `shared-tooling-0280-tools-check.log` and
`group-validation-consistency.log`. Plan fixtures substitute Make effects and
do not establish package execution; the separate real commands above do.

The integrated release-admission log is `target/group-validation-admission.log`;
its source and receipts remain under `target/observability-release-groups.LmfxxB/`.
No full repository suite, hosted CI, native macOS run, real release/upload or
staging/commit/tag/push from the working checkout is claimed by these checks.
The current package versions stay Metrics 0.28.0 and
Logging 0.24.3; pending notes target 0.28.1 and 0.24.4 respectively.
