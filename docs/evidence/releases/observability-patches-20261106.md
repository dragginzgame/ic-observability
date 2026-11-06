# Metrics 0.29.4 and Logging 0.24.9 delivery — 2026-11-06

Both patches were released from the normal Observability `main` checkout to
`origin/main`, with annotated tags, then published once per package to crates.io
in Metrics-then-Logging order. Implementation:
`ed825cb256a737b2a896e364b87bd926bde414f9`. The reviewed Shared Tooling 0.30.6
selection is `45c0295e23d3d23225e31f47c018c30ff0c75581` (155 files; source ledger
Unreleased). The sibling's uncommitted 0.30.7 work was not exported or changed.

| Package | Release commit | Annotated tag object |
| --- | --- | --- |
| ic-metrics 0.29.4 | `c29b292a5a3da67dc0aa2c34ef1ea3e79af83a5c` | `af675bfa32ced45b5087cca951437185b17f79b4` |
| ic-logging 0.24.9 | `e3bf868b6d941f5944606480e39a2da35b824d37` | `65d324917b09eee6c2d10959b0234710692fd159` |

Tags are `metrics-v0.29.4` and `logging-v0.24.9`. Each release changed only its
own manifest, root catalog version, lock entry and ledger. No library implementation,
feature or external dependency selection changed. Both plans selected workspace
scope and passed all 20 stages, without stage reuse, version projection or gate
narrowing. Final archive compilation and each publication dry run passed. The
full/selected mapping qualification was renewed with matched comparison.

- Metrics plan/proof: `target/release-validation/metrics-0.29.4.O3FJy5/`
  (`logs/validation.JmeNiz`).
- Logging plan/proof: `target/release-validation/logging-0.24.9.Uq2bYK/`
  (`logs/validation.24gusU`).
- Both protected `.git/release-state/GROUP-VERSION.plan` journals are complete.
  Release, publication and mapping transcripts are under
  `target/deploy/observability-0306-20261106/`.

Official registry/archive/source readback verified non-yanked versions and all
29 maintained Metrics files and 13 maintained Logging files against their exact
release commits, including original package manifests.

| Package | Registry | Archive SHA-256 |
| --- | --- | --- |
| ic-metrics 0.29.4 | [crates.io](https://crates.io/crates/ic-metrics/0.29.4) | `f9e9db47236174de6f67a3dd983f51236cc628974a9e78b20e3c268109b33bf8` |
| ic-logging 0.24.9 | [crates.io](https://crates.io/crates/ic-logging/0.24.9) | `c2df1c564781c7dc72caa1b66947c5a6d7c1cb93068d0111a2519b14bda4688b` |

Under `target/publication/`, dry runs are `check.selection.4acIl3/` and
`check.selection.rSI477/`; upload receipts are `publish.selection.GvJVcF/` and
`publish.selection.jvsVC4/`; readbacks are `verification.ZdjwlE/` and
`verification.icTN8j/`. Never upload these versions again. Use
`make verify-publication RELEASE_GROUP=metrics` or `logging` to reconcile read-only.

The [tooling summary](../tooling.md) owns the Candid/CBOR and Cargo boundary
decisions, scoped refusal checks and independently generated consumer checks.
The previous Make repair has a successful
[hosted run](https://github.com/dragginzgame/ic-observability/actions/runs/42066741583)
at `96de8655cbe5cf545176a867e414ed1c9aecfe18`. That result does not qualify this
new batch. Its hosted Linux/Intel macOS/ARM macOS CI remains asynchronous;
pending or cancelled runs are not passes. Local release and registry acceptance
do not establish installed sibling or IC runtime qualification.

Pre-existing lowercase root Cargo comments are restored with both new versions
retained. Dedicated stash `bf5bb360125866c3b6a3e2c3337ce08842e1f458` and the
original diff in the deployment directory preserve that work. Older stashes,
private originals, recovery inputs, tool stores and raw evidence remain untouched.
Raw artifact paths above need fresh observation before future reuse.
