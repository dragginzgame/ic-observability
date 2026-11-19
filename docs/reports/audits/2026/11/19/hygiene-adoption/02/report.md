# Observability hygiene and Toko Tooling 0.45.15 — 2026-11-19

## Scope and result

**PASS within the follow-up adoption and rules scope.** The starting point was
the local 0.45.13 adoption over Git commit
`dced96619bf812bf6bb29e6f7c10e9e18e4e8ad7`. Its pending source changes and
[original hygiene report](../01/report.md) are retained. The local overlay
SHA-256 is `47d82d38075266b9ffe2b1d9ea16edfd6e629e753d3cc862170348d7dc10148d`.

The same [code hygiene method](https://github.com/dragginzgame/toko-tooling/blob/626da7cd9626cc2e152594862a2d82ea82ef51da/audits/code-hygiene.md)
was applied to the changed [Rust rules](https://github.com/dragginzgame/toko-tooling/blob/4c6e6165b422ef3c68cd2e14b59bedb14852bacd/docs/principles/rust-code-hygiene.md)
and their affected sources, manifests, tooling and current guides.

## Findings and dispositions

- The published 0.45.15 crate checksum is
  `047d160b116c300b7dfadae595c5c7b1f184257937b7d8541b1abc3aac6b6a52`.
  The authenticated exporter updated the baseline and receipt. It retained 56
  entrypoints and 112 files. The lock changed only for Toko Tooling, and the
  installed executables and tool selection match the preceding adoption.
- The 0.45.14 rule permits a private state-module guard for Wasm-only canisters
  that exercise the same implementation in native unit tests. The workspace owns
  portable libraries. Its allocation-free Wasm fixture selects only target
  entrypoint and panic handling differences.
- The 0.45.15 rule calls for standalone doc blocks on macro-defined types.
  The inventory covered 42 Rust files in both packages and the retained-consumer
  source fixtures. Type definitions are handwritten. Derives decorate those
  types, and the other macros implement expressions or incorporate documentation.
  The new rule required no source edits or additional checker selection.
- **LOW, documentation, corrected.** The README implied that each release checks
  both groups. It now describes repository-wide aggregate CI and explicitly
  selected group checks and publication. The two pending ledger entries identify
  the final 0.45.15 selection.

## Verification

Linux x86-64, Rust 1.100.0 and locked Cargo inputs. New logs are under
`target/qualification/toko04515-hygiene/`.

- Authenticated preview, installation, prepared-tool and offline snapshot
  admission, dependency pins, package roster and both pending ledger headings
  passed.
- `make fmt-check` and native all-target, all-feature Clippy passed for both
  packages with build warnings denied.
- Repository documentation links and diff checks passed.
- Library tests, Wasm Clippy, package document checks and diagnostic assertions
  retain their [0.45.13 evidence](../01/report.md#verification). The product
  sources, tooling marker implementation, package documentation inputs and
  diagnostic helper are byte-identical across this follow-up.

Full CI, hosted execution and delivery are outside the recorded local checks.
