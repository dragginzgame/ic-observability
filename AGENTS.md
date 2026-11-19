# IC Observability Agent Rules

Apply the installed [Toko Tooling baseline](TOKO-TOOLING.md) and its
revision-bound references. [.toko-tooling.snapshot](.toko-tooling.snapshot)
records the exporter-managed payload. This overlay owns product safeguards,
local commands and approved exceptions.

Read [the current handoff](docs/status/current.md), and
[the extraction contract](docs/architecture/extraction.md) before recording,
consumer-contract or persistence-boundary changes. No baseline exceptions apply.

## Ownership

- This renamed workspace owns the independent `ic-metrics` and `ic-logging`
  packages. They share the root catalog and lockfile, with no dependency on one
  another. Each group owns literal package versions and its ledger under
  releases/metrics or releases/logging. The root has shared metadata and changelog
  navigation, with no aggregate version. Coordinated history is in releases/history.md.
  Membership is explicit in ci/cargo-release-groups.json.
  The root Cargo catalog and lock select tooling; use the installed common
  setup/check interface. Custom deployment adapters must run
  `toko-tooling-check` before effects. Tooling stays outside production graphs.
  Use `make deps-list` for package versions and release-group membership.
  Both product packages remain under `crates/` in the virtual root workspace,
  which explicitly excludes `qualification`. No maintained qualification package
  or workspace exists here; the two `qualification/` README files retain retired
  history only. Unit tests, integration tests and examples remain package-local.
  The shared observability contract owns the application-tree instrumentation
  boundary and Canic's reporting authority. The concrete public API and remaining
  consumer repair map are recorded in [the API inventory](docs/architecture/metrics-api.md).
  [Observability #130 — Restrict Metrics to instrumentation](https://github.com/dragginzgame/ic-observability/issues/130)
  is closed for its producer scope; consumer acceptance stays with its owner.
  Historical receipts retain their original scope.
  Release, resume and publication require an explicit RELEASE_GROUP; no default
  group or PACKAGE inference is permitted.
- Logging owns a dependency-free `no_std` + `alloc` heap engine with explicit
  input time, fixed text/count bounds, retention batches and cursor scans.
  It owns no global recorder, endpoint, authorization, clock or timer.
  Canic adoption and governed stable-adapter qualification remain separate work;
  see [the logging boundary](docs/architecture/logging.md). Publication is selected per package.

- Metrics owns application observation recording and optional bounded heap retention.
  Keep fixed recorders allocation-free and the library `no_std`, with no production
  dependencies. Consumers own platform reads, units and attribution.
- Recorder types implement neither Serde nor Wire. Canic's adapter owns report
  validation and projection without making report readers depend on Metrics.
  Numeric implementation details stay private. Governed storage adapters use
  only the explicit `persistence` restoration contract; heap retention stays optional.
- Governed durable adapters belong at the Storage integration boundary, outside
  these instrumentation packages. Historical `ic-metrics-storage` and
  `ic-logging-storage` names do not establish availability in the current Storage
  product. Review its current public contract before planning an adapter; do not
  recreate retired packages or add stable-memory dependencies here. Preserve
  Logging's passive checkpoints, sequence/time watermarks and canonical restoration.
  Hosts own durable identity, allocation, lifecycle and checkpoint cadence.
- Wasm inspection tooling belongs to its supplying native-tool owner. The former
  `ic-host-wasm-inspect` package is historical, not an assumed current executable.
  Optional experiments select an available, qualified tool; Metrics owns no
  inspector wrapper, pin or workspace dependency.
- Source-less lock packages must be workspace-owned; external path dependencies
  are not permitted. Metadata advances only the selected group; other groups
  retain their identities and ledgers. Publication selects that group's packages.
- Consumer code owns measurement attribution, labels, registry limits, replication
  policy, reset authorization, restart identity, persistence, lifecycle hooks, and endpoints.
- Metrics' maintainer-selected bounded recording extension (2026-10-28) permits
  `alloc` only behind the `recording` feature. The shared table owns retention
  and omitted-observation accounting; generic windows own nonwrapping reset
  sequences, never platform clocks or globally unique identity.
  Do not add dependencies on IcyDB, Canic, `ic-timers`, or `ic-backup`.
- IcyDB's inclusive overlapping spans and Canic's exclusive endpoint accounting
  remain separate consumer contracts. Do not add an attribution-mode switch.
- Units and overflow are explicit. Zero is a valid sample; no samples is a
  different state. Overflowed totals are unsuitable for exact interval arithmetic.
  Counter identity must be established before comparing snapshots.
- Native substitutes are not IC measurements. Never add product timing benchmarks or
  convert instruction counts into estimated cycles. Permitted performance
  evidence is instruction counts, IC cycles, and raw Wasm bytes.
- Public evidence must exclude private sibling source, search excerpts and issue
  bodies. Select payloads explicitly; read access is not export authority. Follow
  [the archive distribution record](docs/evidence/archive-distribution-072.md)
  for original retention and separately identified sanitized receipts.

## Work and validation

- This consumer supports `RELEASE_DELIVERY=direct` only. PR release delivery
  needs separately adopted merged-checkout adapters and qualification. Group increments use
  Shared's automatic frozen capture with the locally qualified candidate setup
  and hooks; publication remains explicit. See [independent releases](docs/releases/independent-releases.md)
  for deferred-work custody and batch recovery.
- Use Rust edition 2024 and this repository's `target/`. No string matching on
  errors or production panics.
- After Rust edits, run `make fmt`, then selected package checks or named tests.
  Focused commands and host qualification are in [docs/development/hosts.md](docs/development/hosts.md).
  Full local `make ci` is for explicitly requested aggregate checks; `make msrv`
  admits the pinned compiler. Neither is an additional full release gate.
  Releases run fresh admission, strict lint and selected-package
  product checks under the [delivery plan](docs/releases/independent-releases.md).
  CI covers both products; changed pipeline wiring uses focused qualification
  or `make tooling-check`, never a nested regression matrix inside deployment. Hosted CI covers both packages asynchronously; these
  local gate names do not require a completed GitHub Actions run.
  Follow [the validation policy](TOKO-TOOLING.md#validation-and-evidence)
  for batched focused checks and evidence reuse. Documentation-only work needs
  link, consistency and diff checks.
- Fix warnings in the selected Clippy gate before later validation.
- When shared contracts change, review the IcyDB, Canic, `ic-timers`,
  `ic-backup`, IC Blob Storage test-probe and Toko Miner callers under
  [the downstream contract checks](docs/architecture/extraction.md#downstream-contract-checks).
  Each consumer owns its qualification; review does not authorize sibling edits.

## Dependency qualification

- Use the installed common setup/check interface and its selected host/IC catalogs.
  No Metrics tool-catalog exception applies. Local commands and native qualification
  belong in [host guidance](docs/development/hosts.md); follow the installed
  baseline's revision-bound setup references rather than a parallel policy.
- Metrics selects the released IC Build metadata editor in `ci/release-tools.env`.
  Explicit setup installs it through the shared managed installer; checks and
  metadata preparation only admit an already prepared selection. It is tooling,
  never a dependency of the instrumentation library.
- `make check-pins` requires prepared Git, jq and Mike Farah yq. Checks never
  install tools or unlock dependency graphs. Select product CLI adapters through
  the shared managed installer; local selectors implement the approved compiler policy.
- Apply the baseline's common audit methods only when requested. Product scope is
  Metrics/Logging and their owning tooling; affected consumer contracts are mapped
  in [the extraction contract](docs/architecture/extraction.md).
  Existing performance evidence under `docs/evidence` retains its domain scope
  and original identities. Audit adoption schedules no review or broad gate.
