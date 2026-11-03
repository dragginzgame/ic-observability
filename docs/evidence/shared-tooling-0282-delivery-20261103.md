# Shared Tooling 0.28.2 and #129 delivery — 2026-11-03

Delivered from the normal `/home/adam/projects/ic-observability` checkout on
`main`, through the established approved direct `origin/main` and crates.io flow.
Implementation commit: `ae36ac071f5f2cacef7d449203ef06ad75107598`.
It adopts Shared Tooling `v0.28.2`, revision
`5cf67f81c50c56ac17389ae71a3a87d46e86e8a2`, with 148 verified snapshot files.
[Implementation evidence](shared-tooling-0282-20261103.md) records the
[#129](https://github.com/dragginzgame/ic-observability/issues/129) mapping,
shared-helper, protected-receipt and qualification-lifecycle changes.

## Release and registry identities

| Package | Source before preparation | Release commit / annotated tag | Official archive SHA-256 |
| --- | --- | --- | --- |
| [ic-metrics 0.28.2](https://crates.io/crates/ic-metrics/0.28.2) | `ae36ac071f5f2cacef7d449203ef06ad75107598` | `1a991a37e5dbd02efee5af38f77180cc8450e1c9` / `metrics-v0.28.2` | `0d8cbfc169c0266b813ca6f604088fae2a7065ba004603855ca90df71a47ea97` |
| [ic-logging 0.24.5](https://crates.io/crates/ic-logging/0.24.5) | `1a991a37e5dbd02efee5af38f77180cc8450e1c9` | `5069d8827001ff7ae67a90d5c763bab6152c59cc` / `logging-v0.24.5` | `14725c95ae56292ea028d164a553219f1667a46d8af296d9b2469caaf16db5c4` |

Each group passed the standard fresh `release-patch` path, including preflight,
all 21 workspace-scope validation stages, version/changelog preparation,
selected-package archive compilation, commit/tag and atomic main/tag push.
Summed stage durations were 407 seconds for Metrics and 423 seconds for Logging;
these are CI execution records, not IC performance measurements. Each release
changed exactly its four selected metadata files and preserved the other group.
No stage reuse or package-version projection was enabled.

Each package passed its publication dry run and was uploaded once through
`publish-verified`. Official readback confirmed a non-yanked version, archive
checksum, exact GitHub source and all maintained packaged files: 32 for Metrics,
12 for Logging. Metrics was verified before Logging's release began. Do not
replay uploads; `make verify-publication RELEASE_GROUP=...` is readback-only.

## Required native acceptance

[CI run 41640061420](https://github.com/dragginzgame/ic-observability/actions/runs/41640061420)
targets delivered commit `5069d8827001ff7ae67a90d5c763bab6152c59cc`.
The completed run succeeded on Linux x86_64 (job `125931749815`), macOS Intel
x86_64 (`125931749508`) and macOS ARM64 (`125931749609`). Each host actually ran
and passed `Run native CI`, including evidence retention and upload. The retained
run response was checked for the exact delivered source, all three expected jobs,
their successful native steps and successful overall completion. Earlier
cancelled/superseded runs and documentation-only skips are not qualification.
This completes #129's delivery and native acceptance requirements.
[#129 was closed](https://github.com/dragginzgame/ic-observability/issues/129#issuecomment-6605109269)
after the successful run was verified, at `2026-11-03T13:29:36Z`.

## Retained local evidence

- Commands, source checks, registry-before observations, Git refs and CI records:
  `target/deploy/shared-tooling-0282-20261103/`.
- Metrics plan/proof/logs: `target/release-validation/metrics-0.28.2.STrFrI/`.
- Logging plan/proof/logs: `target/release-validation/logging-0.24.5.799sgg/`.
- Journals and protected receipts: `.git/release-state/metrics-0.28.2.plan`,
  `.git/release-state/logging-0.24.5.plan` and their matching state directories.
- Official readbacks: `target/publication/verification.ZZDZS1/` and
  `target/publication/verification.uxKOTk/`.

The pre-existing two-line root Cargo.toml comment edit was restored and compared
with its saved patch; its safety copy remains in the local stash and delivery
folder. No sibling checkout was changed. No unrelated artifact cleanup ran.
