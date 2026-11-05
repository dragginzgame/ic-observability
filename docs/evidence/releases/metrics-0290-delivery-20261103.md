# Metrics 0.29.0 delivery — 2026-11-03

> Historical release receipt. See [evidence retention](../README.md#retired-raw-evidence)
> for current artifact availability; the original identities and observations below are not fresh qualification.

The maintainer authorized delivery of the #130 producer repair from the normal
`/home/adam/projects/ic-observability` checkout on `main` through the established
approved direct `origin/main` and crates.io workflow. No sibling checkout or
consumer was edited or released.

## Delivered identity

- [ic-metrics 0.29.0](https://crates.io/crates/ic-metrics/0.29.0).
- Main implementation: `9e02ed9858b0e8d6a884a1146a313a2faa772de4`.
- Validated source, including the retained release-client migration:
  `1048eec3526796298ef5917144c1bcbaf1ad7e74`.
- Release commit: `0ead785d2f0c7eafa05c9f9a05a2a609f320af0d`.
- Annotated tag: `metrics-v0.29.0`, object
  `1af5f57ce6b9333170ec9460e62a40875913b533`, peeled to the release commit.
- Official archive SHA-256:
  `0e6e2af9b83339bc8377c659a4106e3dafc3446181dea974d3e8ac0974490060`.

The [API inventory](../../metrics-api.md) accounts for the retained instrumentation
and governed persistence surface, removed arithmetic/report APIs and consumer
repairs. The [migration guide](../../../releases/metrics/0.29.md) describes the
breaking source cut. Recorder Serde is removed; production graphs are dependency-free.
Storage retains its durable encoding and owns real retained-format qualification.

## Release and publication evidence

The canonical `make release-minor RELEASE_GROUP=metrics` completed with all 21
workspace-scope stages passing, 373 summed stage seconds. This is a validation
execution record, not an IC performance measurement. Fresh full validation used
`target/release-validation/metrics-0.29.0.ZsBQfZ/`, with raw runner evidence in
`logs/validation.gCYk4S/`. Matched full/selected mapping qualification passed too.
The release changed exactly Cargo.toml, Cargo.lock, the Metrics manifest and its
ledger. It atomically pushed main and the annotated tag to GitHub.

The first full-gate attempt stopped before version preparation because a local
retained-consumer fixture still imported removed ratio helpers. Its corrected
client now exercises observations, restoration and exact-cap/actual-overflow
quality. The failed attempt remains under
`target/release-validation/metrics-0.29.0.viq4kJ/`; recovery evidence remains at
`target/evidence/native-ci/fixture-retention.8K1jx4/`. No gate was narrowed, failed
result reused or tag/upload attempted from that failed source.

Publication dry run passed, followed by one `publish-verified` upload. Official
readback confirmed the version is non-yanked, checksum/provenance match, and all
28 maintained packaged files match the exact clean release source. Verification
is retained at `target/publication/verification.1PISmp/`. Do not repeat the upload;
`make verify-publication RELEASE_GROUP=metrics` is readback-only.

Commands, mapping qualification, registry-before absence, Git refs, preserved
comment edits and publication logs remain in
`target/deploy/metrics-0290-20261103/`. Canonical release journal and protected
receipts remain under `.git/release-state/metrics-0.29.0.plan` and its matching
directory. No build/recovery artifacts were cleaned.

## Remaining acceptance

Hosted CI was triggered by the release as
[run 41699772724](https://github.com/dragginzgame/ic-observability/actions/runs/41699772724).
It was still running at receipt preparation. A documentation follow-up may
supersede it under the normal workflow concurrency rule; qualify the latest
retained full run. No fresh macOS/hosted acceptance is claimed here.

[#130 — Restrict Metrics to instrumentation](https://github.com/dragginzgame/ic-observability/issues/130)
remains open for its required consumer repairs and acceptance. Producer
publication alone does not finish Canic/IcyDB/Profiler/Relay/Blob/Storage/Timers
work, report-owner rounding/validation or endpoint consolidation.
Logging remains 0.24.5 and was not republished; its manifest and ledger hashes
match the pre-release observations. The pre-existing lowercase Cargo catalog
comments were preserved separately and restored unstaged after publication.
