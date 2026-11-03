# Current handoff — 2026-11-03

**Shared Tooling 0.28.2 and the fix for [#129](https://github.com/dragginzgame/ic-observability/issues/129) are implemented locally and uncommitted.**
The snapshot selects 148 files from reviewed committed revision
`5cf67f81c50c56ac17389ae71a3a87d46e86e8a2`, verified against remote main and
annotated release tag `v0.28.2`; the supplier ledger is dated 2026-11-03.
[Adoption/issue evidence](../evidence/shared-tooling-0282-20261103.md) records scope,
caller qualification and retained logs. Tool selections/build identities are
unchanged; prepared offline tools and snapshot integrity checks pass.
No package version, dependency graph or library source was changed.
The pre-existing two-line Cargo.toml comment edit remains untouched.

Full CI and release selection now consume one declared stage roster through
Shared's roster interface. Full CI runs it once per required host, with explicit
workspace scope through recursive Make. The local Make-recipe parser and generic
baseline/event/timing/checkpoint parsing are removed. Shared observes annotated
ancestor baselines and admits fresh retained execution evidence. Local policy
still owns the independent package mapping, exclusions, compiler/configuration,
source/index, metadata and publication authority.

Future releases use consumer receipt identity `group-validation:2`, binding
Shared's canonical proof before version preparation. Late admission checks sealed
byte custody and regenerates selection/configuration, while existing metadata
checks admit prepared files. The physical checkout root is bound; relocation,
missing evidence and changed configuration refuse. No stage reuse or version
projection is enabled. Existing completed version-1 receipts retain their recorded
adapter and meaning; they are not converted or reinterpreted.

Routine CI keeps mapping/helper/custody regressions. Matched full/selected command
comparison and full-CI ordering/jobserver qualification are explicit through
`make release-validation-qualify`, renewed after mapping, runner, configuration or
covered-contract changes. This adoption exercised that path. The metadata fixture
uses two explicit substitute stages, preserving its real renderer/receipt/recovery
proof without replaying every unrelated fake CI stage. Production keeps all 21.

Both package mappings, fresh Shared evidence, prepared-metadata custody, changed
proof/configuration refusal, relocation rejection, full-CI workspace selection,
strict-lint ordering and recursive jobserver propagation pass on Linux. Actual
metadata/rollback/resume/publication-selection fixtures pass for both groups;
Cargo upload and broad gates are substituted, retained consumers run real Rust.
The matched comparison also passed with inherited runner depth 3. The metadata
fixture requalified real prepared-file and protected-proof recovery for both groups.
No full repository gate or new hosted/macOS acceptance is claimed for this local
adoption. Linux and both macOS native CI obligations remain unchanged.
Deployment is requested for Metrics 0.28.2 and Logging 0.24.5 through the
established direct `origin/main` and crates.io flow from this normal checkout.
Close #129 only after delivery and complete required native CI acceptance.
No implementation blocker remains. The earlier
[0.28.1 local proof](../evidence/shared-tooling-0281-20261103.md) remains retained.

**Published state remains Metrics 0.28.1 and Logging 0.24.4.**
[Verified delivery](../evidence/shared-tooling-0280-delivery-20261103.md) records
both 21-stage release plans, official checksums and exact archive/source proof.
Source preparation: `973ccdfe849fc499f17988b1e296584393d2897a`.
Metrics: `3b4c4c353dff8d7746016ceb03091c6b6e611b38`, `metrics-v0.28.1`.
Logging: `97c274403b07c993a251adad85848f463c5cc805`, `logging-v0.24.4`.
Receipt follow-up HEAD: `6fd6efc443fd32222416081c6b7dae3d3674815c`.
Do not replay uploads; `make verify-publication RELEASE_GROUP=...` is readback-only.
The earlier [0.28.0 snapshot adoption](../evidence/shared-tooling-0280-groups-20261103.md)
retains its original 145-file revision and version-1 qualification.

Metrics owns arithmetic, state admission and validated Serde, with optional
bounded recording; it has no Wire/Platform/endpoint dependency. Services own
report DTOs, Wire metadata, codecs and clients. Use the
[0.28 migration](../../releases/metrics/0.28.md). Logging remains a dependency-free
heap engine; Persistence owns both opted-in stable adapters. No library contract
or retained-data reset is introduced by this tooling adoption.

Observability #128 was closed after the
[Metrics 0.28.0 delivery](../evidence/metrics-0280-delivery-20261103.md).
Consumer migrations remain with Blob #113, IcyDB #614, Relay #22, Storage #154 and
Canic #523; Toko Miner owns removal of its explicit feature selection. No sibling
acceptance, mutation or delivery is claimed. Earlier receipts, original deployment
checkouts, publication proof, stash safety copies and private retained evidence
keep their original scope. No unrelated artifact cleanup ran.
