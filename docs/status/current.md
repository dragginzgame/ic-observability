# Current handoff — 2026-11-01

The maintainer authorizes integration, standard patch releases, crates.io
publication and closure of resolved owning issues. No sibling edits or artifact
cleanup are needed. Use explicit release groups and publish each clean tag
checkout before advancing the other group.

PRs [#108](https://github.com/dragginzgame/ic-observability/pull/108) and
[#109](https://github.com/dragginzgame/ic-observability/pull/109) are merged.
[#107](https://github.com/dragginzgame/ic-observability/issues/107) is closed.
The accepted batch supplies conservative prose-only CI, publication source and
registry verification, independently locked Principal/Account qualification,
TypeScript static checking and package installation documentation. Shared
Tooling remains reviewed 0.27.23 at 619d194875369e0f72b45477b66adb430acbf6b7.

Published Wire/Derive 0.13.2 is aligned in the root requirement, root lock and
isolated qualification lock. Types 0.15.1 and facade 0.15.2 remain private probe
suppliers. No production API, schema, byte, arithmetic or heap-engine code changed.
See [Wire qualification](../evidence/wire-0132.md) for exact supplier identities.

Metrics 0.24.2 completed full local CI/MSRV and its standard Git release. It is
**tagged but not uploaded**. Hosted PR #109 checks exposed two setup defects:
macOS Make rejects combined target-specific override/export syntax, and Node's
bundled npm differs from the pinned npm 12.2.0. The repair splits the Make
assignments and installs npm from the existing packageManager selection before
npm ci. Preserve the 0.24.2 tag; publish Metrics **0.24.3**, then Logging
**0.23.4**, after integration and fresh standard release gates. Do not rewrite
release history or claim the skipped registry version was published.

Delivery logs, including the first failed evidence assertion and successful
second release attempt, are retained under
target/deploy/verification-wire-0131-20261101/. The native/MSRV artifact fixtures
were repaired in #109 and pass actual IO/status scenarios. Earlier focused
metadata, TypeScript, real identity, Wasm, graph, publication and formatting
checks remain recorded in that directory and the Wire receipts. Hosted checks
are asynchronous and distinct from local gates; known failures require repair.

After upload, run publication readback without repeating an uncertain upload.
Record exact published versions, commits, checksums and remaining hosted status;
update this handoff and the owning issue with delivery evidence. Previous release
history remains in the [prior receipt](../evidence/shared-tooling-02722-delivery.md).
Canic #712/#100 and downstream adoption retain separate ownership.
