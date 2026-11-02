# Ten complexity reductions — 2026-11-02

The maintainer authorized implementation of the ranked ten-candidate review.
Base is `6799ac4c726c53aa42466a019d193c9855354822` plus the existing pending Shared
Tooling adoption and README edits. Shared methods are complexity/debt and flow
convergence at reviewed revision `fd9390ef797bfad8aaa05fdba8fcddec753b572c`, with
this repository's allocation, schema, retention and release boundaries.
This is local implementation evidence, not release or deployed-state evidence.

## Completed changes

| Review item | Implementation and preserved boundary |
| --- | --- |
| 1. Wire fixture generation | Parse Cargo/catalog inputs with prepared yq; render disposable TOML from structured fields. Multiline formatting no longer drives selection. Source package normalization changes only its version; registry catalogs remain independent. Source-catalog overlap refuses instead of silently overriding root selections. |
| 2. Dependency-profile traversal | Canonically export Shared's existing `check-cargo-graph.pl`; keep only local profile/policy selection. Normal/build edges exclude development dependencies. Recording belongs to Metrics; Logging's corresponding profile has no Metrics feature argument. |
| 3. Nested retention tests | Split publication Make qualification into its own fixture. Each full success body runs once; publication child/assertion failures exercise that smaller owner instead of replaying unrelated release cases. Actual grouped release and parent-evidence isolation remain. |
| 4. Compiler admission | Self-admitting allocation-free and Wire scripts no longer get a duplicate Make prerequisite. Other Cargo recipes, standalone entrypoints and source/publication boundaries retain their guards. Invalid registry intent still refuses before Cargo. |
| 5. Native scenarios | One explicit case table carries failure input, expected statuses and expected command traces. Expectations no longer derive from observed outcomes. Workflow bodies and collector/recovery effects remain the actual consumer callers. |
| 6. Test executables | Release/publication fixtures share small, stable Bash/Cargo/Git stubs and setup. Explicit phase data replaces executable deletion/replacement during a test. Real Make parsing, unsafe-mode refusal, jobserver propagation and lint failure stopping remain. |
| 7. Evidence selection | Each Wire attempt writes a curated `report/` with inputs, catalog, compiler and metadata. CI uploads that directory; build caches remain elsewhere. The previously unproduced catalog receipt is now a real parsed input. |
| 8. Read-only release projections | Delegate version/files/plan directly to the admitted Shared group helper. Release-only arrays/receipts are constructed only after read-only dispatch. Explicit group/delivery admission remains before Cargo. |
| 9. Native metadata | One native-only module owns Wire implementations, including fixed arrays. Canonical Serde records and `from_parts` decoding remain unchanged; Wasm/arithmetic-only compilation excludes the optional implementation module. |
| 10. Logging cursor | Derive continuation from the last consumed cursor; remove independently maintained `last_scanned`. Nonzero bounds establish the position invariant; independent model, filter, empty-page and early-stop tests retain their semantics. |

The graph helper was added through the canonical exporter at the same reviewed
revision. The snapshot now verifies 142 files. Shared payloads were not edited
locally. No application dependency, tool pin, package version or Cargo lock was
changed. The existing root and Metrics README edits remain byte-for-byte intact.
Independent arithmetic, restoration validation, source/registry qualification,
and test-model implementations were intentionally retained.

## Focused validation

Passing on prepared Rust/Cargo 1.99.1, Linux x86_64:

- `make fmt`, native strict Clippy for both libraries/tests with all features,
  and Wasm strict Clippy for both libraries with all features.
- Logging library tests: 30 pass, one extended model exploration remains ignored.
  Wire/Serde tests with native features: 12 pass; the browser test is separately
  executed. Minimal Metrics Serde profile: four pass.
- Exact ignored Rust/TypeScript browser round-trip: passes, executing the five
  maintained report cases with prepared Node 24.21.0 and locked TypeScript.
- Source-copy and actual published Metrics 0.26.0/Logging 0.24.0 consumers:
  strict Clippy, three real Principal/Account schema/byte/refusal tests each and
  Wasm compilation pass. Published executable composition also passes. Both
  retain Wire/Derive 0.14.2, Types 0.16.0 and Platform 0.17.0.
- Parsed renderer regression covers multiline tables, quote preservation,
  unchanged source fields except normalized version, independent published
  selections and rejection of overlapping source-catalog ownership.
- All four native/Wasm dependency profiles pass through the shared checker.
  Compiler-policy/link-custody and published-version-intent rejection checks pass.
- Release and publication Make fixtures pass. The complete focused retention
  fixture passes full success routes, child/assertion failures, checksummed
  retained inputs, hook failures, actual disposable grouped release/resume and
  isolation of parent logs/summaries. No real checkout release/upload is executed.
- All 15 native evidence scenarios pass with substituted compiler/action/Make
  effects. Actual source hashing, collector and archive-custody helpers run.
- Shellcheck with sourced files, Actionlint, actual CI selector, snapshot integrity,
  dependency pins, documentation links and diff consistency are checked.

Raw checks are under `target/cleanup-20261102/`. Source probe:
`target/qualification/wire-identities.UBWRtf`; published probe:
`target/qualification/wire-published.l9SQgc`. Their curated `report/` directories
retain the generated inputs and observations. Retention evidence is
`target/evidence/native-ci/fixture-retention.5WNXcv`; native scenarios are
`target/evidence/native-ci/native-evidence.PPKUxF`.

## Cursor Wasm size evidence

A disposable exported `scan_visit` example builds 32 rows and accepts runtime
scan/result/cursor inputs. It exercises visitor early stops using the original
Logging source from HEAD and the new source. Each isolated workspace owns its
copied library and uses the same example, Rust 1.99.1 release defaults and
`wasm32-unknown-unknown`, with locked offline builds. No allocator, timer,
endpoint or inspector dependency was added to the maintained library.

| Probe | Complete uncompressed module | Code section |
| --- | ---: | ---: |
| Original cursor state | 38,462 bytes | 26,419 bytes |
| Derived cursor state | 38,388 bytes | 26,345 bytes |

Both decrease by 74 bytes for this probe. This is static module-size evidence,
not executed IC instruction/cycle evidence or a general performance claim.
LLVM readobj 18.1.3 (existing `/usr/bin/llvm-readobj-18`) reports section sizes;
compiler assembly, source copies, build logs, tool identity, sections and artifact
SHA-256 values are retained under `target/cleanup-20261102/wasm-*` and
`wasm-comparison.json`. No inspection wrapper or tool pin was added.

Full `make ci`, actual release gates/publication, new hosted macOS execution,
sibling builds and artifact cleanup were not run. Existing complete release
obligations remain; passing local substitutes are not hosted qualification.
