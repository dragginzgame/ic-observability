# Observability rules and hygiene — Toko Tooling 0.46.5

**PASS for local adoption and the reviewed hygiene scope.**

The maintainer requested the adoption, review and deployment. The starting
commit was `517c7ad4803b721403a2cea62f8433f7d28fa292`. The working tree
included the pending Logging retained-byte fix and separate downstream roster
edits. The reviewed overlay SHA-256 was
`7b124c0dfa27d6200cbebbe7a3ee7b2cd11ef256e525b2e758a2ce306f0628fd`.
The [pinned code hygiene method](https://github.com/dragginzgame/toko-tooling/blob/626da7cd9626cc2e152594862a2d82ea82ef51da/audits/code-hygiene.md)
is unchanged from the previous pass. Review covered both libraries and the
local caller of the changed tooling.

- The exporter authenticated the
  [0.46.5 source revision](https://github.com/dragginzgame/toko-tooling/tree/db352d6e5ac7f9822a82e820621de16838874093)
  through the locked registry archive with SHA-256
  `038380e2f80a7301dee19c19e2afd38a0bfbbfc41b447a1c81178afc1de94bc7`.
  The baseline and Cargo inventory helper changed. The selection retains
  56 entrypoints and 112 files. The host and IC catalogs are unchanged.
- **LOW, resolved.** Inventory guidance now matches the root workspace
  default and explicit manifest option. Observability has one maintained
  workspace. A disposable, independent qualification workspace verified
  default omission, explicit selection and lockfile-free inventory through
  the local Make target.
- **LOW, resolved.** Grouped Logging's validation state immediately before
  the row scan and explained the refusal of impossible empty checkpoints.
  Append and restore share the row charge definition. Restore derives use
  from validated rows and the selected policy. The same eviction path updates
  the byte total during append and age retention. Legacy snapshots retain
  their count-and-text policy.
- Reviewed the Metrics restoration entrypoints and Logging append and restore
  for bounded inputs, typed refusals, and unchecked panic paths. The existing
  workspace lint allowances cover the shared type header and advisory function
  length. The tracked inventory has no symlink entries. Consumer adoption of
  the new Logging API remains with the consumer.

On Linux x86-64 with Rust 1.100.0, snapshot and tool admission, formatting,
strict native and Wasm Clippy and Rustdoc, and workspace tests passed. The
workspace lint audit found zero discrepancies across three manifests. The
test roster recorded 147 passes and one intentionally ignored extended test.
Focused checks and logs are under `target/deploy/toko-20261126/`.
