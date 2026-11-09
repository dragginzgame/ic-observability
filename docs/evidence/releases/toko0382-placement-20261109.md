# Tooling and workspace placement delivery — 2026-11-09

Metrics 0.29.10 and Logging 0.24.15 reached `origin/main` with annotated group
tags and were published once to crates.io, Metrics then Logging. Independent
readback confirmed both versions non-yanked, archive checksums and maintained
source content. Never re-upload these versions.

Source implementation: `eda599aa3c57fd5b1d07d680970e7e8001048f01`.
Both packages' delivered development requirements change from toko-tooling
0.37.5 to 0.38.2, requiring publication of both independent groups. The authenticated
snapshot contains 99 roots and 171 files. Both product crates retain their
standard `crates/` locations, APIs, features and production dependency boundaries.
The virtual root explicitly excludes `qualification`; that tree has historical
documentation only, so no package move or empty workspace was introduced.
Qualification release preparation remains unselected, with the existing four-file
plan per group and all product release requirements preserved. The separately
deferred syn 3.0.10 edit is excluded. No sibling repository was modified or deployed.

| Package | Release commit | Annotated tag object |
| --- | --- | --- |
| ic-metrics 0.29.10 | `101ff013e7cb6dc1861e3cc2aa665c0e0572a505` | `1c8ebf4826390487d74e9ebe20b65d0036939789` |
| ic-logging 0.24.15 | `a72eaec9e2acac4817ed9f49c9385b5d7d071a13` | `27f54a85acee3f62639de1ac19aa2e3222d8491b` |

Tags are `metrics-v0.29.10` and `logging-v0.24.15`.

| Registry archive | SHA-256 | Maintained files matched |
| --- | --- | --- |
| ic-metrics-0.29.10.crate | `2d371f7202cdd23ffcae9013ce0c51998a04ae8e0b64b8fb4845d7e46715f9aa` | 34 |
| ic-logging-0.24.15.crate | `499d8988e8cf62ea97f16222d1892fa65632e5e07f8fbb2c050206601b10a15e` | 16 |

## Validation and recovery custody

```sh
make release-patch RELEASE_GROUP=metrics RELEASE_GROUPS=metrics,logging \
  RELEASE_PUBLISH_TARGET=publish-verified
```

Batch `batch-Dvpzy0I1` completed at index 2. Execution is retained beneath
`target/release-frozen/batch-Dvpzy0I1`, with durable recovery beneath
`.git/release-state/frozen/batch-Dvpzy0I1/`. Both groups passed their complete
20-stage workspace plan without narrowing or stage reuse, followed by final-version
archive compilation, source/tag admission, publication and registry readback.
Plans and sealed proofs within the candidate are under
`target/release-validation/metrics-0.29.10.KXFQoR/` and
`target/release-validation/logging-0.24.15.O18xrj/`. Registry verification is under
`target/publication/verification.CXwzKj/` and
`target/publication/verification.GV3fWf/`, respectively. Normal transcripts are
under `target/deploy/toko0382-placement-20261109/`.

The batch captured syn 3.0.9 after the unrelated 3.0.10 edit was verified against
stash `de3f936fd3e93d094ddf5ff5d7129a8104119f0c`, pinned by branch
`preserved/syn-3.0.10-typed-recording-20261109`. After completion,
`make release-batch-reconcile BATCH=batch-Dvpzy0I1` fast-forwarded the normal
checkout. Reapplying that stash restored only the deferred syn version/checksum
edit. The stash/ref and earlier batches remain retained; no retirement or
protected evidence cleanup ran.

Hosted [Logging release CI](https://github.com/dragginzgame/ic-observability/actions/runs/42665016748)
was in progress on delivery observation. The preceding
[Metrics run](https://github.com/dragginzgame/ic-observability/actions/runs/42663305678)
was cancelled after the next push; cancellation is not a pass. Hosted/native
macOS and installed consumer acceptance remain separate and asynchronous.
No IC cost measurement is implied. Previous identities remain in the
[omission API and tooling receipt](omission-toko0375-20261109.md).
