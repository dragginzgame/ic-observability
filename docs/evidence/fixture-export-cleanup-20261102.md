# Fixture and export simplification — 2026-11-02

Local implementation on base `1c7db8362b3cc75d5dee25618d4f6f05dc8129fb`.
The accepted three-change batch is complete and uncommitted. Metrics remains
0.27.1 and Logging 0.24.2; the independent ledgers have pending patch notes.

The retained release consumer now projects parsed Cargo fields through the same
serialization owner used by the Wire fixtures. Its policy stays separate:
the retained supplier keeps its actual version, exact requirement and disabled
defaults; only the source-identity probe normalizes Metrics to 0.0.0. Independent
release byte comparisons, other-group preservation and retained-client tests
remain intact. Synthetic fixtures cover multiline member/default arrays,
quoted strings, both suppliers and preservation of the complete remaining catalog.

Metrics retains its four resolved normal/build graph profiles. Dependency-free
Logging is checked separately with all features on native and Wasm, reducing
eight observations to six. Independent declaration admission still rejects all
Logging dependencies. The export example uses one result for budget-stop/error
state, preserving oversized-first-row errors and lossless UTF-8 continuation.

Focused evidence on Linux, Rust/Cargo 1.99.1:

- `make fmt`, selected strict Clippy for `ic-logging --example byte-budgeted-export`,
  Perl syntax checks and ShellCheck pass.
- All four export example tests and its executable walkthrough pass.
- `bash scripts/ci/test-wire-fixture.sh`, production dependency admission and
  `perl scripts/ci/check-metrics-profiles.pl` pass, including all six graphs.
- `bash scripts/release/test-release-admission.sh` passes for both release groups,
  including each retained consumer's runtime test. This runs actual local Git,
  editor and release policy in a disposable fixture; setup, broad gates, archive
  compilation and registry uploads are substituted. It performs no real delivery.
- `make wire-identities-check` and
  `make published-identities-check EXPECTED_METRICS_VERSION=0.27.1` pass strict
  Clippy, all three Principal/Account compatibility tests and Wasm compilation;
  the registry consumer also executes composition. Source-copy evidence remains
  separate from published Metrics 0.27.1/Logging 0.24.2 acceptance.
- The 142-file Shared Tooling snapshot verifies unchanged. Package manifests,
  dependency selections and all maintained lockfiles are unchanged. Original
  root/Metrics README edits match their saved SHA-256 hashes.

Raw release and identity logs are in `target/cleanup-final-20261102/`.
The release fixture is `target/observability-release-groups.cc8N7K/`;
source and registry qualification reports are respectively
`target/qualification/wire-identities.e7dvWY/report/` and
`target/qualification/wire-published.FqME5L/report/`.
Full `ci msrv`, hosted/macOS qualification and IC performance measurements were
not run for this focused batch. No blocker, sibling mutation or artifact cleanup.
