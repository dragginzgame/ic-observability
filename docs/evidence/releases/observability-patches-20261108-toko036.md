# Metrics 0.29.7 and Logging 0.24.12 delivery — 2026-11-08

Both patches reached `origin/main` with annotated group tags and were published
once to crates.io, Metrics then Logging. Registry readback confirmed non-yanked
versions, archive checksums and maintained source content. The migration changes
development requirements and cargo-machete metadata; library implementation and
normal/build dependency graphs are unchanged.

Source migration: `cd0e89a5c418ef5a568b6ecfb1e0bf55ffd18cfc`.
Admission correction: `cdf8b13891426b37133000caef844ae6fd1fd020`.
The snapshot selects published toko-tooling 0.36.0, archive SHA-256
`de0dd05b6437061622a76942baa25d40d2181497e7ba66d9fd809132a3082936`.
All 97 entrypoints remain selected; 168 files are installed.

| Package | Release commit | Annotated tag object |
| --- | --- | --- |
| ic-metrics 0.29.7 | `ede2825685e939707984037856181aa55336d60d` | `12bb8998c0df774219066073af3017c6d1edd06c` |
| ic-logging 0.24.12 | `eadaaa151bc01c2a479d59f08b502d7424f89b28` | `62d263cd29e02153692b70dc295af7669489008b` |

Tags are `metrics-v0.29.7` and `logging-v0.24.12`. Remote main matched the
Logging release commit on readback. Never re-upload these versions.

| Registry archive | SHA-256 | Maintained files matched |
| --- | --- | --- |
| ic-metrics-0.29.7.crate | `d56b2cfab39b52534105bcb3757a149f338e52d8f67fe0bf655141f165c1c6d7` | 29 |
| ic-logging-0.24.12.crate | `27ff9c82c40dc2b947966e3a5188a4087cae736f4052bbc4e8b2d59dcecf8afd` | 13 |

## Validation and recovery custody

```sh
make release-patch RELEASE_GROUP=metrics RELEASE_GROUPS=metrics,logging \
  RELEASE_PUBLISH_TARGET=publish-verified RELEASE_REMOTE=origin RELEASE_BRANCH=main
```

Batch `batch-gfJA5IMg` completed at index 2. It used the managed checkout
`target/release-frozen/batch-gfJA5IMg`, with durable recovery state at
`.git/release-state/frozen/batch-gfJA5IMg/`. Both groups required and passed the
full 20-stage workspace plan, followed by final package/archive and publication
admission. No stage reuse or validation narrowing was enabled.

Plans and sealed proofs are under that candidate's
`target/release-validation/metrics-0.29.7.KQdt2V/` and
`target/release-validation/logging-0.24.12.SyLTIH/`. Registry reconciliation
evidence is under `target/publication/verification.fYIamH/` and
`target/publication/verification.Zu5lGX/`, respectively. The standard group
journals are complete. The normal checkout was explicitly fast-forwarded with
`make release-batch-reconcile BATCH=batch-gfJA5IMg`; no deferred work was lost.
No batch retirement or protected evidence cleanup ran.

The first batch, `batch-C8a10ddy`, retained source `cd0e89a` and failed before
external delivery at `release-tools-check`. Its fixture exposed Cargo-based
tooling admission preceding missing-group rejection. The correction orders
tooling and cleanup after group selection and preserves read-only committed-source
receipt checks. Both group fixtures passed before the fresh real batch. The
failed batch remains retained; it is not a successful release attempt.

Normal transcripts and repair qualification are under
`target/deploy/toko-tooling-036/`. Hosted
[release CI 42513634159](https://github.com/dragginzgame/ic-observability/actions/runs/42513634159)
was running at delivery readback; no native macOS or hosted acceptance is inferred
from the local release gates. Later documentation-only receipt delivery does not
invalidate unchanged code qualification. Earlier custody remains in the
[previous delivery receipt](observability-patches-20261106-shared0310.md).
