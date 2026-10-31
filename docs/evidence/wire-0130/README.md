# Wire 0.13 source-adoption qualification — 2026-10-31

On clean source base 0c93360 (both packages released at 0.23.2), the candidate
updates only registry Wire/Derive 0.12.1 to 0.13.0. Official index checksums match
Cargo.lock. The supplying Wire archive identifies release commit
65d1b91600d64a1e4255774f6bfc8ad9752a63cb. Rust floor remains 1.91.

| Supplier | Qualified version | Delivery status |
| --- | --- | --- |
| Wire core and derive | 0.13.0 | Published, non-yanked registry packages |
| Canonical Platform Types | 0.15.1 | Published registry package; probe only |
| Platform facade | 0.15.2, principal only | Published registry package; probe only |
| Metrics | Current source, own version still 0.23.2 | Temporary source alignment; not registry Metrics 0.23.2 |

[Metrics 0.24 migration](../../../releases/metrics/0.24.md) describes the exposed
native trait identity change. No own version bump, staging, commit, release or
publication ran for this source-adoption phase. Logging is unchanged. Metrics' actual product
graph selects no Types, Platform, endpoint or runtime integration dependency.

## Checks and preserved behavior

Raw logs, graphs, supplier records and the isolated consumer remain under
`target/audits/wire-update-20261031/`:

- Metrics library/tests/all-feature Clippy passes with warnings denied. Eight
  native transport/schema tests and 15 doctests pass on Rust 1.91. These cover
  all four measurement shapes, malformed-state admission and const bounds.
- A fresh Wire 0.12.1 Node baseline and the 0.13 candidate both pass the actual
  five-report Rust/TypeScript conformance test. Rust payload vectors, generated
  reports.ts, TypeScript output vectors and wire-runtime.ts match byte-for-byte.
- Four native-minimal/recording/default/Wasm graph profiles and four minimal
  Serde tests pass. Arithmetic-only and recording profiles exclude Wire; Wasm
  all-features excludes it too. The actual allocation-free Wasm example links
  on Rust 1.91 without an allocator or std.
- Three real Principal/Account composition tests pass on Rust 1.91. They prove
  canonical Types/facade identity equality, composition with all four Metrics
  schemas, byte goldens, subaccount distinctions and typed malformed/limit errors.
- The identity consumer passes strict Clippy and its Rust 1.91 Wasm check. Its
  locked graph has exactly one Core 0.13 and Types 0.15.1, facade principal only,
  and no Endpoint, runtime guard, CDK or IC0 package.

Principal's anonymous bytes remain `01 04`. Account's absent subaccount remains
`01 04 00`; explicit zero remains `01 04 01` plus 32 zero bytes. The subaccount
field is checked directly because Account equality normalizes absent/zero.

The probe reuses the unchanged [canonical test source](../wire-stable-identities-0121/probe.rs)
with this [manifest snapshot](Cargo.toml.snapshot). A temporary workspace owns
verbatim copies of both libraries and the probe; all external suppliers resolve
from the registry. Source comparison confirms copied Metrics Rust files match
the root. There are no sibling path suppliers, registry patches or compatibility
bridges. Exact facade/types requirements freeze qualification identities, not
product dependency policy. Initial probe preparation hit a transient disk-full
error; it recovered without this agent deleting retained artifacts.

## Reproduction and publication boundary

With the prepared toolchains, pinned Node and locked sources:

```sh
cargo clippy -p ic-metrics --lib --tests --all-features --locked --offline -- -D warnings
cargo +1.91.0 test -p ic-metrics --lib --no-default-features --features native-wire --locked --offline wire::tests
cargo +1.91.0 test -p ic-metrics --doc --all-features --locked --offline
make typescript-check metrics-profiles-check
bash scripts/ci/check-allocation-free.sh 1.91.0
```

For identity tests, copy root manifests/lock/toolchain and library directories
into a fresh temporary workspace, add a probe member using the linked source and
manifest, and prepare its own lock. Run that probe's lib tests and Wasm check on
Rust 1.91 with --locked --offline. The root lock must not acquire probe suppliers.

Only a new ic-metrics publication can supply these Wire 0.13 implementations to
native schema consumers. Published Metrics 0.23.2 still uses Wire 0.12.1. Logging
and arithmetic-only consumers need no paired release. Downstream owners were
reviewed read-only; no full sibling application graph, endpoint, hosted/macOS,
installed IC, full local CI or full MSRV suite was qualified in that source-adoption phase.

## Registry delivery and consumer acceptance

The maintainer subsequently delegated deployment. Metrics 0.24.0 is now published,
with tag metrics-v0.24.0 at commit 2a18f93a8d2e80d60279fe29ad626dc0ea5810f1.
The official index and downloaded archive agree on SHA-256
`70544c4dc1ae7697e22f2a3dd23a96de8fbcd722e7c320d72fda0c7760c2b9c6`;
the archive's clean VCS identity matches that tag. Full local ci/msrv passed,
followed by the publication Clippy gate, real dry run and successful upload.

A separate registry-only consumer uses the
[published Metrics manifest](Cargo.registry.toml.snapshot) and the same probe
source. All three tests pass on Rust 1.91, as do strict Clippy and the Rust 1.91
Wasm check. Its graph contains registry Metrics 0.24.0, Core 0.13.0, Types 0.15.1
and facade 0.15.2, with no endpoint, runtime guard, CDK or IC0. No copied Metrics
supplier or external path dependency is used for this delivery check.

Actual release/upload records, registry downloads and consumer logs are retained
under `target/audits/deploy-wire013-20261031/`. Logging remains published 0.23.2;
no Logging release was performed for this Wire adoption. Hosted/native/macOS and
installed IC acceptance remain separate from these local delivery results.
