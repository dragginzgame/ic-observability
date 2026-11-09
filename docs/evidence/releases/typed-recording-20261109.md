# Typed recording delivery — 2026-11-09

Metrics 0.29.8 and Logging 0.24.13 reached `origin/main` with annotated group
tags and were published once to crates.io, Metrics then Logging. Independent
readback confirmed both versions non-yanked, archive checksums and maintained
source content. Never re-upload these versions.

Source implementation: `3a98180a99560d8a2f47e9bace595e84d799be8c`.
The source adds typed bounded history to Logging and typed first-admitted scalar
and lexical-prefix measurement tables to Metrics. Existing APIs, text-log
checkpoints and production dependency boundaries are unchanged. Consumer-owned
byte charges are explicit; lexical construction requires a checked worst-case
key budget. Producer [#131](https://github.com/dragginzgame/ic-observability/issues/131)
and [#132](https://github.com/dragginzgame/ic-observability/issues/132) own the APIs.
Canic [#755](https://github.com/dragginzgame/canic/issues/755) and
[#756](https://github.com/dragginzgame/canic/issues/756) retain adoption and actual
consumer qualification. No sibling repository was modified or deployed.

| Package | Release commit | Annotated tag object |
| --- | --- | --- |
| ic-metrics 0.29.8 | `adb5ac648cb88924e26e7211f46806500e5d741c` | `e8a8358715abbaab1d332a955e837eff4f219b14` |
| ic-logging 0.24.13 | `3e05c1bca08d94e8d46e2beccf144a5882d8592d` | `31873e0a240c85c175606fbc9832d14b757196b8` |

Tags are `metrics-v0.29.8` and `logging-v0.24.13`.

| Registry archive | SHA-256 | Maintained files matched |
| --- | --- | --- |
| ic-metrics-0.29.8.crate | `99684e3afc04c523f9276de65ea6fac6006615394827d458b0c540242c79bebf` | 34 |
| ic-logging-0.24.13.crate | `61aacdf1ec6dded89d6360b3901b54d28af74dae1b7c9675d86ee755067390ca` | 16 |

## Validation and recovery custody

```sh
make release-patch RELEASE_GROUP=metrics RELEASE_GROUPS=metrics,logging \
  RELEASE_PUBLISH_TARGET=publish-verified RELEASE_REMOTE=origin RELEASE_BRANCH=main
```

Batch `batch-vgM1oJ1f` completed at index 2. Execution is retained beneath
`target/release-frozen/batch-vgM1oJ1f`, with durable recovery beneath
`.git/release-state/frozen/batch-vgM1oJ1f/`. Both groups passed the full 20-stage
workspace release plan, with no scope narrowing or stage reuse, followed by
final-version archive compilation, selected-package publication admission and
registry/source readback. This covers the existing text-log/fixed-recorder
regressions as well as typed-history, scalar-conservation, lexical permutation,
overflow, public API and feature/dependency-boundary checks.

Within the candidate, plans/proofs are retained under
`target/release-validation/metrics-0.29.8.Taqt78/` and
`target/release-validation/logging-0.24.13.K11cyD/`. Registry verification is
retained under `target/publication/verification.UFlCCW/` and
`target/publication/verification.N8SHVk/`, respectively. Normal transcripts are
under `target/deploy/typed-recording-20261109/`.

The initial capture refused a dirty normal lock before creating a release.
The unrelated syn 3.0.10 edit was preserved as stash
`de3f936fd3e93d094ddf5ff5d7129a8104119f0c`, pinned by durable branch
`preserved/syn-3.0.10-typed-recording-20261109`. The actual batch captured the
committed syn 3.0.9 graph. After completion, `make release-batch-reconcile
BATCH=batch-vgM1oJ1f` fast-forwarded the normal checkout; applying that stash
restored only the deferred syn version/checksum change on the new package
versions. The stash/ref remain retained. No batch retirement or protected
evidence cleanup ran.

Hosted [Logging release CI](https://github.com/dragginzgame/ic-observability/actions/runs/42586121922)
was pending on delivery observation. Hosted/native macOS and Canic installed
acceptance are separate; local release gates provide no IC cost measurement.
Later documentation-only receipt delivery does not invalidate unchanged code
qualification. Earlier delivery and recovery identities remain in the
[previous receipt](observability-patches-20261108-toko036.md).
