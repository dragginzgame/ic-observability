# Current handoff — 2026-11-03

The local implementation of
[#128 — Remove Metrics' Wire metadata dependency](https://github.com/dragginzgame/ic-observability/issues/128)
is complete and uncommitted. [Implementation evidence](../evidence/metrics-wire-separation-20261103.md)
records the exact scope and focused checks. Metrics now owns only arithmetic,
state validation and Serde; services own Wire DTOs, schemas and generated clients.
No integration crate, reverse Wire dependency, endpoint or new arithmetic owner
was introduced.

Pending notes select Metrics 0.28.0 for removal of `native-wire` and public Wire
trait implementations. Actual package versions remain Metrics 0.27.2 and Logging
0.24.3; Logging's implementation, manifest and ledger are unchanged. Metrics-only
0.28.0 delivery is now authorized; full release validation and independent
publication verification are next. Sibling edits remain outside this scope.
Use [the 0.28 migration](../../releases/metrics/0.28.md) for the coordinated adoption.

Serde field names/order, u128 totals, fixed arrays and canonical numeric admission
are preserved. Native/browser schema code, Node/npm setup and Metrics-owned
pairing fixtures are retired. Historical receipts/artifacts remain intact;
qualification READMEs identify the retired scope. Native CI retains all three
hosts; removing the browser job leaves no enforced required-check reference on
main at the 2026-11-03 observation. Release validation remains complete `ci msrv`.

Focused checks pass on Linux/Rust 1.99.1: strict native all-target and Wasm library
Clippy, 79 Metrics library tests, 15 doctests, allocator-free Wasm linking, six
graph checks, dependency/feature rejection fixtures, CI selection, parsed retained
consumers and disposable release/Make routing. Formatting, pins, docs links,
ShellCheck, Actionlint and Shared snapshot verification pass. Full `ci msrv` and
hosted/macOS qualification were not run; no local implementation blocker remains.

A temporary comparison against published Metrics 0.27.2 / Wire 0.15.0 passes two
schema/byte/admission tests using current-source Metrics 0.0.0 and test-only
service DTOs. This is supplemental migration evidence, separate from the clean
maintained graph and actual service acceptance. Raw logs and source hashes are
under `target/issue-128/`; its `byte-compat/` directory owns that comparison.

Consumer DTO/qualification work remains with Blob #113, IcyDB #614, Relay #22,
Storage #154 and Canic #523, linked in the migration guide. Toko Miner also has
an explicit feature selection to remove under its owner. No sibling changes or
acceptance are claimed. Timers is unavailable locally; #128 records its prior
arithmetic-only review. Preserve consumer protocols and storage bytes, and avoid
feature unification masking reliance on removed traits during adoption.

Pre-existing README and Wire 0.15.1 lock work was saved before editing under
`target/issue-128/pre-existing.patch` and original copies. README guidance is
reconciled with the new contract; the Wire lock refresh is superseded by removal.
All retained root-lock packages are unchanged. No artifact cleanup ran.

The last published versions remain Metrics 0.27.2 / Logging 0.24.3. Their
[verified delivery](../evidence/fixture-cleanup-delivery-20261102.md) retains exact
source/tag identities, complete release gates, checksums and original readbacks.
Do not replay uploads. The older frozen pairing was historical acceptance only.
Canic, durable adapters and application runtime qualification retain their owners.

Shared Tooling remains the reviewed 0.27.26 snapshot at
`fd9390ef797bfad8aaa05fdba8fcddec753b572c` (142 files); its producer ledger marked
that version Unreleased, not a tagged release claim. The
[adoption receipt](../evidence/shared-tooling-02726.md) records its scope.
Historical Metrics 0.24.2 remains Git-only / unuploaded; published history is intact.
