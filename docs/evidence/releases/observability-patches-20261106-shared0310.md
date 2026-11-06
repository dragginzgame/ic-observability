# Metrics 0.29.6 and Logging 0.24.11 delivery — 2026-11-06

Both patches reached `origin/main` with annotated tags and were published once
per package, Metrics then Logging, through Shared Tooling 0.31.0's real batch
runner. The snapshot selects `74313941af2fce4399bec0e6909ca6229673c3f8` (157 files;
source ledger Unreleased). Implementation: `66a3c75f1568acbfeba333390258057aedc01105`.

```sh
make release-patch RELEASE_GROUP=metrics RELEASE_GROUPS=metrics,logging \
  RELEASE_PUBLISH_TARGET=publish-verified RELEASE_REMOTE=origin RELEASE_BRANCH=main
```

The schema-2 batch is `batch-z30yB8KG`, phase `complete`, index 2. Execution used
`target/release-frozen/batch-z30yB8KG` on `main`, with independent managed tool
selection and durable Git/recovery state beneath
`.git/release-state/frozen/batch-z30yB8KG/`. Publication used each recorded release
commit immediately after its atomic branch/tag push. The normal checkout stayed
at the implementation commit until explicit clean fast-forward reconciliation.

| Package | Release commit | Annotated tag object |
| --- | --- | --- |
| ic-metrics 0.29.6 | `79c3c7e9695ed9ce43f7a747c3786d36c301ff5c` | `e8e1d42d395bd3744fa4958f5ddb80444f161443` |
| ic-logging 0.24.11 | `6ddccd2423451f5dd3ae9cb5a3cf96114d185aba` | `13ad96377f473817923821a9babc0f054b573af8` |

Tags are `metrics-v0.29.6` and `logging-v0.24.11`; remote tag objects and peeled
commits matched. Each group changed only its manifest, root catalog requirement,
lock entry and ledger. No library implementation, features, external dependency
selection, compiler or tool catalog changed.

Each selected plan ran all 20 workspace stages and passed, with no stage reuse,
version projection or gate narrowing. Native/Wasm lint, allocator-free linking,
tests, archives and actual release/recovery fixtures passed in the captured Linux
checkout. Prepared metadata archives and publication lint/compilation also passed.
Cargo package-cache lock waits occurred; no speed-up is claimed.

Under the managed checkout's `target/`:

- Metrics plan/proof: `release-validation/metrics-0.29.6.GxyRZ6/`, logs `validation.j7eVPS`.
- Logging plan/proof: `release-validation/logging-0.24.11.O6QQg6/`, logs `validation.lOKD7N`.
- Uploads: `publication/publish.selection.GZ390O/` and `publish.selection.eEfePr/`.
- Readbacks: `publication/verification.Bb4m47/` and `verification.2A8PUS/`.

Registry readback verified non-yanked entries, archive checksums and all 29
maintained Metrics files and 13 maintained Logging files against their exact
release commits, including original manifests.

| Package | Registry | Archive SHA-256 |
| --- | --- | --- |
| ic-metrics 0.29.6 | [crates.io](https://crates.io/crates/ic-metrics/0.29.6) | `7aa1b95a894d02d797929104bbbd0998fc1e69f3b45eb2342deaa0c69d769723` |
| ic-logging 0.24.11 | [crates.io](https://crates.io/crates/ic-logging/0.24.11) | `dd4b62fa52e1d9625e05dc7992b5327bf3e2f3dcccd23abd833223c84b35d450` |

Never upload these versions again. The batch, source pin, candidate outputs and
protected standard journals remain retained; no retirement or cleanup ran.
Normal-checkout transcripts and exact remote observations are under
`target/deploy/observability-0310-20261106/`. The unrelated lowercase Cargo comments
were restored with both new versions intact; stash
`a7dbbac568a37876f37f8a89607545a5fba389b2` retains custody. Earlier stashes and
recovery evidence remain untouched.

Hosted acceptance is separate. [Metrics CI 42263818593](https://github.com/dragginzgame/ic-observability/actions/runs/42263818593)
failed: both macOS jobs could not parse Shared's checksum helper on system Bash,
and Linux exposed an inherited empty `RELEASE_GROUPS` in standard release fixtures.
The local fixture repair clears inherited batch configuration before constructing
its independent test context. Standard Make and both-group admission fixtures
passed with `RELEASE_GROUPS=`. This CI-only follow-up leaves published archives
unchanged and does not reinterpret the captured release proof.

The macOS blocker belongs to Shared Tooling: `verify-file-checksum.sh` reports
an unmatched single quote in both native jobs before host parser installation.
The selected upstream main still has this defect; no snapshot-owned file or
sibling checkout was patched. Hosted runs remain asynchronous; pending, failed
or cancelled runs are not native passes. See [the current handoff](../../status/current.md)
for follow-up state. Local acceptance does not qualify installed siblings or IC runtime.
