# Current handoff — 2026-10-31

The current task adopts newly published Wire 0.13 for Metrics. The incoming
checkout was clean at 0c933601abe19497f814f092b6381104fadb070a, after the verified
Metrics/Logging 0.23.2 deployment. The maintainer has now explicitly delegated
deployment of the Wire adoption. Metrics is selected for a standard 0.24.0 minor
release and crates.io publication; Logging remains 0.23.2. Deployment records
are retained under target/audits/deploy-wire013-20261031/. The qualification
below describes the source candidate before release; completion is established
by the standard journal, remote refs and registry receipts. No sibling is selected.

## Selected identity and scope

Official registry records select Wire/Derive 0.13.0, Rust floor 1.91; lockfile
checksums match. The Wire archive identifies release commit
65d1b91600d64a1e4255774f6bfc8ad9752a63cb. Only these two package records change
in Cargo.lock. Root Metrics still selects optional native Wire/typescript;
minimal/recording and Wasm graphs exclude Wire, and every product profile excludes
Platform, Types and Endpoint. Logging remains dependency-free and unchanged.
No measurement arithmetic, typed errors or Rust schema implementation changed.

The native trait identity changes from Wire 0.12 to 0.13. The Metrics ledger now
has pending 0.24.0 notes, classified minor at Metrics' exposed native schema
boundary. Both own manifest versions remain 0.23.2. No Logging pending entry was
created. [Migration](../../releases/metrics/0.24.md), READMEs and compiled application
prose describe the candidate. [The 0.23 guide](../migration-023.md) is historical
Wire 0.12 guidance for the already published release.

## Qualification and published/source distinction

[The current receipt](../evidence/wire-0130/README.md) and manifest snapshot bind
published suppliers and the reused canonical identity probe. Raw inputs/logs,
Node baseline/candidate artifacts and the isolated workspace remain at
`target/audits/wire-update-20261031/`:

- Selected Metrics lib/tests/all-feature Clippy passes with warnings denied.
  Eight native transport/schema tests and 15 doctests pass on Rust 1.91.
- The actual five-report Node conformance check passes before and after the
  update. Rust/TypeScript vectors, generated reports.ts and wire-runtime.ts are
  byte-identical to the fresh Wire 0.12.1 baseline.
- Four dependency profiles and four minimal Serde tests pass. The actual
  allocator-free Wasm example links at Rust 1.91 without std or an allocator.
- Three real Principal/Account tests pass at Rust 1.91 against published
  canonical Types 0.15.1 and facade 0.15.2. All four Metrics schemas compose;
  identity equality, exact subaccount bytes and typed malformed/limit refusals pass.
- The identity consumer passes strict Clippy and Rust 1.91 Wasm compilation.
  Its graph has one Core/Types identity, facade principal only, and no endpoint,
  runtime guard, CDK or IC0. Its copied Metrics Rust source matches the root.

The temporary workspace owns copied libraries and probe; external dependencies
are published registry packages. Metrics source still carries numeric 0.23.2,
but this is unpublished source alignment, not registry Metrics 0.23.2 supplying
Wire 0.13. Root lock/product graphs do not acquire probe-only Platform/Types.
A transient disk-full interruption during probe preparation resolved without
this agent deleting any retained artifacts; successful checks ran afterward.
No full local ci/msrv, hosted/macOS, browser or installed IC qualification ran;
Node executes generated TypeScript, not a browser or static TypeScript checker.

## Consumers, delivery and preserved evidence

Affected owner contracts were reviewed read-only under the extraction guide,
including Scheduling's former Timers role. No complete sibling application graph
was qualified. Native schema consumers need a published Metrics 0.24 supplying
Wire 0.13; Logging and arithmetic-only users need no paired upgrade. Persistence
adapters retain their separate integration/release owner. Wire #36 owns supplier
identity/hosted acceptance; Tooling #274's older completed scope must not reopen.

Shared Tooling remains snapshot 0.27.17 at 99d04d1; Build stays 0.73.0. No tooling
adoption is bundled. Canonical group ledgers and explicit RELEASE_GROUP policy
remain intact. Prior 0.23.2 deployment evidence/journals under
`target/audits/deploy-0232-20261031/` and .git/release-state are retained, along
with older identity/evidence receipts. Canic #712/#100 remain separate work.
