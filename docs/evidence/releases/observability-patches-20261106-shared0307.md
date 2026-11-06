# Metrics 0.29.5 and Logging 0.24.10 delivery — 2026-11-06

Both patches were released from the normal Observability `main` checkout to
`origin/main`, with annotated tags, then published once per package to crates.io
in Metrics-then-Logging order. Implementation:
`f0725c6be95c3b9eaf746fd1acb1d3cbb86e67e6`. Shared Tooling 0.30.7 is selected at
`22a853e26c05ec323f06c57fa316c08b808f252b` (157 files; source ledger Unreleased).

| Package | Release commit | Annotated tag object |
| --- | --- | --- |
| ic-metrics 0.29.5 | `bd822af0d074c3cda28d709aa71b7f6c6b72e72e` | `44e430004c337a846fd97fab214254f516917e90` |
| ic-logging 0.24.10 | `b6457ab30b85ea8dd16e712de9b7e1f6b2f31500` | `2eeb095c37f9ee88ff1d60fac93aa787e6524813` |

Tags are `metrics-v0.29.5` and `logging-v0.24.10`. Each release changed only its
own manifest, root catalog version, lock entry and ledger. No library implementation,
feature, external dependency selection, compiler or tool catalog changed. Frozen
batches remain unqualified and are rejected by normal Make entrypoints; no managed
delivery checkout was created. The [tooling summary](../tooling.md) owns the
focused caller, Make 3.81 and unsupported-mode checks.

Both plans selected full workspace scope because shared inputs changed. Every
one of the 20 stages passed, without stage reuse, version projection or gate
narrowing. The full/selected mapping qualification passed with matched comparison.
Final archive compilation and each publication dry run passed. Cargo package-cache
lock waits occurred; these observations make no release speed-up claim.

- Metrics plan/proof: `target/release-validation/metrics-0.29.5.QPNutC/`
  (`logs/validation.r2zOQV`).
- Logging plan/proof: `target/release-validation/logging-0.24.10.jDFZTY/`
  (`logs/validation.vAfd61`).
- Both protected `.git/release-state/GROUP-VERSION.plan` journals are complete.
  Release, publication and mapping transcripts are under
  `target/deploy/observability-0307-20261106/`.

Official registry/archive/source readback verified non-yanked versions and all
29 maintained Metrics files and 13 maintained Logging files against their exact
release commits, including original package manifests.

| Package | Registry | Archive SHA-256 |
| --- | --- | --- |
| ic-metrics 0.29.5 | [crates.io](https://crates.io/crates/ic-metrics/0.29.5) | `ad884a3df4134d63d27537cdd816dd4f5665f25de08dea7de1b3a6d82502d13c` |
| ic-logging 0.24.10 | [crates.io](https://crates.io/crates/ic-logging/0.24.10) | `b178fc4cdd2b18764cf38f51e95e9ad49ecea39e53f63e2d6abd0784a482bc0d` |

Under `target/publication/`, dry runs are `check.selection.Ff78OX/` and
`check.selection.XRyGdt/`; uploads are `publish.selection.ZriGsh/` and
`publish.selection.OBejPy/`; readbacks are `verification.ds1mF6/` and
`verification.FLy36O/`. Never upload these versions again. Use
`make verify-publication RELEASE_GROUP=metrics` or `logging` to reconcile read-only.

Hosted Linux/Intel macOS/ARM macOS CI remains asynchronous; pending or cancelled
runs are not passes. The previous main revision has successful
[CI run 42216362684](https://github.com/dragginzgame/ic-observability/actions/runs/42216362684)
at `016f615761ba351d0a2e1846398d665bba9cfb1b`; that does not qualify this new batch.
Local release and registry acceptance do not establish installed sibling or IC
runtime qualification.

Pre-existing lowercase root Cargo comments are restored with both new versions
retained. Dedicated stash `e5bedde93b31a520a4ff282071099152cb04c555` and the original
diff in the deployment directory preserve that work. Older stashes, private
originals, recovery inputs, tool stores and raw evidence remain untouched.
Raw artifact paths above need fresh observation before future reuse.
