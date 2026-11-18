# Observability code hygiene and Toko Tooling adoption — 2026-11-18

## Scope and result

**FAIL — two reproducible tooling boundary defects remain.** Toko Tooling 0.45.8
is installed and its directly affected local callers are adopted. Product checks
passed; neither finding establishes a Metrics/Logging runtime defect.

Requested scope: both libraries, package tests/examples, local CI/release scripts,
manifests, installed tooling callers and maintained documentation. Source baseline
is `57d4a789ca110b519d06947589ce0832510be33a`; the worktree
adds the 0.45.8 adoption and the mechanical changes described below. This is a
fresh inspection/native validation run, not a comparable score against an earlier
audit. Historical receipts, private evidence, frozen candidates and sibling
consumers were excluded from mutation and from new acceptance claims.

Method: [code hygiene](https://github.com/dragginzgame/toko-tooling/blob/626da7cd9626cc2e152594862a2d82ea82ef51da/audits/code-hygiene.md),
[common audit contract](https://github.com/dragginzgame/toko-tooling/blob/626da7cd9626cc2e152594862a2d82ea82ef51da/audits/README.md)
and its revision-bound Rust hygiene guide. The installed 0.45.8 baseline's newer
Rust-layout and Cargo network rules supersede older detailed wording.
The local AGENTS.md SHA-256 is
`809d30e02790c29bfbce66ea4f9af46bb95e67f2bc5b37e3eebeb140a0f2fb5d`.
The adopted crate checksum is
`adbc76769b2231de6704851c363550ddc486bb6204a0f89c2ad365eb7cf740a3`;
the authenticated exporter retains 55 roots / 111 files. No snapshot bytes or
receipt were hand-edited. The approved compiler is Rust 1.100.0 on Linux x86_64.

## Ownership and traces

- Metrics retains fixed aggregate/counter/summary/histogram observations, explicit
  restoration admission, local nonwrapping reset sequences and opt-in bounded
  keyed recording. Raw persisted fields enter through named fallible restoration
  functions; recorder fields remain private and report transport stays external.
  Count/total overflow is sticky; casts reviewed in production widen numeric
  values. Lexical retention validates its worst-case byte budget before mutation;
  first-admitted tables refuse before allocation and account omissions separately.
- Logging validates labels, time, sequence and text budget before eviction;
  restoration validates retained rows and watermarks before constructing authority.
  Cursor scans bound candidates and matches, and truncation respects UTF-8.
  Opaque history charges are a documented caller contract, not allocator usage.
  Long log/restoration code remains cohesive around these transitions; size alone
  does not justify splitting invariants or adding abstractions.
- Production panic/unwrap/expect and unsafe searches found no direct sites.
  Fixture/example assertions remain test contracts. Manual Display/Error pairs
  retain dependency-free no_std support; adding thiserror is inappropriate here.
  No tracked symlinks, path-based Rust module wiring or production transport
  dependencies were found. Tool-store pointers and retained generated output are
  distinct from maintained package inputs.
- Native subprocess observations use CheckProcess's byte limits, process-group
  custody and deadlines. Negative tests exercise cap, exit, timeout, interruption
  and child cleanup. Required source selection retains missing tracked paths;
  package scanning rejects missing/nonregular listed files, but its metadata
  roster admission has the independent gap below.
- CI retains immutable action pins, one secret scanner, three host jobs and the
  consumer-owned source/classification and diagnostic boundaries. Release groups
  remain explicit, ordered, independently versioned and admitted before effects.
  This review is not a full security, protocol, performance or deployment audit.

## Adoption changes

The pin/lock and authenticated export advance from 0.45.3 to 0.45.8 without other
dependency updates. Normal local Cargo checks and fresh release validation retain
`--locked` and stop forcing offline mode; caller-selected offline settings remain
effective. Deterministic offline fixtures keep their explicit selections. No
optional stage sealer, broad gate or new product dependency was added.

Moved the remaining late test-module declarations in Logging's log/export example
and Metrics' window; consolidated persistence imports with matching visibility.
Removed the unused workspace-wide too_many_lines allowance after native all-target
lint confirmed no need for it. Existing function spacing is compliant. The sole
Wasm-only panic handler in the allocator-free fixture is an individual target
distinction; shared recording remains visible natively, so no wrapper module is
needed. The catalog has only test/tooling entries and requires no empty role groups.

## Findings and ownership

1. **MEDIUM — incomplete package metadata can falsely pass document validation.**
   `scripts/ci/check-package-doc-links.pl` decodes metadata without requiring a
   nonempty, well-formed member inventory and complete member visitation. A
   synthetic Cargo executable returning `{}` produced exit zero and checked no
   package. Existing negative file cases do not cover this missing trust boundary.
   [Observability #138](https://github.com/dragginzgame/ic-observability/issues/138)
   owns schema/roster admission and missing/empty/duplicate/unmatched member tests.
   This is a behavioral checker repair, separate from adoption.
2. **MEDIUM — opaque URL fragments survive setup redaction.**
   `scripts/ci/setup-evidence.pl` retained
   `https://example.invalid/#opaque-canary-value` in console output and its saved
   diagnostic. Credential-bearing fragments could therefore enter CI failure
   artifacts. No credential was used or exposed by this probe.
   [Observability #139](https://github.com/dragginzgame/ic-observability/issues/139)
   owns repair and console/archive regression coverage. Prefer reviewing the
   supplier's existing diagnostic helper rather than another sanitizer copy.

The shared audit method does not automatically authorize unrelated behavioral
repairs. These issues are the follow-up owners; this report is immutable evidence,
not another task ledger. The requested supplier adoption corrections are applied.

## Validation and limits

Evidence root: `target/qualification/toko0458-hygiene-20261118/`.

- Authenticated preview/install and prepared-tool admission passed.
- `make fmt`; native all-target/all-feature and Wasm library Clippy for both
  selected packages passed with the repository's warning-denial configuration.
- Both packages' all-feature unit/integration/doctest selections passed, including
  62 Metrics library tests, 34 Logging library tests and 30 compile-fail doctests.
  The deliberately ignored long UTF-8 model was not selected. The changed export
  example executed five passing tests.
- Allocator-free Wasm linking and native/Wasm production graph checks passed.
- CheckProcess's 27 assertions, package-document source fixture's six assertions
  and dependency-declaration corruption/isolation fixture passed. They do not
  override the newly demonstrated metadata and redaction failures.
- Standard release Make dispatch passed with substituted command effects.
  Focused release-refusal qualification passed without product rebuild matrices,
  remote publication or deployment.
- Synthetic metadata/redaction probes reproduced both findings; their logs are
  `empty-metadata.log` and `redaction-probe.log`. Test data contains no credentials.
- Pin admission, repository/package documentation links and diff checks passed.
  An initial documentation run preceded report creation and rejected its missing
  link; the completed document set passed on the subsequent check.

No full CI/release matrix, native macOS execution, hosted pass, downstream runtime
qualification or registry publication is claimed. Existing package-local API
contracts are unchanged. The earlier local handoff commit remains unpushed after
its prior approval rejection; this request did not authorize retrying that push.
