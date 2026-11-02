# Rust 1.99.1 compiler policy — issue #124

Owner authorization: [#124 — Adopt Rust 1.99.1 and consolidate compiler qualification](https://github.com/dragginzgame/ic-observability/issues/124),
2026-11-02. Local base: `5791677a7c4250556882f10624e8c7589e577827`.
This is local implementation evidence, pending review and delivery.

The workspace support floor now matches the existing exact toolchain pin:
**Rust 1.99.1**, native and Wasm. Both members inherit it. The independent identity
workspaces are generated from the root manifest and inherit its floor too.
Published dependencies retain their original registry metadata. No dependency
requirement, lockfile, arithmetic implementation, schema, bytes or package version
changed. Metrics 0.26.0 and Logging 0.24.0 have separate pending breaking notes.

The recorded Shared Tooling snapshot remains 0.27.23. AGENTS.md records the
maintainer-approved exception to its older lowest-floor/separate-lane rule.
Shared Tooling's future policy implementation is not represented as adopted.

## Retained qualification

The [coverage map](../hosts.md#prerequisites-and-focused-checks) explains where
the former minimum-compiler checks now run once on the pinned compiler. Native
CI retains Linux x86_64, macOS x86_64 and macOS arm64, plus the separate
TypeScript/identity job. Native all-targets Clippy, Wasm library Clippy, profile
tests, allocator-free linking, workspace tests/doctests and Cargo package
verification retain their previous obligations. Native Wire/derive compilation,
real Principal/Account compatibility and executable consumer composition remain.
Optional installed-runtime experiments and historical evidence are unchanged.

The dedicated `msrv` workflow and its duplicate compiler installation/collector
are retired. `make msrv` remains compiler admission; release validation still
calls `ci msrv`, with compilation occurring in `ci`. Repository workflows have no
remaining dependency on the removed job. GitHub's main-branch response at review
reported `protected: false` and no required status-check contexts; no settings
were changed.

`compiler-check` reads the floor and exact pin, admits inherited member policy,
then records actual `rustc -vV` and `cargo -vV`. Failed observations retain partial
output and fail closed. Older/newer executables, moving/nightly pins, differing
floor/pin and conflicting `MSRV` overrides refuse. Checks never install Rust.
CI retains compiler output before managed-tool/application effects, including
failures. Successful allocator-free Wasm capture moves into native recovery
evidence. Failed links cannot capture stale files or replace prior evidence.

## Focused local results

Prepared Linux x86_64 compiler identities:

- rustc 1.99.1, commit `58cf8f9c35b355199727627d07ae34a4e2846d67`.
- Cargo 1.99.1, commit `5f94df4789f005f9a352888e8355ffc645b7ed0e`.

Passing compilation and execution, with locked offline dependencies:

- Native strict Clippy for both packages, all targets and all features.
- Wasm strict Clippy for both libraries, all features.
- Metrics minimal-profile Serde tests: four pass. The four resolved profiles
  (minimal, recording, default-native and all-feature Wasm) retain Wire/allocator
  isolation and dependency-free Logging.
- Actual no-allocator arithmetic Wasm link; successful artifact retained.
- Both packages' public doctests: 17 pass (two Logging, 15 Metrics).
- Source-copy identity consumer: strict Clippy, three real schema/byte/refusal
  tests and Wasm check on 1.99.1. This remains source alignment.
- Independently locked registry consumer: strict Clippy, three real identity
  tests, executable Metrics/Logging composition and Wasm check on 1.99.1. This
  accepts published Metrics 0.25.1/Logging 0.23.7 with Wire/Derive 0.14.2,
  canonical Types 0.16.0 and Platform 0.17.0; it does not accept future releases.
- Both selected Cargo package archives prepared and verification builds pass;
  normalized manifests declare Rust 1.99.1. These are dirty local qualification
  artifacts at existing package versions, not publication receipts.

Passing local wiring/admission checks:

- Compiler-policy rejection fixtures, successful/failed link custody, actual CI
  selector, native workflow evidence projection and release/publication Make
  adapters (including jobserver propagation and fail-fast Clippy ordering).
  The actual release-admission fixture also passes for both independent groups,
  including metadata, rollback, exact commit/tag, resume receipts and substituted
  publication. Its Git effects remain inside the disposable fixture
  `target/observability-release-groups.dzlIEP`.
- Shellcheck with sourced files, Actionlint, formatting, snapshot integrity,
  dependency pins, documentation links and diff checks.

Raw compilation logs and compiler output are under
`target/qualification/issue124/logs/`. Source probe:
`target/qualification/wire-identities.yb7CB0`; registry probe:
`target/qualification/wire-published.sDKwBv`. Each retains its own compiler record,
manifest, lock, metadata and probe sources. Maintained locks were not updated.

Retiring tracked scripts makes the live uncommitted checkout intentionally
ineligible for the source-input hasher, which refuses missing tracked files.
The workflow evidence fixture therefore ran in an isolated committed source
snapshot under `target/qualification/issue124/source`, using the documented
retirement qualification procedure. This leaves the real index and history
untouched. Fixture compiler/Make effects are substituted; they prove local
ordering, failure and custody, not hosted execution.

No full CI/release gate, new macOS hosted run, TypeScript runtime rerun, sibling
build, release, commit in the real checkout or publication ran. Existing
TypeScript runtime source and compiler selection are unchanged; its hosted job
is retained. Normal delivery still needs the applicable complete release gates
and both independent package releases for the new support policy to be published.
