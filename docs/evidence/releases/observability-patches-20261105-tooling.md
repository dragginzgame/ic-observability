# Metrics 0.29.3 and Logging 0.24.8 delivery — 2026-11-05

Both independent patches were released from the normal Observability `main`
checkout to `origin/main`, with annotated tags, then published once per package
to crates.io in Metrics-then-Logging order. The implementation is
`45c1566a8b92782246390bc9c5c3a782a64ddacf`. It selects Shared Tooling 0.30.4 at
`2aa41c7394300302fe802b69b31b855bdc89b671` (152 files; source ledger Unreleased).
The [tooling summary](../tooling.md) and [retention index](../README.md) explain
the Candid guard and evidence compaction. No library implementation changed.

| Package | Release commit | Annotated tag object |
| --- | --- | --- |
| ic-metrics 0.29.3 | `61e1e743863fea892cb868c6a3e481de892a8330` | `f55d1e7fbd501cc975a4d2610a955c43c3377131` |
| ic-logging 0.24.8 | `b07e0540ea31375a794ea9025f7588292b8136eb` | `4f985ba0d9c9ab9ef160308009af9cab7eb72a03` |

Tags are `metrics-v0.29.3` and `logging-v0.24.8`. Each release changed only its
selected manifest, root catalog version, lock entry and ledger. Both plans
selected workspace scope and passed all 20 stages without stage reuse or version
projection. Final archive compilation and each publication dry run passed.
The separately renewed mapping qualification passed with matched comparison.

- Metrics plan/proof: `target/release-validation/metrics-0.29.3.rC7ZFF/`
  (`logs/validation.Is782M`).
- Logging plan/proof: `target/release-validation/logging-0.24.8.JBcZDF/`
  (`logs/validation.eVcDRU`).
- Protected `.git/release-state/metrics-0.29.3.plan` and
  `logging-0.24.8.plan` are complete. Transcripts and mapping qualification are
  under `target/deploy/observability-tooling-20261105/`.

Official registry/archive/source readback verified non-yanked versions and all
29 maintained Metrics files and 13 maintained Logging files against their exact
release commits, including original package manifests.

| Package | Registry | Archive SHA-256 |
| --- | --- | --- |
| ic-metrics 0.29.3 | [crates.io](https://crates.io/crates/ic-metrics/0.29.3) | `a1cd73b94325775977edfe0741aa542900cd2a98ded26a1533b80e53686dafa0` |
| ic-logging 0.24.8 | [crates.io](https://crates.io/crates/ic-logging/0.24.8) | `fdb9ef85d52a34d2bdbc6c0289e589d5084b56d0edd1e600d1ec20078dba8863` |

Dry runs: `target/publication/check.selection.6SVtbP/` and
`check.selection.6f4zdC/`. Upload receipts: `publish.selection.Wru65v/` and
`publish.selection.Tn94tZ/`. Readbacks: `verification.ApHXEP/` and
`verification.b46hlB/`, all under `target/publication/`. Never upload these versions
again; use `make verify-publication RELEASE_GROUP=metrics` or `logging` to reconcile.

The [Metrics hosted run](https://github.com/dragginzgame/ic-observability/actions/runs/42064849516)
passed Linux but failed both macOS setup-smoke jobs at the existing Makefile
publication-scope declaration (`multiple target patterns`). The subsequent
repository-only repair separates export from the target-specific override and
extends smoke assertions to scope. GNU Make 3.81 built locally from GNU source
reproduced the failure and passed the repaired caller; modern glibc required
`-D__alloca=alloca -D__stat=stat` for that temporary build. The prepared Make and
publication ordering fixture also passed. This is Linux parser evidence, not
macOS runtime acceptance. Hosted qualification of the repair remains asynchronous;
neither published package payload is changed or republished by that repair.

The pre-existing lowercase root Cargo comments are restored, with new versions
retained. Dedicated stash `31c35843bcbd2ef89e2aa4ccc701509a4951755e` and copies
under `target/evidence/docs-cleanup-20261105/` preserve the original diff. Earlier
stashes, private originals, recovery state and tool stores remain untouched.
Raw artifact paths above require fresh observation before future reuse.
