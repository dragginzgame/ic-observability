# Published identity consumer

This post-publication check selects exact registry Metrics 0.24.5, published Wire
and canonical Types/facade identities. It reuses the maintained Principal/Account
assertions from [the source probe](../wire-identities/README.md), with no copied
Metrics source, patch, replacement or external path dependency. Only the probe
is a workspace member. Its recorded lock owns the registry graph independently
of the arithmetic workspace and the source-alignment qualification.

Explicit preparation: `bash scripts/ci/check-wire-identities.sh --published 0.24.5 --prepare`.
Acceptance: `make published-identities-check EXPECTED_METRICS_VERSION=0.24.5`. Checks use locked offline sources,
strict Clippy, three real schema/byte tests on the Rust floor and a Wasm check.
Preparation fetches dependencies; checks never update them or install tools.

After publishing a new Metrics version, deliberately update this catalog and run
`bash scripts/ci/check-wire-identities.sh --published X.Y.Z --update-lockfile`, reviewing
the resulting lock before preparation/acceptance. This is a separate read-only
registry-consumer acceptance step after `publish-verified`; a failed check never
repeats an upload. The frozen exact version prevents ordinary source CI from
silently qualifying an unrelated registry release or resolving latest versions.

Acceptance always requires the intended Metrics version explicitly. The catalog
must select that exact version, and resolved registry metadata must match it.
Missing, malformed or stale intent refuses before Cargo/fetch/compiler effects;
checks never silently fall back to the catalog's historical version. The retained
fixture records expected-package and reports its accepted registry identity.
Use `bash scripts/ci/test-published-identities-selection.sh` for the focused
selection rejection fixture (Cargo effects are substituted).


The [observability host example](examples/observability-host.rs) composes exact
published Metrics 0.24.5 and Logging 0.23.6. Logging is a development dependency
of this private consumer only. Its counters track log admission, truncation,
eviction and refusal; a host-selected metrics-window reset preserves the log's
identity. These are diagnostic events rather than authoritative application outcomes.

The existing acceptance command also lints, compiles and executes that example
on the Rust floor. The surrounding identity probe explicitly selects native-wire
for its schema tests; the example itself uses only arithmetic APIs. Root feature
checks separately prove arithmetic-only consumers can omit Wire. The source-copy
probe is unchanged and does not select Logging. The TypeScript CI job prepares
and executes both consumers against its explicitly recorded historical registry
intent. Advance that CI intent with the catalog/lock after deliberately selecting
a different published Metrics version.
