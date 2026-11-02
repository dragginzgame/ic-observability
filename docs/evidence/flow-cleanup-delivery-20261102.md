# Verified flow-cleanup delivery — 2026-11-02

The authorized deployment delivers the
[five flow simplifications](flow-cleanup-20261102.md) as independent
**Metrics 0.27.1** and **Logging 0.24.2** releases, on GitHub and crates.io.
Both uploaded once and passed independent official archive/source verification.

## Git sources and complete release gates

Source commit: `05defcb8f6fd65bdda676268a70687bedfca59dc`. It contains only the
reviewed cleanup, fixtures, docs and pending notes, excluding the two pre-existing
root/Metrics README edits. Both standard `make release-patch RELEASE_GROUP=…`
commands completed their full selected validation, metadata/archive checks,
annotated tags and atomic main/tag pushes:

| Group | Release commit | Tag | Setup policy | Full CI | Compiler admission |
| --- | --- | --- | --- | --- | --- |
| Metrics | `1a0b89c3727b32da2b6cdcc363bcd5607eea535d` | `metrics-v0.27.1` | 1 s, pass | 147 s, pass | pass |
| Logging | `787f785e3e36eabab651b28d9a081851f8e32458` | `logging-v0.24.2` | pass | 140 s, pass | pass |

The separated TypeScript setup fixtures run explicitly before the unchanged
complete `ci msrv` gates; preflight admits prepared tools. Both releases retain
Rust 1.99.1. Each metadata transaction changes only its selected package version,
root catalog entry, lock entry and dated ledger. External dependencies remain
unchanged. Public APIs, schema/byte contracts, error precedence, independent
feature boundaries and Logging checkpoint/retention semantics are preserved.

The reviewed Shared snapshot remains 0.27.26 at exact committed revision
`fd9390ef797bfad8aaa05fdba8fcddec753b572c` (142 files). No tooling version or
snapshot adoption is part of this deployment. Local full-gate results do not
claim new hosted macOS execution; hosted runs remain asynchronous.

## Official publication and independent readback

Each package passed `publish-check`, then a fresh exact-version absence observation
(official HTTP 404, curl status 0) immediately before its one actual upload.
`publish-verified` ran from the clean checkout of the selected annotated tag.
Separate readback verified official non-yanked metadata, the downloaded archive
checksum, clean VCS provenance, fresh GitHub source retrieval and every maintained
package file.

| Package | Official archive SHA-256 | Maintained files |
| --- | --- | --- |
| `ic-metrics@0.27.1` | `1301c37815b711164dbef141437570f737abb63dd0f9531586067a4649411b86` | 39 |
| `ic-logging@0.24.2` | `c2c39b9656c998f08d2f5da3fc936ea394c809bc631b373d15df1e762ed0aad0` | 12 |

Readback directories inside the isolated checkout are
`target/publication/verification.WmhcnH` (Metrics) and
`target/publication/verification.8bD7J0` (Logging). Do not replay completed uploads;
`make verify-publication RELEASE_GROUP=…` performs readback only.

## Actual published-pair acceptance

The independent registry consumer now selects Metrics 0.27.1 and Logging 0.24.2,
with unchanged Wire/derive 0.15.0, canonical Types 0.17.0 and Platform 0.18.0.
Only the two changed package versions/checksums differ in its lock. Current
qualification guides, catalog and explicit CI Metrics intent advance together.

`make published-identities-check EXPECTED_METRICS_VERSION=0.27.1` passes strict
Clippy, all three real Principal/Account schema/byte/refusal tests, executable
Metrics/Logging composition and Wasm compilation on Rust 1.99.1. These are actual
registry library dependencies, with only the probe workspace-owned. Evidence is
`target/qualification/wire-published.nijuup/report/` inside the isolated checkout.
This proof is separate from source-copy alignment and from the implementation's
static Logging Wasm size experiment; no new IC runtime performance claim follows.

## Retained evidence and original work

Deployment checkout: `target/deploy/flow-cleanup-20261102/checkout/` beneath the
original workspace. The parent retains setup, release, publication, registry
observation, lock-update and acceptance logs. Release plans, journals, validation
receipts, package archives and readback inputs remain inside the checkout.
No artifact cleanup ran.

The original `README.md` and `crates/ic-metrics/README.md` edits remain intact
against the deployment parent's `preserved-readmes.sha256`, excluded from source,
release and receipt commits. No sibling checkout or historical receipt/tag was
changed. The post-publication catalog/CI/receipt follow-up needs no further
product release. The earlier [Wire 0.15 delivery](wire-0150-delivery-20261102.md)
retains its original identities and native trait migration evidence.
