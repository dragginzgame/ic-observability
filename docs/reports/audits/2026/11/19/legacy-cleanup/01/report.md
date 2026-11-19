# Observability legacy cleanup — 2026-11-19

**PASS WITH FINDINGS within the retirement scope.** The starting commit was
`8cb68c14f88ddbc73da189540f3ca084dc08cb87`. The working tree already held the
[0.45.21 adoption and formatting pass](../../hygiene-adoption/03/report.md).
The review used [module surface hardening](https://github.com/dragginzgame/toko-tooling/blob/626da7cd9626cc2e152594862a2d82ea82ef51da/audits/module-surface-hardening.md)
and [authorized cleanup](https://github.com/dragginzgame/toko-tooling/blob/626da7cd9626cc2e152594862a2d82ea82ef51da/audits/module-cleanup.md)
to trace the retired Wire directory, both packages’ source and test entrypoints,
and the current Make, CI and release fixture callers. The starting
`AGENTS.md` SHA-256 was
`47d82d38075266b9ffe2b1d9ea16edfd6e629e753d3cc862170348d7dc10148d`.

## Findings and dispositions

| Candidate | Caller and disposition |
| --- | --- |
| Retired Wire qualification directory and scan entries | **LOW, high confidence.** Two historical READMEs were the only remaining files. The documentation gate still named the directory and the native input selector still included it. Removed those entries and the directory. Historical links now point to the [archived source README](https://github.com/dragginzgame/ic-observability/blob/8cb68c14f88ddbc73da189540f3ca084dc08cb87/qualification/wire-identities/README.md) and [archived registry README](https://github.com/dragginzgame/ic-observability/blob/8cb68c14f88ddbc73da189540f3ca084dc08cb87/qualification/wire-published/README.md). Both match the deleted local copies byte-for-byte. The root workspace continues to exclude the directory. |
| Empty `ci/dependency-pinning-exceptions.json` | **LOW, high confidence.** This file has contained an empty list since its former exception was retired. The installed checker constructs the same empty list when the file is absent. A disposable fixture passed the same pin check without the file. It remains a separate optional policy-file cleanup. |
| CI setup logs with legacy filenames | **Live diagnostics.** The failure collector and archive readback fixture still select these files. Removing the aliases would require changing the current evidence contract and requalifying the consumer. |
| `scripts/release/fixtures/{bash,cargo,git}.sh` | **Live test support.** `prepare_make_fixture` selects the scripts dynamically by command name. The standard release and publication fixtures still invoke that setup. |
| Retired `native-wire` feature refusal | **Live admission.** The production declaration checker rejects reintroducing the old feature even if it has no dependencies. The declaration fixture exercises that case. |
| Package tests, public restoration APIs and the Wasm fixture | **Live product and test boundaries.** The packages own their examples and tests, consumers own their restoration calls, and the release gate executes the allocation-free fixture. The review found no orphaned production Rust module. |

## Verification

- The native source fixture passed with a Git-tracked qualification input
  excluded and a missing tracked product input still selected for rejection.
- The real native input recorder hashed both package roots from the working tree
  and omitted the retired root. Logs and the pin fallback check are under
  `target/qualification/legacy-cleanup.oExIPb/`.
- Both archived README destinations were verified against their exact GitHub
  revision. Repository documentation links, dependency pins and diff checks passed.

This was a local source and caller audit with focused CI-input verification.
Existing release receipts and runtime qualification retain their original scope.
