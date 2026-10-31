# Current handoff — 2026-10-31

The maintainer authorized deployment with release notes after
[PR #106](https://github.com/dragginzgame/ic-observability/pull/106) merged at
745f4081a9df1e368c9629b8e08c686af92fe199. Local main is fast-forwarded to that
commit. Deliver Metrics 0.24.1, then Logging 0.23.3 with the existing direct
release and separate crates.io publication commands. Both are compatible
patches; only maintained tooling/governance and release metadata changed.
Scoped preparation commits, standard release gates, versions, tags, main pushes
and uploads are authorized. No sibling edits or artifact cleanup are included.

## Release plan and observations

The current package versions are Metrics 0.24.0 and Logging 0.23.2. Their pending
ledgers already select 0.24.1 and 0.23.3; this delivery clarifies those entries
and lets the standard runner finalize each heading and UTC release date.
The root changelog remains an index. No aggregate workspace version is added.
Use explicit RELEASE_GROUP=metrics or logging for every group command.

The official sparse index confirms both current versions are non-yanked and
both candidates absent. The crates.io API returned HTTP 403, so no absence claim
is derived from that API response. Remote main is the merged commit; neither
candidate release tag exists. Initial observations and all delivery logs belong
under target/deploy/shared-tooling-02722-20261031/.

All five PR CI jobs passed on head 0710dac5d74e02582ab95eceed203252452371ab:
TypeScript, Rust 1.91 MSRV, Linux, Intel macOS and Apple Silicon macOS. This is
source qualification; the standard release still runs its own complete local
ci/msrv gates and archive verification. Publication retains its own Clippy gate,
exact source/package selection, dry-run and upload receipts.

## Adopted source and catalog

Canonical export selected Shared 143a9abb9ae81feae9400ff3844b03b1ddfdd75a,
with commit/changelog titled 0.27.22 and committed VERSION still 0.27.21. The
maintainer explicitly confirmed that exact revision. Snapshot provenance retains
the committed display version and full revision; no relabeling is needed.
The clean source was isolated from the sibling's uncommitted VERSION edit.
Exporter-owned payloads and ownership records remain untouched after export.

Every member has a root workspace dependency alias with its path and full current
version, registered to its release group's dependencies roster. These unused
catalog declarations add no library dependency edges. Each group appears once
in a contiguous block with a short title and separate changelog comment. Release
preparation updates only the selected group's root requirement and rejects
stale aliases even when unused or owned by another group.

## Evidence and retained boundaries

Incremental adoption receipts: target/audits/shared-02722-20261031/.
Formatting, snapshot integrity, pins, docs links and pending-ledger checks passed.
Both actual plans and the named release fixture passed with the new layout;
locked Cargo metadata was exactly equal before/after, and Cargo.lock identical.
Prior complete release-tools-check evidence remains at
target/audits/shared-02721-20261031/ and
target/evidence/native-ci/fixture-retention.djSfl5/.

Metrics keeps Wire/Derive 0.13 and the optional native metadata boundary. Logging
keeps its dependency-free heap engine. Arithmetic, Serde fields, schemas, encoded
bytes, typed errors and retained log contracts are unchanged. The prior
[Wire receipt](../evidence/wire-0130/README.md) retains registry-only Principal/
Account qualification with Types 0.15.1/facade 0.15.2 and Rust 1.91/Wasm checks.
All prior release journals, archives and deployment receipts remain retained.
Canic #712/#100 and downstream integration ownership remain separate.
