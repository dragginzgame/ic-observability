# Verified Metrics 0.28.0 delivery — 2026-11-03

**ic-metrics 0.28.0 is released on GitHub and published on crates.io.**
[#128 — Remove Metrics' Wire metadata dependency](https://github.com/dragginzgame/ic-observability/issues/128)
was closed as completed at `2026-11-03T10:18:20Z`, after publication and
independent archive verification. Consumer migrations retain their own owners.
Logging remains 0.24.3; its implementation, manifest and ledger are unchanged.

## Source and complete release gate

The [implementation](metrics-wire-separation-20261103.md) is delivered from source
commit `1b47cab2fc4b6dcebe0686308b54fa01249a95e1`. The standard
`make release-minor RELEASE_GROUP=metrics` completed full `ci msrv` validation
(CI 136 seconds; compiler admission passed), metadata/archive checks, the release
commit `54a92f45c1008a56599ee42786d84553ca950215`, annotated tag
`metrics-v0.28.0` and atomic main/tag push. Only Metrics' selected version,
catalog alias, lock entry and dated ledger advance in that transaction.

Metrics now owns arithmetic and validated Serde without Wire/Platform dependencies.
There is no default feature or `native-wire` feature/trait implementation.
Services own report DTOs, schema generation, codecs and generated clients.
The [0.28 migration](../../releases/metrics/0.28.md) documents the breaking removal,
preserved numeric representations/admission and coordinated consumer actions.
No storage reset, compatibility shim, integration crate or sibling edit was added.

The 142-file Shared Tooling snapshot remains 0.27.26 at
`fd9390ef797bfad8aaa05fdba8fcddec753b572c`. Local release gates do not claim new
hosted/macOS or application runtime acceptance; hosted runs remain asynchronous.

## Publication and actual registry acceptance

`publish-check` passed. A fresh official exact-version observation returned
HTTP 404 with curl status 0 immediately before the single upload.
`publish-verified` ran from the exact clean release tag. Independent readback
verified non-yanked registry metadata, the downloaded archive checksum, clean
VCS provenance, fresh GitHub source retrieval and all **32 maintained files**.

Official archive SHA-256:
`de2cd8cb8da32cd175e8b63f3c883e52b041749aa2df3ae6d5936434674eb19e`.

A fresh consumer selects actual registry `ic-metrics = "=0.28.0"`, with only
the consumer workspace-owned. Strict Clippy passes; default execution passes
one numeric Serde/admission test, and recording execution passes both that test
and bounded zero-sample retention. All-feature Wasm compilation passes on Rust
1.99.1. Shared normal/build graph checks pass for native default and all-feature
Wasm, requiring Metrics/Serde and excluding Wire/Platform families. This registry
proof is separate from the implementation's temporary old/new schema-byte
comparison and from service-owned endpoint/browser/runtime acceptance.

## Retained evidence and follow-up

Deployment checkout: `target/deploy/metrics-0280-20261103/checkout/` beneath the
original workspace. Its parent retains source patches, the reviewed path list,
setup/release/publication logs, registry observation and consumer logs/metadata.
Plans and validation receipts remain in the checkout's `.git/release-state/`.
Readback is `target/publication/verification.Rk6wQt/`; the exact registry consumer
is `target/publication/metrics-0280-consumer/` inside that checkout.

Original pre-existing README/lock inputs remain backed up under `target/issue-128/`
in the original workspace. Their guidance was reconciled with the approved cut;
the pending Wire lock refresh is superseded by removal. Source/package versions
were advanced only by the standard release transaction. No artifact cleanup ran.
The delivery receipt and handoff follow-up requires no further product release.
Consumer DTO/qualification issues remain independently actionable; closing the
supplier issue does not claim their adoption or runtime acceptance.
