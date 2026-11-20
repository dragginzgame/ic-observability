# Observability rules and hygiene — Toko Tooling 0.45.23

**PASS for snapshot adoption and the reviewed hygiene scope.** The requested
review started from `f83f093abe12d24c003d564e0917b1e49328b77f` with the #140
fixture repairs and a downstream roster edit already in the working tree. The
consumer overlay was `AGENTS.md` with SHA-256
`1376e4333b635a125e0bbfd8728e6b917810829c6a22721a907d7baea3f875f9`.

The review used the [code hygiene method](https://github.com/dragginzgame/toko-tooling/blob/626da7cd9626cc2e152594862a2d82ea82ef51da/audits/code-hygiene.md)
and followed the [0.45.22 review](../01/report.md). It covered the adoption
delta, maintained Cargo commands and fixtures, workspace lint inheritance,
library and test roots, and native and Wasm gate wiring. Product contract and
performance qualification stay with their existing owners.

- The authenticated crates.io export selected 0.45.23, checksum
  `34f25161ac689c2204ba923e506286b8dd06d0490d2f4143f1cd2e606e2c6067`.
  The 56 entrypoints and 112 files were retained. The exporter updated the
  shared rules document and snapshot receipt. Only Toko Tooling changed in
  Cargo.lock. The prepared executables and their catalogs passed admission.
- **LOW, resolved by the Metrics and tooling owners.** Two Metrics README
  commands forced Cargo offline and could fail on a fresh cache. The package
  verification comment also described forced offline behavior. The examples
  keep `--locked`, and the current guidance leaves network selection to the
  caller. The repository-owned commands and configuration search found only
  caller instructions and fixture assertions for explicit network settings.
- Both product source trees use the same public surfaces and typed restoration
  and admission boundaries as the prior review. The source scan found no
  tracked symlinks, production panic or unchecked unwrap calls, or item-level
  lint suppressions. The allocator-free link fixture owns all target-specific
  Rust predicates. Its linker gate still uses the minimal Metrics profile.

On Linux x86-64 with Rust 1.100.0, snapshot, prepared-tool, pin, formatting and
documentation checks passed. The workspace lint audit found zero discrepancies
across the root and both package manifests. Strict native and Wasm Clippy,
both minimal Wasm library profiles, the all-feature Wasm check, the real
allocator-free Wasm link and the native/Wasm production graph checks passed.
Dependency and standard release dispatch fixtures passed with an unset setting
and explicit offline mode. Logs are under `target/qualification/toko04523-hygiene/`.

The original #140 release-admission and uncertain-upload batch evidence remains
under `target/qualification/issue140/` for its original selection. This pass
used focused local checks. Full CI and release execution were outside its scope.
