# Current handoff — 2026-11-01

The latest Wire adoption and deployment is complete. [PR #122](https://github.com/dragginzgame/ic-observability/pull/122)
is merged. **Metrics 0.25.1** is Git-released, crates.io published and independently
verified with **Wire/Derive 0.14.2**. The official sparse index identified that
Wire patch as latest stable at selection. The [delivery receipt](../evidence/wire-0142-delivery-20261101.md)
records source, tags, checksum, full gates and retained evidence.

Release commit is 961183ae94ad9e1109ad18fa95798dc370b513dc, annotated tag
metrics-v0.25.1. Standard complete CI/MSRV passed in 149/3 seconds, including
archive checks, before version preparation and atomic main/tag push. Standard
publication dry run and actual upload passed native/Wasm Clippy and Cargo
verification. One upload ran from the clean exact annotated release checkout.
Official non-yanked metadata, archive checksum, clean provenance, fresh source
retrieval and all 38 maintained files match. Readback receipt is
target/publication/verification.kOdFqa. Do not replay the upload; verification-only
recovery remains independent. Plan/journal remains under .git/release-state/metrics-0.25.1*.

All three locks select Wire/Derive 0.14.2. The root minimum remains 0.14.0 and
canonical Types 0.16.0/Platform 0.17.0 remain isolated integration suppliers.
Only Metrics advanced. Logging remains dependency-free at 0.23.7, its manifest
and ledger unchanged; no Logging release or upload ran. No library implementation,
API, numeric schema, encoded/retained byte, error or Rust floor changed.

The independent registry consumer and frozen CI intent now select Metrics 0.25.1,
Wire/Derive 0.14.2, Types 0.16.0, Platform 0.17.0 and Logging 0.23.7. Only the
Metrics version/checksum record changed in the post-publication lock update.
Strict Clippy, three real Principal/Account schema/byte/refusal tests, composition
execution on Rust 1.91 and Wasm compilation pass. Both libraries are registry
dependencies. Absent/malformed/stale intent refuses before Cargo effects.
The source-copy and earlier registry checks remain distinct evidence.

The complete release gate rechecked arithmetic-only/recording-only isolation,
all-feature Wasm exclusion of native metadata, and the allocator-free link.
The [adoption receipt](../evidence/wire-0142.md) retains locked metadata, source
and registry identity checks, TypeScript cases and identical full src payloads
versus Wire 0.14.0 (22 Core, three Derive files). The earlier [0.14.1 receipt](../evidence/wire-0141.md)
retains its original scope. No endpoint/runtime supplier entered Metrics' graph.

Hosted PR-source MSRV and TypeScript have passed; all three native jobs remain
asynchronous at the receipt's observation. Pending jobs are not passes and are
separate from completed local release gates and exact published acceptance.
Final acceptance/migration/receipt updates need no additional product release.
Docs, pins, Actionlint and CI selection checks pass. Raw deployment logs and
new registry proof remain under target/deploy/wire-0142-20261101/; adoption/index/
archive comparisons under target/adoptions/wire-0142-20261101/. No cleanup ran.

[Migration guidance](../../releases/metrics/0.25.md) continues to require Metrics
^0.25 / Wire ^0.14 for schemas and Types ^0.16 or Platform ^0.17 for identities.
Prior [Wire 0.14 delivery](../evidence/wire-0140-delivery-20261101.md) remains
complete: Metrics 0.25.0 was uploaded once, PRs #119/#121 merged and issue #120
closed. Do not replay earlier uploads. Historical Metrics 0.24.2 is Git-only /
unuploaded. Canic stays separately owned. No sibling checkout, history or tag
was rewritten. Shared stays reviewed 0.27.23 at
619d194875369e0f72b45477b66adb430acbf6b7. No new owning issue was required.
