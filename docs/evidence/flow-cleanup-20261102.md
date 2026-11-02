# Five flow simplifications — 2026-11-02

The maintainer authorized the five findings from the read-only review at
`f3ede3716d549d61ac5d9aca66a51fe6914ab34e`. Implementation uses the adopted
flow-convergence/complexity methods and module-cleanup procedure at Shared
revision `fd9390ef797bfad8aaa05fdba8fcddec753b572c`, with AGENTS.md's product
boundaries. These are local changes, not release or publication evidence.

## Implemented ownership changes

| Finding | Result and preserved boundary |
| --- | --- |
| Tool admission mixed with setup fixtures | `typescript-setup-check` only admits prepared Node/npm. Explicit `typescript-setup-policy-check` runs in TypeScript CI and standard release validation before the unchanged complete CI/MSRV gates. Preflight stays admission-only; neither guard is removed. Native `make ci` remains Node-free. |
| Duplicate native evidence collection routes | Every scenario executes collection, status admission and diagnostic checksum verification once before branching into archive-failure or readback assertions. All 15 independent scenario expectations remain. |
| Repeated Logging text accounting | One helper selects the source/topic/message byte components. Append sums in u128 before admission, restoration checks every addition and bound independently, and eviction subtracts only previously admitted components. Error priority, retention and passive checkpoint formats remain unchanged. |
| Redundant source/published fixture inputs | One mode controls qualification. Only source rendering parses and supplies the Metrics package manifest; published rendering has no such argument. Both modes keep independent catalogs, locks, compiler checks and graph admission. |
| Repeated browser subprocess diagnostics | One test-local helper executes Node/tsc, retains stdout/stderr and rejects failure. Typed-client compilation and runtime byte/refusal assertions remain separate, with the same log names and stale-output refusal. |

No public API, schema, encoded byte, dependency selection or package version
changes. The appropriate pending patch notes are Metrics 0.27.1 and Logging
0.24.2; actual package identities remain 0.27.0 and 0.24.1. Original root and
Metrics README edits remain byte-for-byte intact.

## Focused qualification

Passing on Rust/Cargo 1.99.1, Linux x86_64:

- `make fmt`; strict native Clippy for Logging library/tests and native-wire
  Metrics library/tests; strict Wasm library Clippy for Logging.
- Logging library: 30 tests pass, one extended model exploration remains ignored.
  Existing contract, corruption and independent operation-history cases cover
  text bounds, atomic refusals, eviction, retention and restoration.
- Actual setup admission and the separate failure fixture pass on prepared
  Node 24.21.0/npm 12.2.0. The exact ignored browser test passes with the locked
  TypeScript compiler, executing all five maintained report cases.
- Renderer source/registry preservation and collision refusal pass, including
  the published invocation without a source-manifest argument. Missing/malformed/
  stale published intent still refuses before Cargo effects. Both real identity
  probes pass strict Clippy, three Principal/Account schema/byte/refusal tests
  and Wasm; actual registry composition also executes successfully.
- All 15 native evidence cases pass with action/Make effects substituted. The
  standard Make fixture passes. The actual grouped release-admission fixture
  passes both groups, including setup-policy failure before CI, input drift,
  rollback, exact metadata, receipt/resume and publication selection. Its broad
  gates/uploads are substituted; its Git remotes are disposable local fixtures.
- Shellcheck with sourced files, Perl syntax, Actionlint, CI selection,
  documentation links and diff consistency pass.

Raw checks are retained under `target/cleanup-followup-20261102/`. Source and
registry probe reports are `target/qualification/wire-identities.tiYNPl/report/`
and `target/qualification/wire-published.nZbQgR/report/`. Native evidence is
`target/evidence/native-ci/native-evidence.zFEHsC`; actual group-admission
evidence is `target/observability-release-groups.HQ4PsK`.

## Logging Wasm size check

Matched disposable source copies use identical runtime-input scan and
restore/prune exports, locked dependency-free fixtures, Rust 1.99.1 release
defaults and wasm32-unknown-unknown. LLVM readobj 18.1.3 reports sections.

| Source | Complete uncompressed module | Code section |
| --- | ---: | ---: |
| Review baseline | 43,606 bytes | 30,769 bytes |
| Shared text components | 43,587 bytes | 30,750 bytes |

Both decrease by 19 bytes for this probe. This is static size evidence, not
executed IC instruction/cycle qualification or a general performance claim.
Source copies, manifests/locks, logs, modules and section reports remain in
the raw evidence directory's `wasm-before` / `wasm-after` inputs and outputs.

The first release fixture refused a stale native-input receipt for the prepared
IC Build 0.73.0 editor. Explicit pinned setup reused a qualifying cached build;
the subsequent fixture passed. The first disposable Wasm build lacked the
included README; adding that fixture input allowed both matched builds to pass.
Original failed logs and fixture inputs remain retained. No tool version changed.

Full CI/MSRV release gates, hosted native/macOS execution, sibling builds,
commits, releases, publication and artifact cleanup were not run for this batch.
