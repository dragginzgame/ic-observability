# Observability rules and hygiene — Toko Tooling 0.46.4

**PASS for the local adoption and reviewed hygiene scope.**

The maintainer requested a tooling refresh and rules and code hygiene passes.
The review covered both packages, their tests and examples, the local overlay,
and the callers of the changed release tooling. It started at
`4d23d184dd43b7fda5210f6d9f620c18da13ba58` with existing downstream roster
edits in `AGENTS.md` and `docs/architecture/extraction.md`. The reviewed
overlay has SHA-256
`7b124c0dfa27d6200cbebbe7a3ee7b2cd11ef256e525b2e758a2ce306f0628fd`.
The [code hygiene method](https://github.com/dragginzgame/toko-tooling/blob/626da7cd9626cc2e152594862a2d82ea82ef51da/audits/code-hygiene.md)
is unchanged from the previous pass. The
[0.46.4 source revision](https://github.com/dragginzgame/toko-tooling/tree/43258b7051cb6b1439e72aa63f35d12cc0d386e2)
extends the Rust constant placement and comment guidance.

- The exporter installed 56 entrypoints and 112 files from the locked registry
  archive, SHA-256
  `d3889bff0f8ff6dc8c80b161c908f4b598125b55bf55f18146471f9ac3294cff`.
  The installed baseline and two release helpers changed. The dependency
  update selected only Toko Tooling. Existing host, IC and Rust tool selections
  passed admission.
- **LOW, resolved by the workspace owner.** The overlay now places the handoff
  alongside the baseline and retains the task-specific extraction requirement.
  Product authority and validation remain consumer-owned. The pending ledgers
  document the tooling changes using the compact layout.
- **LOW, resolved by the package owners.** Grouped Metrics' const recorder
  fixtures before the module-wide test type. Moved Logging's truncation suffix
  to the truncation helpers and trimmed the pagination comment. The Rust changes
  are mechanical. The two workspace Clippy allowances cover the shared type
  header format and the advisory function-length lint.
- Metrics' persistence constructors retain typed admission failures and private
  arithmetic. Logging validates checkpoint and append inputs before constructing
  or mutating retained state. Negative tests exercise these boundaries, including
  invalid histogram distributions and rejected log appends. The product source
  inspection found no direct panic calls, unchecked unwraps, or unsafe code.
  Fixture panics assert test invariants. Both production graphs remain
  dependency-free. The tracked file inventory has no symlink entries.
- Observability selects independently versioned groups and its publication path
  still requires explicit group selection. The coordinated workspace changes
  also serve repositories using inherited versions. The publication adapter's
  evidence directory resolution remains within the existing local caller path.

On Linux x86-64 with Rust 1.100.0, `make fmt`, `make fmt-check`,
`make toko-tooling-check tools-check check-pins`, `make check-doc-links
package-doc-links-check`, `make clippy docs-check`, `make test`, and
`make production-dependencies-check` passed. Tests recorded 143 passes and
one ignored case. `make package-check` passed with registry access and
both local archives verified against the canonical root file.
The upstream workspace lint audit found zero discrepancies across three
manifests.
Release adapter, admission refusal, retained-consumer and publication-policy
fixtures passed. The release-batch fixture also passed on retry with access to
the shared tool cache after the initial sandbox run could not acquire its
installation lock. The fixture exercised both groups, including deferred
checkout reconciliation and recovery after an uncertain upload, using a
disposable Git remote and simulated registry.
Evidence is under `target/toko0464/`. Validation was local and focused.
