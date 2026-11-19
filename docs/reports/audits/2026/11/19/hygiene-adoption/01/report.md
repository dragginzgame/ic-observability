# Observability hygiene and Toko Tooling 0.45.13 — 2026-11-19

## Scope and result

**PASS within the adoption and hygiene scope.** The pass covered both product
crates and their tests, the shared snapshot and directly affected CI diagnostics,
the workspace catalog, and current rules and guides. The source baseline was
`dced96619bf812bf6bb29e6f7c10e9e18e4e8ad7`, with the adoption and corrections
described below in the working tree. The local overlay SHA-256 is
`47d82d38075266b9ffe2b1d9ea16edfd6e629e753d3cc862170348d7dc10148d`.

The [code hygiene method](https://github.com/dragginzgame/toko-tooling/blob/626da7cd9626cc2e152594862a2d82ea82ef51da/audits/code-hygiene.md)
is unchanged from the previous run. The
[Rust hygiene rules](https://github.com/dragginzgame/toko-tooling/blob/a716b501274678a8ebf163ef576bbb549e974acd/docs/principles/rust-code-hygiene.md)
now include the more specific module layout and target guard requirements.
This run uses source inspection, local execution, and workflow-body fixtures
with substituted external effects. The [previous report](../../../18/hygiene-adoption/01/report.md)
retains its original pre-repair verdict.

## Findings and dispositions

- **LOW, mechanical, corrected.** Twelve Rust files had child module
  declarations after imports or re-exports, or split across their import
  blocks. Declarations now precede imports. Visibility, feature guards and
  runtime behavior are preserved. The allocator-free link fixture's Wasm
  entrypoint and panic handling still require target-specific compilation.
- **LOW, documentation, corrected.** Current guides advertised two retired
  Storage adapters and linked to a retired Wasm inspector path. The
  [Storage tree](https://github.com/dragginzgame/ic-storage/tree/ecbc2b5c8fd361085f17e985248807755107b667)
  and [IC Tooling tree](https://github.com/dragginzgame/ic-tooling/tree/2a3f9450f4e2347e0f2d392c4172729461175b39)
  confirm the package layout. Current guides describe ownership and selection.
  Historical receipt and consumer-map entries retain their original identities.
- **LOW, rules and docs, corrected.** The local overlay repeated shared rules,
  and the quick start forced offline mode. The overlay delegates common policy
  to the installed baseline. The quick start uses locked Cargo commands that
  preserve caller network settings.
- **Tooling adoption.** Crates.io listed 0.45.13 as the latest non-yanked
  release. The authenticated exporter updated the baseline and
  `SetupDiagnostics.pm` within the same 56-entrypoint, 112-file selection.
  The lock changed only for this supplier. The CI adapter still owns process
  status, archive paths and environment aliases. Console and archive tests
  cover the new Bearer and payload rules via the existing collector.
- **Optional supplier refreshes.** Registry review confirmed num-bigint 0.5.1,
  Serde 1.0.229 and cargo-sort 2.1.4 are current. IC Build 0.87.5 and
  cargo-sort-derives 0.15.0 are available. Retain qualified IC Build 0.83.0 and
  cargo-sort-derives 0.14.1 until their next separately scoped editor or
  formatter qualification. This adoption did not require changes to either
  tool's catalog or calling contract.

Metrics and Logging retain private arithmetic and heap state, typed refusal
paths, explicit restoration and dependency-free production manifests. The source
review found no tracked symlinks, alternate Rust module shapes, path-attribute
wiring or local Rust lint allowances. Native Clippy covered the ordinary
dev-dependency marker, so no Cargo target workaround was needed. The public
repository description still matches the README and package roles.

## Verification

Linux x86-64, Rust 1.100.0, repository target directory and locked Cargo inputs.
Local logs are under `target/qualification/toko04513-hygiene/`.

- Authenticated preview and update, prepared-tool checks, offline snapshot
  admission, dependency pins, package roster and both numbered ledger headings.
- `make fmt`, locked native all-target and Wasm library Clippy with all
  features and warnings denied for both packages. Both library test suites ran
  with all features, with 62 Metrics and 34 Logging tests passing. One extended
  Logging model remained explicitly ignored. Three Logging doctests passed.
- Setup evidence fixture passed 76 assertions. Package document fixture passed
  21 assertions, including missing, empty and incomplete metadata. Production
  declaration policy, package and repository documentation links, and diff
  checks passed.

The scope excludes aggregate CI, hosted upload verification, release execution,
downstream runtime acceptance and performance measurement. Existing release
evidence remains with its original source and version.
