# Observability rules and hygiene — Toko Tooling 0.45.22

**PASS within the adoption and hygiene scope.** The starting commit was
`52e362d7342f897b2a464cfee756edbbb34076d5`. The working tree already set
`clippy::too_many_lines` to `allow`. The adoption preserves that setting and
keeps the entity-header comment attached to `empty_line_after_doc_comments`.

The [code hygiene method](https://github.com/dragginzgame/toko-tooling/blob/626da7cd9626cc2e152594862a2d82ea82ef51da/audits/code-hygiene.md)
guided the follow-up to the [0.45.21 review](../../../19/hygiene-adoption/03/report.md).
The review covered both libraries, their test and example sources, the
retained-consumer fixtures, and Cargo lint inheritance.

- The authenticated 0.45.22 exporter refreshed the snapshot receipt. The 56
  entrypoints, 112 files, baseline bytes and prepared catalogs matched the
  previous selection. Only Toko Tooling changed in Cargo.lock.
- The new on-demand lint audit ran from the authenticated crate bundle.
  It found zero discrepancies in the root manifest and both package manifests.
  Both members inherit the root Cargo, Rust, Clippy and Rustdoc tables.
- The source review found no remaining return-spacing candidates, conflicting
  module shapes, tracked symlinks, or item-level lint suppression attributes.
  The only Wasm target predicates are in the allocator-free fixture. Its
  recording code is shared and its entry point and panic handler have existing
  guard-removal evidence under `target/qualification/toko04516-cfg/`.
- No additional cleanup was required in the reviewed Rust sources. The private
  Git-only release helpers added by 0.45.22 were outside this public workspace's
  selected payload.

Snapshot and prepared-tool admission, pin checks, `make fmt-check`, native and
`wasm32-unknown-unknown` Clippy and rustdoc for both crates, repository
documentation links and diff checks passed. The local host was Linux x86-64
with Rust 1.100.0. Logs are under `target/qualification/toko04522-hygiene/`.
This review covers source inspection and focused validation.
