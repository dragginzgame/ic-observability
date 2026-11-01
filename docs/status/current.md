# Current handoff — 2026-11-01

The maintainer now authorizes pushing/integrating the prepared follow-up and
completing Git releases plus crates.io publication. Deliver Metrics **0.24.4**
and Logging **0.23.5** separately through the standard direct group workflow.
Publish each clean exact tag before advancing the other group. No sibling edits,
artifact cleanup, tag deletion or history rewrite are needed.

The source batch adds maintained archive-content verification, registry-only
Principal/Account acceptance, early Make/Node/npm setup checks, generated
checkpoint corruption cases and opt-in long UTF-8 model histories. Follow-up
repairs preserve failed npm/Node observation status, require explicit expected
registry version, and record smoke success/failure/skipped outcomes in evidence.
Package APIs, schemas, bytes and production dependencies are unchanged. Shared
Tooling remains reviewed 0.27.23 at 619d194875369e0f72b45477b66adb430acbf6b7.

The preparation base is 44a64e2b5375f88820fa6e49706d0856c3edb705. Pending
ledgers are Metrics 0.24.4 and Logging 0.23.5; package versions remain 0.24.3 and
0.23.4 until standard release preparation. Use a scoped topic PR, respect actual
protections/reviews, then run fresh full local CI/MSRV through each release.
Hosted checks remain asynchronous; known failures must be repaired.

Focused evidence is retained under target/improvements/delivery-confidence-20261101/
and target/improvements/qualification-guards-20261101/. Selected Logging Clippy,
Rust 1.91 corruption admission, ordinary and extended seeded histories pass.
Source and registry-only identity probes pass strict Clippy, three real tests on
Rust 1.91 and Wasm compilation. Actual Make routing passes on current Make and
locally prepared GNU Make 3.81; that is Linux parser evidence, not new macOS
execution. Node/npm observation and setup failure fixtures pass. Registry intent
refuses missing/malformed/stale requests before Cargo. Native evidence fixtures
cover smoke outcomes and retained logs; Actionlint, ShellCheck, docs, pins,
snapshot, group admission and standard publication fixtures pass.

The private registry catalog/lock currently selects published Metrics **0.24.3**.
After the new publication, deliberately advance that fixture to **0.24.4**, review
its lock diff, prepare it and run published-identities-check with explicit
EXPECTED_METRICS_VERSION=0.24.4. Retain Wire 0.13.2, Types 0.15.1/facade 0.15.2
and unrelated qualified suppliers. Keep all integration dependencies outside the
arithmetic workspace. Finalize that source/qualification receipt through a scoped
contribution; do not replay an upload for any readback/probe failure.

Deployment logs/journals will be retained under
target/deploy/delivery-confidence-20261101/ and .git/release-state/. New standard
preflight requires prepared Node/npm for both groups; ordinary Rust/native CI
remains Node-free. Do not bypass the full release gates.

The [previous delivery](../evidence/verification-wire-0132-delivery.md) records
published Metrics 0.24.3 and Logging 0.23.4. Metrics 0.24.2 remains Git-only and
was never uploaded. PRs #108–#110 are merged, #107 is completed and superseded
[#105](https://github.com/dragginzgame/ic-observability/pull/105) is closed.
The original npm false-pass reproduction stays under
target/audits/delivery-review.cd8D65/. All prior evidence and release journals
remain intact. Canic #712/#100 retain separate ownership.
