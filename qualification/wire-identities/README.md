# Metrics identity compatibility qualification

This fixture composes the current Metrics source with the published Wire core,
canonical Platform Types and Platform's principal facade. Three tests exercise
real Principal/Account schema composition, exact bytes (including absent versus
explicit-zero subaccounts), round trips and typed malformed/limit refusals.

Run `bash scripts/ci/check-wire-identities.sh --prepare` to fetch the independently
locked sources, then `make wire-identities-check`. Validation uses the root Rust
floor on native and Wasm, preceded by strict Clippy on the prepared development
compiler, with no implicit installation or dependency updates.
The lock selects Wire/Derive 0.14.0 and the integration catalog selects the
matching Types 0.16.0/facade 0.17.0 pair. The root Wire requirement is 0.14.0.
The independently catalogued published consumer retains its released Metrics
0.24.6/Wire 0.13.5/Types 0.15.1/facade 0.15.2 graph until a new Metrics release
is deliberately selected there.

The script projects the root catalog and a verbatim Metrics source copy into a
fresh workspace under target/qualification. Both local packages are members of
that workspace, and the copied Metrics package is always version 0.0.0. This is
source-alignment evidence, never publication or a registry-only consumer check.
The copied source is not a second maintained implementation. The fixture's own
Cargo.lock and integration catalog are its dependency owners; Platform cannot
unify features with the arithmetic workspace or enter its production graph.
Cargo.toml.in is a manifest template for that generated workspace, not an
additional member of the production workspace.

When deliberately updating Wire or the integration pairing, use
`bash scripts/ci/check-wire-identities.sh --update-lockfile`, review the isolated
lock diff, then prepare and run the check again. That explicit operation updates
only this fixture lock. Ordinary checks use --locked --offline and refuse stale
inputs. All generated sources, metadata and compiler outputs remain beneath
this repository's target/; no sibling source or path dependency is selected.

The separate [published consumer](../wire-published/README.md) reuses these
assertions with an exact registry Metrics dependency and its own lock. Use that
post-publication proof when registry acceptance, rather than source alignment,
is required.
