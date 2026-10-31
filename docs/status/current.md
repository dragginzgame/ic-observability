# Current handoff — 2026-10-31

The maintainer-authorized Shared Tooling deployment is complete. Metrics 0.24.1
and Logging 0.23.3 are tagged on GitHub and published, non-yanked, on crates.io.
The [delivery receipt](../evidence/shared-tooling-02722-delivery.md) records exact
commits, checksums, validation scope and retained evidence. No deployment blocker
remains. No further version bump, publication, sibling work or cleanup is pending.

## Delivered identities and notes

[PR #106](https://github.com/dragginzgame/ic-observability/pull/106) merged at
745f4081a9df1e368c9629b8e08c686af92fe199. Release-note preparation was committed
at f16e93f. Standard direct releases then delivered:

- Metrics 0.24.1: metrics-v0.24.1 peels to
  1e7193f77107a528cd99492b40df6750ddd445b5.
- Logging 0.23.3: logging-v0.23.3 peels to
  064ee4963f38db34d4e4b9ac931177364dbbfd65.

Both group ledgers are finalized with UTC date 2026-10-31. The root changelog
remains an index, and the root Cargo manifest has no aggregate version. Do not
create another pending heading until subsequent meaningful work needs it.
Every group release/publication still requires explicit RELEASE_GROUP.

## Qualification and registry readback

Both releases passed complete local ci/msrv gates and prepared archive checks.
Both publish-check dry runs and actual uploads passed their standard native/Wasm
Clippy and Cargo package-verification gates. All five original PR CI jobs also
passed: TypeScript, MSRV, Linux, Intel macOS and Apple Silicon macOS. Hosted main
runs remain asynchronous; no new installed IC or performance claim is made.

Official sparse-index reads and static archive downloads independently verify
non-yanked versions, checksums, clean Git provenance, package paths, maintained
source rosters and source bytes. Registry dependencies, features and compiler
floors match the preceding versions. The initial crates.io API HTTP 403 did not
establish absence; successful index observations supplied that fact instead.
The workspace lock changed only its two local package-version records.

Actual logs/readbacks: target/deploy/shared-tooling-02722-20261031/.
Publication intent, source selection and command statuses: target/publication/.
Exact release plans and validated/prepared receipts: .git/release-state/.
All earlier archives and journals remain retained; no cleanup or sibling edit ran.

## Adopted source and retained boundaries

Shared revision 143a9abb9ae81feae9400ff3844b03b1ddfdd75a is the maintainer-confirmed
selection. Its commit/changelog say 0.27.22 while committed VERSION says 0.27.21;
the exporter-owned snapshot correctly preserves that label with the exact revision.
The clean source was isolated from the sibling's uncommitted VERSION change.

The complete root catalog now lists current Metrics 0.24.1 and Logging 0.23.3
paths/requirements in separate contiguous blocks. Each alias belongs to its
group's dependency roster. Unused catalog entries add no library dependency edge.
Release preparation updates only its selected group and rejects stale aliases.

Metrics keeps Wire/Derive 0.13 and optional native metadata. Logging keeps its
dependency-free heap engine. Arithmetic, Serde fields, schemas, encoded bytes,
typed errors, feature isolation and retained log contracts are unchanged. The
prior [Wire receipt](../evidence/wire-0130/README.md) retains registry-only
Principal/Account checks with Types 0.15.1/facade 0.15.2 and Rust 1.91/Wasm.
Canic #712/#100 and downstream integration ownership remain separate.
