# Historical native Wire integration

Metrics no longer depends on Wire or Platform. Native metadata was removed in
0.28 and recorder Serde/report arithmetic in 0.29. Canic's adapter and endpoint
consumers own report DTOs, validation, schemas, bindings and integration stacks.
See the [0.28](../../releases/metrics/0.28.md) and
[0.29](../../releases/metrics/0.29.md) migration guides for the current boundary.

## Historical qualification

The retired identity probes distinguished canonical Principal/Account types from
lookalike application types and tracked their exact trait generations. The 0.23
line paired Wire 0.12.1 with canonical Types 0.1 and Platform facade 0.14;
subsequent lines moved to Wire 0.13/Types 0.15 and Wire 0.15/Types 0.17.
Those were historical pairings, not current dependency recommendations.

Some early qualification used a separately versioned source copy before registry
publication; later delivery receipts distinguish the published selection and
actual source. A temporary source alignment was never proof of published
availability. Owned endpoint consumers selected endpoint integration separately.

Old source/manifest copies, identity-probe Rust, generated qualification graphs
and run-specific schema reports are retired from this tree. They are not active
test fixtures. Protected release receipts preserve delivered package identities;
old tracked inputs remain in Git history at
`d8374e3ce80095a8f50bdb80e9d88ecc8f3b0003`. A compact summary does not preserve
schema/byte compatibility proof for a different current graph.

Arithmetic/recording-only consumers must not regain a Wire, Platform runtime or
endpoint dependency to reproduce these retired probes. New metadata/codec and
Principal/Account integration belongs at its actual DTO/endpoint owner, with
matching published dependencies and focused schema/byte/runtime qualification.
