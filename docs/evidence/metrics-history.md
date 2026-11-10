# Recorder design history

Current behavior is defined by [the extraction contract](../architecture/extraction.md),
[the API inventory](../architecture/metrics-api.md) and the two package guides, not by old
experiment notes. This summary retains the useful decisions from the superseded
arithmetic, histogram, restoration and lookup investigations.

## Retired contracts

| Historical direction | Current disposition |
| --- | --- |
| Platform instruction readers and dedicated reader canisters | Removed from this library; applications own real platform reads and attribution |
| Generic ratios, rounding, means, interval/delta and distribution queries | Removed in Metrics 0.29; report adapters own report arithmetic and validation |
| Native Wire metadata and recorder transport traits | Native metadata removed in 0.28; recorder Serde removed in 0.29 |
| Internal reconstruction as a public numeric toolbox | Private validators feed only the explicit governed persistence admission contract |
| Package-local host Wasm inspector | Tooling owns its separate published CLI; it is not a Metrics dependency |

The earlier 0.7 wide-total and 0.8 overflow investigations motivated the retained
recording rules: input observations are u64; wide totals and actual-overflow flags
are distinct; exactly reaching a cap stays exact; zero differs from no samples.
Maxima/latest values retain their own meaning. Deliberate batch merging is not
deduplication, and reset sequences establish neither durable nor global identity.
Histogram bounds and attribution remain caller-selected; restoration validates
numeric consistency without inventing provenance, units or sample history.

Fixed recording remains allocation-free and no_std. Heap retention uses alloc
only behind `recording`, with explicit key/count/text limits and omitted-observation
accounting. Logging retains its separate bounded heap engine and passive checkpoints.
These are maintained product contracts, not claims of measured speed or IC savings.

## Historical qualification

The old arithmetic/lookup/restoration run reports and raw bundles are retired
under the [evidence cleanup](README.md#retired-raw-evidence). Their released-source
identities remain in protected receipts and Git history. A removed transcript or
hash cannot qualify today's implementation; current named tests and the owning
consumer's installed/runtime evidence establish the appropriate new boundary.
No test vector was manufactured from historical bulk output to preserve it in Git.
