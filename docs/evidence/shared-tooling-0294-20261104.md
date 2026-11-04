# Shared Tooling 0.29.4 adoption — 2026-11-04

This receipt records local adoption and focused caller qualification, not a
release, publication or hosted CI run. The receiving HEAD remains
`8e299364a9aeffccc4dec25cc9dc1a83124c2299` with the preceding local cleanup intact.
Package versions remain Metrics 0.29.0 and Logging 0.24.5; compatible pending
notes remain Metrics 0.29.1 and Logging 0.24.6. Cargo.lock is unchanged, and the
user's existing lowercase Cargo catalog comments remain unstaged.

## Supplier identity and changes

The canonical exporter selected committed revision
`628ccc75d813bfd9bae777bfbaef55838d25b1b2`, whose committed VERSION is 0.29.4.
GitHub `refs/heads/main` matched that revision; no `v0.29.4` tag was returned.
The committed changelog marks 0.29.4 Unreleased. This is committed-main adoption,
not a claim of a tagged supplier release. The supplier checkout was clean and
remained untouched.

The reviewed delta from `1fa2d90879650780d23ad8f045f5825771b696ad` adds the shared
retained-state helper and release-runner guards, with artifact-retention and
overlapping governance clarifications. The companion closure grows from 148 to
149 files. Tool catalogs, compiler policy, library code and dependency selections
are unchanged. The optional root VERSION classifier mode remains disabled for
this independently versioned Cargo workspace.

The release runner checks its Git-side release state and adjacent publication/
retired-checkout state before work and around adapter hooks. The shared
[retention contract](../releases.md#artifact-retention-and-exact-push-scope) owns
byte/age limits, nested build-tree refusal and preservation. No local exception,
cleanup script or deletion was introduced. Local publication attempts already
write under `target/publication`; the release adapter retains compact Git-side
receipts and points at validation evidence under `target/release-validation`.

## Focused evidence

- The exporter impact preview and refresh used the exact full revision above.
  Integrity verifies all 149 selected files and their modes. Logs are retained
  under `target/shared-tooling-0294-20261104/impact.log` and `refresh.log`.
- The new helper admits this checkout's existing `.git/release-state`,
  `.git/publication-state` and `.git/retired-checkouts` with status 0. This was
  read-only; no plans, receipts, failed attempts or other evidence were removed.
  See `target/shared-tooling-0294-20261104/retained-state.log`.
- `scripts/release/test-standard-release.sh` passes the real consumer Make
  dispatch, policy refusal, explicit group/file roster and command-status checks
  using its existing substituted effects. No maintained-checkout release ran.
- Two isolated probes execute the newly selected shared runner with a minimal
  disposable adapter: a pre-existing nested build tree refuses before adapter
  effects; an adapter-created tree refuses after its return. Both preserve their
  marker payloads, source commit and empty tag set, without leaving a lock or
  reaching validation/preparation. The adapter is a substitute, not product
  release acceptance. Inputs/logs remain under
  `target/shared-tooling-0294-20261104/runner-probe.ManVUx/`.

The [earlier receipt](shared-tooling-0293-20261104.md) retains passing runtime,
Rust formatting, fixture cleanup and dependency checks for their unchanged
inputs. Those checks were not replayed for this tooling-only increment. Shared
owns its generic retention/release regression matrix; no full CI, MSRV or native
host matrix was run here. Documentation links and diff consistency were checked.

## Adoption-gap follow-up

A subsequent review of this pending working tree found five local adoption gaps.
Their authorized repairs preserve the supplier snapshot and library contracts:

- Package documentation staging now exempts only the three named Cargo-generated
  absences. Other missing files, symlinks and directories refuse. Four synthetic
  boundary cases run in the ordinary package-documentation gate.
- Five local observation callers share `scripts/ci/CheckProcess.pm`, using Perl
  core modules. Complete stdout is admitted only after successful child exit;
  default limits are 4 MiB stdout, 1 MiB stderr and 60 monotonic seconds. Package
  content comparison retains its prior 32 MiB stdout limit. Failures terminate
  the owned process group, reap the direct child and retain structured failure
  category/status; bounded diagnostics are replayed. The helper is local because
  the adopted snapshot provides no suitable bounded capture interface. No shared
  source was patched and no new package/tool dependency was introduced.
- Full-CI and release validation callers select scratch beneath their own attempt
  only when `TMPDIR` is unset. Explicit overrides retain precedence and are scoped
  to the runner command. Shared helper fallback policies were not edited.
- The histogram oracle and Logging model use `std::` consistently where they
  already explicitly import the standard library. Production `no_std` source and
  test behavior are unchanged.
- Command help distinguishes workspace gates from package/test-focused commands.

Focused Linux evidence under `target/rule-adoption-fixes-20261104/`:

- `make fmt`, affected strict Metrics/Logging library-test Clippy, seven histogram
  restoration tests and two ordinary Logging model tests pass. The existing
  extended Logging model remains intentionally ignored.
- All 27 process assertions pass, including byte preservation, exact caps,
  stderr separation/replay, stdout/stderr overflow, nonzero child status,
  deadlines with closed or descendant-held pipes, interruption and child reaping.
  Initial regression development exposed redirection through a scalar-backed
  Perl STDERR handle; explicit descriptor duplication fixed that case before
  the passing checks. This is local process execution, not macOS acceptance.
- Real package-document staging, both declaration guards/refusals and all six
  native/Wasm production graphs pass. Package-document boundary tests pass all
  four valid/generated/missing/nonregular input scenarios. Both new regression
  files are selected by their owning normal CI targets.
- `test-validation-plan.sh --qualify` passes matched selection, jobserver,
  failure stopping and receipt/custody checks with substituted Make effects.
  It checks default CI scratch placement and an explicit `TMPDIR` override.
- The complete grouped admission fixture passes both Metrics and Logging
  metadata, rollback, exact commit/tag, receipt/recovery and publication-selection
  directions with broad builds and uploads substituted. It checks the real
  release adapter's default scratch selection. Inputs and receipts remain at
  `target/observability-release-groups.u6gB2k/`. Simulated releases affect only
  that disposable repository; they do not deliver maintained package versions.
- Publication-policy/content-tamper checks, Perl/Bash syntax, ShellCheck,
  documentation links and diff checks pass. Snapshot integrity remains 149 files.

No full workspace gate, MSRV matrix, hosted qualification or product publication
was run for this follow-up. All adoption and pending notes remain uncommitted.
No repository version bump, tag, push, release, registry upload or sibling mutation
is claimed.
