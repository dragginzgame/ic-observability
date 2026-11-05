# Verified cleanup patch delivery — 2026-11-02

> Historical release receipt. See [evidence retention](../README.md#retired-raw-evidence)
> for current artifact availability; the original identities and observations below are not fresh qualification.

The maintainer's patch deployment request delivers the
[ten complexity reductions](../tooling.md) and reviewed
[Shared Tooling adoption](../tooling.md) as independent
**Metrics 0.26.1** and **Logging 0.24.1** releases. Each package was uploaded once
and independently verified against its exact release source.

## Source and complete release gates

Source commit `f73d1a7a071ccaf30f3ca5c21a12a312733dc6d5` contains the scoped
cleanup and snapshot adoption, excluding the two pre-existing README edits.
The reviewed Shared snapshot is 0.27.26 at
`fd9390ef797bfad8aaa05fdba8fcddec753b572c` (142 files). Its producer ledger
marks that version Unreleased; this records exact committed source, not a
tagged upstream release.

Both standard `make release-patch RELEASE_GROUP=…` commands completed full
`ci msrv` validation, selected metadata preparation, archive checks, annotated
tags and atomic main/tag pushes:

| Group | Release commit | Tag | Full CI | Compiler admission |
| --- | --- | --- | --- | --- |
| Metrics | `2db8029905a86aa56bd1934fc819f491a0322deb` | `metrics-v0.26.1` | 147 s, pass | 1 s, pass |
| Logging | `35119d82918325fe041b3b62024dad8af9f1abca` | `logging-v0.24.1` | 133 s, pass | pass |

Each transaction changed only its group's package version, root catalog entry,
lock entry and dated changelog. Both retain Rust 1.99.1. Public APIs, arithmetic,
typed refusals, schemas, encoded bytes and independent feature boundaries are
unchanged. Arithmetic-only Metrics excludes Wire and Platform; Logging remains
dependency-free. The full local gates include native/Wasm qualification,
TypeScript runtime round trips, source identity composition, dependency profiles,
allocation-free linking, packaging and release/recovery fixtures. These local
results make no claim of newly completed hosted macOS execution.

## Publication and official readback

Each package passed `publish-check`, then a fresh official absence observation
(HTTP 404, curl status 0) before its one actual upload. `publish-verified` ran
from a clean checkout at the selected annotated tag. Its independent readback
checked official non-yanked metadata, the downloaded archive's checksum, clean
VCS provenance, fresh retrieval of the declared GitHub source commit and every
maintained package file.

| Package | Official archive SHA-256 | Maintained files |
| --- | --- | --- |
| `ic-metrics@0.26.1` | `388d6a3f76fbb6ac07795b4d2211a9a846ba3aa4b94d51be81018ecb3298cda5` | 39 |
| `ic-logging@0.24.1` | `b57f8628fc49c3dc70b644a6566ea5d02cdee57bdc5f3382c501c8799e485a4d` | 12 |

The isolated checkout retains readback directories
`target/publication/verification.1sgwel` (Metrics) and
`target/publication/verification.wV3Yww` (Logging). Do not repeat these uploads;
`make verify-publication RELEASE_GROUP=…` is verification-only recovery.

## Actual published-pair acceptance

The frozen independent consumer and CI intent now select Metrics 0.26.1 and
Logging 0.24.1. Only those two versions and checksums changed in its lock;
Wire/Derive 0.14.2, Types 0.16.0 and Platform 0.17.0 remain unchanged.
`make published-identities-check EXPECTED_METRICS_VERSION=0.26.1` passes strict
Clippy, all three real Principal/Account schema/byte/refusal tests, executable
Metrics/Logging composition and Wasm compilation on Rust 1.99.1. Both libraries
are actual registry dependencies, with no source replacement. This is separate
from source-copy qualification. Curated inputs and observations are retained in
`target/qualification/wire-published.iHEhAr/report/` inside the isolated checkout.

## Evidence and preserved work

Deployment ran in
`target/deploy/cleanup-patch-20261102/checkout/` beneath the original workspace.
Its parent retains setup, release, publication and published-pair logs plus
the pre-upload registry observations. Plans, journals, validation receipts,
archives and readbacks remain inside the checkout. No artifact cleanup ran.

The original `README.md` and `crates/ic-metrics/README.md` edits were excluded
from commits and retained byte-for-byte against
`target/deploy/cleanup-patch-20261102/preserved-readmes.sha256`. No sibling
checkout, external dependency selection or historical release was changed.
The catalog/CI/receipt follow-up requires no additional package release.
