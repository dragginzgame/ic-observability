# Shared Tooling 0.30.0 documentation remediation

The [original rule audit](../reports/audits/2026/11/05/shared-tooling-adoption/01/report.md)
retains its failed initial export and focused local review. The maintainer then
explicitly authorized repairing and pushing the supplying Shared Tooling checkout
before deploying the two Observability patches.

[Shared #355 — Complete exported documentation closure for LOC classification and audit guidance](https://github.com/dragginzgame/shared-tooling/issues/355)
is fixed by upstream commit
[`b37a882314d22bf7ab393b3fe561809377ffd22d`](https://github.com/dragginzgame/shared-tooling/commit/b37a882314d22bf7ab393b3fe561809377ffd22d),
pushed and read back at origin/main. Four central-document links use their reviewed
`08cd17240fd60dfd309e35eb131e73323e883e6f` source instead of absent consumer-local
fleet documentation. No unrelated fleet inventory or scheduler payload was added.
Shared's existing pending VERSION 0.30.0 stays unchanged; no Shared release is claimed.

The new producer fixture `scripts/ci/test-exported-doc-links.sh` is in its normal
portable roster. It exports the actual committed governance/Make/LOC selection,
requires fleet/stack documents to remain absent, then checks the four affected
files. It fails with the original four missing targets before the fix and passes
all 64 local references afterward. Removing an exported local target still fails.
Focused ShellCheck, normal documentation/version admission and diff checks pass.
Original and corrected evidence remains under Shared's `target/issue-355/`.

Observability adopted that exact commit with the canonical preview/exporter.
`make shared-tooling-check check-doc-links` verifies 150 files, 1,115 repository
references and one package-guidance reference. The actual `make cloc
CLOC_SUBCRATES=1` caller also passes, including the corrected workspace label and
single-workspace table. The source classification and fixture roles are unchanged.

Consumer preview, refresh and proof logs are retained under
`target/deploy/observability-20261105/`. This fresh observation resolves the original
audit's documentation failure; it does not relabel its earlier failed check.
Full patch-release and registry evidence belongs to the subsequent delivery receipt.
