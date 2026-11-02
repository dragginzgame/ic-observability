# Verified fixture-cleanup delivery — 2026-11-02

The authorized deployment delivers the [fixture/export simplifications](fixture-export-cleanup-20261102.md)
and [follow-up fixture cleanup](fixture-scope-cleanup-20261102.md) as independent
**Metrics 0.27.2** and **Logging 0.24.3** releases on GitHub and crates.io.
Both uploaded once and passed independent official archive/source verification.

## Git sources and complete release gates

Source commit: `1a58577f2f34d38323acb99d34a09f10ef692980`. It contains only the
reviewed changes, fixtures, docs and pending notes, excluding the pre-existing
root/Metrics README edits. Both standard `make release-patch RELEASE_GROUP=…`
commands completed full validation, metadata/archive checks, annotated tags and
atomic main/tag pushes:

| Group | Release commit | Tag | Full CI | Setup policy / compiler admission |
| --- | --- | --- | --- | --- |
| Metrics | `305f2dc545b147e73747cb7be83913ea6a41d794` | `metrics-v0.27.2` | 151 s, pass | pass / pass |
| Logging | `680d2acedcae3f8ad5b1102d4888b22b3374a352` | `logging-v0.24.3` | 131 s, pass | pass / pass |

Each selected transaction changes only its package version, root catalog alias,
lock entry and dated ledger. External dependencies remain unchanged. Rust 1.99.1,
API/schema/byte contracts, typed errors, feature isolation and independent
restoration/retention checks are preserved. The Shared Tooling snapshot remains
0.27.26 at `fd9390ef797bfad8aaa05fdba8fcddec753b572c` (142 files).
Hosted runs remain asynchronous; these local gates claim no new macOS execution.

## Official publication and independent readback

Each package passed `publish-check`, then a fresh exact-version absence observation
(official HTTP 404, curl status 0) immediately before its single upload.
`publish-verified` ran from the clean checkout of the selected annotated tag.
Readback verified non-yanked official metadata, downloaded archive checksum,
clean VCS provenance, fresh GitHub source retrieval and every maintained file.

| Package | Official archive SHA-256 | Maintained files |
| --- | --- | --- |
| `ic-metrics@0.27.2` | `8482465cfed77a0abb17c9b527ae6b1595b44570eebdd97f25368bc2b4208785` | 39 |
| `ic-logging@0.24.3` | `2987abc85007425acc12528f8ad9d72cde96b6dfa33e8ac77d7339848aeb4863` | 12 |

Readback directories inside the isolated checkout are
`target/publication/verification.xE8A3f` (Metrics) and
`target/publication/verification.rs5ojI` (Logging). Do not replay uploads;
`make verify-publication RELEASE_GROUP=…` performs readback only.

## Published-pair acceptance and retained evidence

The frozen registry consumer and explicit CI intent now select Metrics 0.27.2
and Logging 0.24.3, with unchanged Wire/derive 0.15.0, canonical Types 0.17.0 and
Platform 0.18.0. Only those two versions/checksums change in its independent lock.
Strict Clippy, all three Principal/Account schema/byte/refusal tests, executable
composition and Wasm compilation pass on Rust 1.99.1. Explicit-version refusal
fixtures pass. Actual registry proof is separate from source-copy alignment.

Deployment checkout: `target/deploy/fixture-cleanup-20261102/checkout/` beneath
the original workspace. Its parent retains setup, release, publication,
registry-observation, lock-update and acceptance logs. Release plans/journals
remain in its `.git/release-state/`; actual-registry acceptance inputs are in
`target/qualification/wire-published.KJzEoF/report/` inside the checkout.
Original README edits remain intact against the parent's preservation hashes,
excluded from all delivery commits. No sibling mutation or artifact cleanup ran.
The catalog/CI/documentation follow-up needs no further product release.
