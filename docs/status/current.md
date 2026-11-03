# Current handoff — 2026-11-03

**Metrics 0.28.2 and Logging 0.24.5 are delivered and verified on crates.io.**
[Delivery evidence](../evidence/shared-tooling-0282-delivery-20261103.md) records
release identities, complete local plans, official checksums and archive/source
comparisons. Both releases ran from this normal checkout on `main` through the
established approved direct `origin/main` flow. Each package was uploaded once.
Source implementation: `ae36ac071f5f2cacef7d449203ef06ad75107598`.
Metrics release/tag: `1a991a37e5dbd02efee5af38f77180cc8450e1c9`, `metrics-v0.28.2`.
Logging release/tag: `5069d8827001ff7ae67a90d5c763bab6152c59cc`, `logging-v0.24.5`.
The two releases preserved unrelated group metadata and passed all 21 local
workspace-scope stages independently (407 and 423 summed stage seconds).
Official readback verified all 32 maintained Metrics files and 12 Logging files.
Use `make verify-publication RELEASE_GROUP=...` for readback; never replay uploads.
The pre-existing two-line Cargo.toml comment edit is restored and compared with
its saved patch, with safety copies retained in the local stash and delivery folder.

**#129 is closed after delivery and qualification on all three required hosts.**
[CI run 41640061420](https://github.com/dragginzgame/ic-observability/actions/runs/41640061420)
completed successfully on the final Logging release commit. Linux x86_64,
macOS Intel x86_64 and macOS ARM64 each actually ran and passed native CI,
including evidence retention and upload. The exact source, expected host jobs,
native steps and overall success were checked in the retained run response.
Superseded runs and documentation-only skips are excluded.
[#129](https://github.com/dragginzgame/ic-observability/issues/129#issuecomment-6605109269)
was closed after verification at `2026-11-03T13:29:36Z`.
The accepted run response, logs and publication proof are under
`target/deploy/shared-tooling-0282-20261103/`.

Shared Tooling is released `v0.28.2`, reviewed revision
`5cf67f81c50c56ac17389ae71a3a87d46e86e8a2`, with 148 verified snapshot files.
[Implementation evidence](../evidence/shared-tooling-0282-20261103.md) records the
focused qualification and product/reverse-consumer/host obligations. Tool
selections, dependency graph and Rust library code remain unchanged.

Full CI and release selection use one declared stage roster through Shared's
roster interface. Full CI runs it once per required host and forces workspace
scope through recursive Make. Shared owns baseline and fresh execution evidence
admission; local policy owns package/feature mapping, exclusions, source/index,
compiler/configuration, metadata and publication authority.

Consumer receipt identity `group-validation:2` binds Shared's proof before version
preparation. Late admission checks sealed byte custody and selection/configuration,
with existing metadata/index checks. Physical-root binding rejects relocation.
No stage reuse, version projection or old-receipt reinterpretation was added.
Completed version-1 receipts retain their recorded adapter and meaning.
Routine CI keeps caller/mapping/custody regressions; matched full/selected
comparison and full-CI ordering/jobserver qualification have the explicit
`make release-validation-qualify` lifecycle for relevant changes.

The new release plans/proofs remain in `target/release-validation/` at
`metrics-0.28.2.STrFrI/` and `logging-0.24.5.799sgg/`; journals and protected
receipts remain in `.git/release-state/`. Registry/source proof is retained at
`target/publication/verification.ZZDZS1/` and `verification.uxKOTk/`.
The [previous delivery](../evidence/shared-tooling-0280-delivery-20261103.md) and
[0.28.1 local qualification](../evidence/shared-tooling-0281-20261103.md) retain
their original identities, scope and artifacts.

Metrics owns arithmetic, admission and validated Serde, with optional bounded
recording and no Wire/Platform/endpoint dependency. Services own report DTOs,
Wire metadata, codecs and clients; use the [0.28 migration](../../releases/metrics/0.28.md).
Logging remains a dependency-free heap engine; Persistence owns both opted-in
stable adapters. This tooling change introduces no library or retained-data reset.
Observability #128 remains closed after its own earlier verified delivery.
Consumer migrations remain with Blob #113, IcyDB #614, Relay #22, Storage #154 and
Canic #523; Toko Miner owns its explicit feature-selection removal. No sibling
acceptance, source mutation or delivery is claimed. No unrelated cleanup ran.
