# Wire alignment and model extensions — 2026-11-01

Source base: `c96a9b30c7af39c6dd31a1a884937d87ace7b110`, with an incoming root
lock update selecting Wire/Derive 0.13.5. That incoming file stays byte-identical.
The accepted batch retains published-consumer CI inputs, qualifies that Wire
patch and extends the existing independent Logging/histogram models. The earlier
recommendation overlooked those existing models; this work reuses their owners
rather than adding parallel implementations.

Only Wire/Derive version/checksum records change in either qualification lock.
All other package records, feature-specific dependency edges, root requirements
and own versions remain unchanged. Metrics remains 0.24.5, Logging 0.23.6,
Wire's declared minimum 0.13.2, canonical Types 0.15.1 and facade 0.15.2.
No library implementation, API, arithmetic, schema or retained format changes.
There is no consumer migration or publication prerequisite for using this patch
with already-published Metrics; Logging has no Wire dependency.

## Published dependencies and generated outputs

Official registry metadata reports both 0.13.5 suppliers as non-yanked. Their
downloaded archives match these SHA-256 checksums:

| Package | SHA-256 |
| --- | --- |
| ic-wire | `a84839b136cdb92833e274cbe4083b38f3f94e2e04ae1da091d1e2c9ba219a1c` |
| ic-wire-derive | `1d43292c7b14a8d66afce95e117451795fa83c950fb07adeb324f97d93f8c2e3` |

Archive VCS records identify `a8195d42683f90810a9afd615e4f27e3e5a3c744`.
This is registry/archive evidence, not a fresh Git source readback or installed
IC performance experiment. Upstream's [patch notes](https://github.com/dragginzgame/ic-wire/blob/a8195d42683f90810a9afd615e4f27e3e5a3c744/releases/core/CHANGELOG.md)
describe admission/output-writer changes with unchanged codec contracts. No
upstream performance result is attributed to Metrics here.

Strict native-wire Metrics library/test Clippy and eight native Wire tests pass;
the tests run on Rust 1.91. The separately selected browser test passes using
Node 24.21.0 and locked TypeScript 7.0.2, covering all five Rust/TypeScript report
cases and typed malformed/limit refusals.

An isolated workspace copied from committed HEAD executes the same browser test
with the former 0.13.3 lock. Its generated reports, runtime, Rust vectors,
TypeScript vectors, typed consumer and tsconfig are byte-identical to the 0.13.5
execution. The first baseline attempt lacked TypeScript's platform compiler
package; that failure and its outputs remain retained. After copying the already
prepared compiler supplier, the complete baseline test and comparisons pass.
No baseline source or dependency patch was needed.

Both independent identity probes pass strict Clippy, three real Principal/Account
schema/byte/refusal tests on Rust 1.91 and Wasm compilation with Wire 0.13.5:

- The source-alignment probe copies this Metrics source as workspace-owned 0.0.0.
  It is not registry Metrics acceptance.
- `make published-identities-check EXPECTED_METRICS_VERSION=0.24.5` uses actual
  registry Metrics 0.24.5 and Logging 0.23.6, without copied library sources. Its
  application-owned composition also executes on Rust 1.91. No new upload ran.

All four resolved production profiles pass: minimal, recording, native default
and all-feature Wasm. Minimal/recording-only arithmetic omit Wire, and Wasm omits
it even with all features. Platform runtime/Types and endpoints remain outside
the production Metrics closure; Logging remains dependency-free. Four minimal
Serde tests and the allocation-free Wasm arithmetic link pass on the selected
development compiler and Rust 1.91 respectively.

## Independent model coverage and CI evidence

Logging's existing event journal now independently checks `visit_page` delivery,
matched/scanned counts and continuation at early visitor stops, across the same
mixed append/refusal/prune/copy-restore/move-restore histories. Generated entries
and cursor histories distinguish absent, present-empty and ordinary topics.
Both maintained short-history tests pass on Rust 1.91, preceded by strict
Logging Clippy. The explicitly ignored long exploration remains unrun.

Histogram restoration now checks every strictly increasing subset of values
0 through 3: all 16 bound sets, including zero through four finite bounds.
The existing independent raw-sequence oracle enumerates reachable and impossible
count/total/maximum combinations for each set. Closed-u64-maximum boundaries
and exact weighted overflow histories remain selected. All seven restoration
tests pass on Rust 1.91 with defaults disabled. The first lint attempt caught
a missing const-array annotation; it was corrected before passing lint/tests.

The TypeScript workflow now retains each published fixture's manifest, lock,
expected Metrics identity, metadata and probe source tree with the acceptance
log, including on failures. Expanding the actual workflow path patterns against
the completed published fixture finds all five input families. Actionlint and
the existing CI selection fixture pass; no hosted upload or fresh macOS execution
is claimed by this local check.

Commands, original failures, official metadata/archives, isolated baseline,
comparison hashes, lock-record comparisons, artifact path expansion and check
logs remain under target/improvements/qualification-models-20261101/. Prepared
identity fixtures and compiler outputs remain under target/qualification/.
The [previous delivery receipt](consumer-recipes-delivery-20261101.md) retains
its original release and hosted-check observations. No sibling edits, commits,
tags, publication, broad local CI/MSRV gate or cleanup ran in this batch.
