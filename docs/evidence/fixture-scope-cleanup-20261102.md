# Focused fixture cleanup — 2026-11-02

The three accepted follow-up findings are implemented locally on base
`1c7db8362b3cc75d5dee25618d4f6f05dc8129fb`, alongside the earlier uncommitted
[fixture/export cleanup](fixture-export-cleanup-20261102.md). No commit, package
version, dependency selection, lockfile, release or publication changed.

Publication content cases now invoke the content verifier against the source Git
store obtained by the initial complete readback. All seven malformed archives
must fail with their independently specified rejection reason. A complete
tampered readback still matches checksum and provenance before refusing changed
source bytes. Tag/source admission, registry uncertainty, checksum corruption
and yanked-package checks remain integrated. Registry responses are substituted;
source retrieval uses a local remote, with no real registry calls or uploads.

Native-evidence scenario assertions now use one explicit case after shared
archive/checksum/outcome checks. Existing scenarios, independent expected traces,
diagnostic/recovery custody checks and archive-failure handling are preserved.
The dependency fixture runs one standard transport baseline and keeps its
separate development-dependency case and all refusal cases.

Focused checks pass on Linux:

- ShellCheck for all three changed shell scripts.
- `bash scripts/release/test-publication-policy.sh`.
- `bash scripts/ci/test-native-evidence.sh`: all 15 existing scenarios; workflow
  action results and Make effects are substituted, with no hosted/macOS claim.
- `bash scripts/ci/test-production-dependencies.sh`: synthetic declaration and
  failed/malformed/incomplete metadata cases, using the pinned Cargo 1.99.1.
- Documentation links, diff whitespace and original README preservation hashes.

Raw logs and fixture scratch are under `target/cleanup-fixtures-20261102/`;
the native fixture retains `native-evidence.MpPiDb/`. Normal success cleanup of
the publication/dependency fixtures follows their existing custody policy.
No Rust implementation changed, so earlier focused Rust/Wasm evidence remains
applicable. Full `ci msrv` and hosted checks were not run; no blocker remains.
