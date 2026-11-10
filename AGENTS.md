# IC Observability Agent Rules

Apply the installed [Toko Tooling baseline](TOKO-TOOLING.md) and its
revision-bound references. [.toko-tooling.snapshot](.toko-tooling.snapshot)
records the adopted payload; do not edit it or follow a moving sibling baseline.
This overlay owns product safeguards, local commands and approved exceptions.
The baseline owns common action authority, validation, compiler and reporting rules,
including scoped `git add -N` when validation requires new task-owned paths.

Read [the current handoff](docs/status/current.md), and
[the extraction contract](docs/architecture/extraction.md) before recording,
consumer-contract or persistence-boundary changes. No baseline exceptions apply.

## Ownership

- This renamed workspace owns the independent `ic-metrics` and `ic-logging`
  packages. They share the root catalog and lockfile, with no dependency on one
  another. Each group owns literal package versions and its ledger under
  releases/metrics or releases/logging. The root has shared metadata and changelog
  navigation, with no aggregate version. Coordinated history is in releases/history.md.
  Membership is explicit in ci/cargo-release-groups.json and root Cargo comments.
  The root Cargo catalog and lock select tooling; use the installed common
  setup/check interface. Custom deployment adapters must run
  `toko-tooling-check` before effects. Tooling stays outside production graphs.
  The root dependency catalog lists both members with full current versions and
  paths; each alias belongs to its group's dependency roster. Catalog entries
  alone add no dependency edge between the libraries.
  Both product packages remain under `crates/` in the virtual root workspace,
  which explicitly excludes `qualification`. No maintained qualification package
  or workspace exists here; the two `qualification/` README files retain retired
  history only. Unit tests, integration tests and examples remain package-local.
  The shared observability contract owns the application-tree instrumentation
  boundary and Canic's reporting authority. The concrete public API and remaining
  consumer repair map are recorded in [the API inventory](docs/architecture/metrics-api.md).
  [#130 — Restrict Metrics to instrumentation](https://github.com/dragginzgame/ic-observability/issues/130)
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
- IC Storage owns the separately opted-in `ic-metrics-storage` package, its
  governed Storage integration, tests and release. This repository owns
  recording and the explicitly selected `recording` store. Hosts retain allocator
  selection, lifecycle, instance identity and write cadence.
  Never add stable-memory dependencies to the instrumentation package.
- IC Storage likewise owns the separately selected `ic-logging-storage`
  adapter, durable codec and governed storage qualification. Logging owns passive
  checkpoints and canonical restoration, including sequence/time watermarks after
  complete retention. Keep its heap engine dependency-free; hosts select durable
  identity, allocation, lifecycle and checkpoint cadence.
- IC Tooling owns the published `ic-host-wasm-inspect` CLI, its installation guide
  and Rust floor. Optional evidence experiments select their own qualified tool
  identity; Metrics owns no inspector wrapper, pin or workspace dependency.
  Source-less lock packages must be workspace-owned; external path dependencies
  are not permitted. Release metadata advances only the selected release group;
  other groups' identities and ledgers remain unchanged. Publication selects the
  group's packages separately from release delivery.
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
- Native substitutes are not IC measurements. Never add timing benchmarks or
  convert instruction counts into estimated cycles. Permitted performance
  evidence is instruction counts, IC cycles, and raw Wasm bytes.
- Public evidence must exclude private sibling source, search excerpts and issue
  bodies. Select payloads explicitly; read access is not export authority. Follow
  [the archive distribution record](docs/evidence/archive-distribution-072.md)
  for original retention and separately identified sanitized receipts.

## Work and validation

- Mutate only this repository unless exact sibling targets are explicitly
  authorized. The shared [contribution rules](https://github.com/dragginzgame/toko-tooling/blob/12459b6029115b830b8477879d3bea2f030b6e63/rules/contributions.md) govern
  authorized PRs and release effects.
- This consumer supports `RELEASE_DELIVERY=direct` only. PR release delivery
  needs separately adopted merged-checkout adapters and qualification; ordinary
  contribution PRs retain the shared contribution rules. Group increments use
  Shared's automatic frozen capture with the locally qualified candidate setup
  and hooks; publication remains explicit. See [independent releases](docs/releases/independent-releases.md)
  for deferred-work custody and batch recovery.
- Use Rust edition 2024. No string matching on errors or production panics.
- Check for active builds before source edits or compilation. Use this repo's
  `target/` and locked dependencies; do not upgrade dependencies as a side effect.
- After Rust edits, run `make fmt`, then selected package checks or named tests.
  Focused commands and host qualification are in [docs/development/hosts.md](docs/development/hosts.md).
  Full `make ci` and `make msrv` are release gates or explicit
  check requests. Releases select the qualified
  [group validation plan](docs/releases/independent-releases.md); shared or uncertain inputs
  retain the full roster. Repository CI still covers both packages.
  Follow [the validation policy](TOKO-TOOLING.md#validation-and-evidence)
  for batched focused checks and evidence reuse. Documentation-only work needs
  link, consistency and diff checks.
- Fix warnings in the selected Clippy gate before later validation.
- When shared contracts change, review the IcyDB, Canic, `ic-timers`,
  `ic-backup`, IC Blob Storage test-probe and Toko Miner callers under
  [the downstream contract checks](docs/architecture/extraction.md#downstream-contract-checks).
  Each consumer owns its qualification; review does not authorize sibling edits.

## Dependency qualification

- Follow [shared local setup](https://github.com/dragginzgame/toko-tooling/blob/12459b6029115b830b8477879d3bea2f030b6e63/docs/adoption/local-setup.md) and the selected catalogs
  in `ci/tool-versions.env` and `ci/ic-tools.tsv`; Metrics has no tool-catalog
  exception. [make/consumer.mk](make/consumer.mk) owns common setup/check,
  formatting, hook and release recipes. Local host qualification and commands
  remain in [docs/development/hosts.md](docs/development/hosts.md).
- Metrics selects the released IC Build metadata editor in `ci/release-tools.env`.
  Explicit setup installs it through the shared managed installer; checks and
  metadata preparation only admit an already prepared selection. It is tooling,
  never a dependency of the instrumentation library.
- `make check-pins` requires prepared Git, jq and Mike Farah yq. Checks never
  install tools or unlock dependency graphs. Select product CLI adapters through
  the shared managed installer; local selectors implement the approved compiler policy.
- Shared structural reviews use [the common methods](https://github.com/dragginzgame/toko-tooling/blob/12459b6029115b830b8477879d3bea2f030b6e63/audits/README.md), with
  this overlay's allocation, units, counter identity and ownership constraints.
  Source scope includes `crates/ic-metrics`, `crates/ic-logging`, owning
  tooling and the affected downstream contracts in `docs/architecture/extraction.md`; focused
  commands remain in `docs/development/hosts.md`.
  Existing performance evidence under `docs/evidence` retains its domain scope
  and original identities. Audit adoption schedules no review or broad gate.
