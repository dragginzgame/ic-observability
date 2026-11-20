# Observability rules and hygiene — Toko Tooling 0.46.0

**PASS for adoption, the reviewed hygiene scope, and full local CI.**

The review started at `7eaa53ac9027ebf4850c6eca478f3bc7edbac06b` and preserved
the working-tree downstream roster edits. The consumer overlay was `AGENTS.md`
with SHA-256 `1376e4333b635a125e0bbfd8728e6b917810829c6a22721a907d7baea3f875f9`.
The [code hygiene method](https://github.com/dragginzgame/toko-tooling/blob/626da7cd9626cc2e152594862a2d82ea82ef51da/audits/code-hygiene.md)
guided the review of both packages, their examples and tests, and the affected
CI and release entrypoints. The [0.45.23 review](../02/report.md) predates the
new type-header requirements.

- The authenticated crates.io exporter installed checksum
  `4601d2785aaa14e01fd8656d6b3a57653337b214e027810c953595f1d91d6a8d`.
  The baseline and version-input helper changed. The selection retained 56
  entrypoints and 112 files. The catalogs and locked product dependencies were
  preserved.
- **LOW, resolved by both package owners.** Handwritten structs and enums now
  use the shared type headers, with Markdown code formatting for Clippy.
  Related steps in longer admission, restoration, and export functions are
  grouped with blank lines. Existing type placement and implementation ordering
  fit the new policy. A comparison against the starting commit confirmed that
  every non-comment, nonblank Rust line was preserved.
- The existing release callers already select `validate-release-inputs.pl
  next-version` and the common fixture lifecycle helper. The retired names
  had no maintained consumers. Caller-owned Cargo network settings still reach
  the fixture leaves. Neither product supplies a mounted public Wire API, so
  the new Wire baseline gate does not apply here.

On Linux x86-64 with Rust 1.100.0, `make fmt` and full `make ci` passed. CI
covered source and tool admission, strict native and Wasm Clippy and rustdoc,
both suites, production graphs, the allocator-free Wasm link, and verification
of both Cargo archives. Additional minimal and all-feature Wasm checks passed.
The workspace lint audit found zero discrepancies across three manifests.
Version increment and refusal probes passed, and the standard release fixture
passed with Cargo's network setting unset and explicitly offline.

The first CI attempt identified missing Markdown backticks in the new headers.
After that fix, the restricted sandbox prevented the package stage from reaching
crates.io. The complete rerun passed with registry access. Logs for all attempts
are under `target/qualification/toko0460-hygiene/`.
