# Observability formatting, hygiene and Toko Tooling 0.45.21 — 2026-11-19

## Scope and result

**PASS within the formatting and adoption scope.** The starting source was
`8cb68c14f88ddbc73da189540f3ca084dc08cb87`. The local overlay SHA-256 is
`47d82d38075266b9ffe2b1d9ea16edfd6e629e753d3cc862170348d7dc10148d`.

The [code hygiene method](https://github.com/dragginzgame/toko-tooling/blob/626da7cd9626cc2e152594862a2d82ea82ef51da/audits/code-hygiene.md)
and the updated [Rust hygiene guide](https://github.com/dragginzgame/toko-tooling/blob/3846fcb68e52a00c4a5ee5376c3e4ab8ac1f80af/docs/principles/rust-code-hygiene.md)
guided the review of both crates, their tests and examples, retained-consumer
fixture sources, workspace lints and the adopted snapshot. This is a follow-up
to the [0.45.15 report](../02/report.md). The return-spacing rule and additional
formatting coverage make counts from the two reviews unsuitable for comparison.

## Findings and dispositions

- **LOW, mechanical, corrected.** A syntax-based pass visited 42 tracked
  Rust files. The resulting diff adds 71 blank lines in 23 files, before
  explicit returns or implicit result expressions that follow statements.
  The review excluded loop-body control flow that yields no value and
  kept comments with their expressions. A second scan found no further
  candidates. Diff inspection confirmed every Rust change adds a blank line.
- **LOW, workspace lint policy, corrected.** Both packages inherit the
  shared `empty_line_after_doc_comments` allowance from the root lint table.
  Entity and adapter headers can use the shared spacing without per-item
  suppression. The portable recorder and heap types own no canister entities,
  schema adapters or endpoint mounts that need the new layout.
- **Snapshot adoption.** Crates.io listed 0.45.21 as the latest non-yanked
  release. The exporter updated the rules and receipt while retaining the
  56-entrypoint, 112-file payload. The lockfile changed only for Toko Tooling.
  IC Build and formatter selections retain their previously qualified versions.

The source review found no tracked symlinks, alternate module layouts, Rust lint
suppression attributes, or direct production panic or unsafe sites. Metrics
restores retained observations through typed admission, and Logging validates
retained rows and watermarks before constructing a restored log. The only
Wasm-specific source remains the allocator-free fixture. Its guards select
the entry point and panic handler, with shared recording arithmetic. The
guard-removal evidence from 0.45.16 remains at
`target/qualification/toko04516-cfg/`. The affected fixture built and ran
natively and linked on Wasm in this review.

## Verification

Linux x86-64, Rust 1.100.0, locked Cargo inputs. Logs are under
`target/qualification/toko04521-hygiene/`.

- Authenticated preview, installation, prepared-tool checks, offline snapshot
  admission and dependency pin checks passed.
- `make fmt` and warning-denied native all-target and Wasm library Clippy
  passed for both packages with all features.
- 62 Metrics library tests, 3 typed-recording tests, 34 Logging library tests
  and 5 byte-budgeted export example tests passed. The extended Logging model
  remained explicitly ignored.
- The native allocator-free example assertion and allocator-free Wasm link
  passed with default features disabled. Production dependency declarations,
  package and repository documentation links, and the diff check passed.

This pass used local source inspection and focused native and Wasm execution.
Aggregate CI, hosted results, downstream runtime acceptance and deployment
are outside the recorded scope.
