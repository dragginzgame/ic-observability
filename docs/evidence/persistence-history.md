# Persistence qualification history

IC Storage/Persistence owns governed backing, checked allocation, durable codecs
and stable adapters. This workspace owns fixed recording and passive heap
checkpoint/admission behavior; it has no stable-memory dependency.

Historical stable snapshots, durable counters, histogram replay and Memory 0.49
comparisons explored upgrade continuity, bounds, overflow quality and storage
operations. Their source/dependency/workload identities were version-specific.
The raw bundles and detailed measurement diaries are retired from the current
tree; their former cost, instruction and byte observations do not qualify a
current storage graph. The [retention notice](README.md#retired-raw-evidence)
explains the distinction between historical records and available raw evidence.

## Retained decisions

- Restoration admits numeric consistency only. Provenance, unit/configuration
  identity, lifecycle, backing allocation and restart continuity stay with hosts
  and the governed adapter owner.
- An exact cap and actual loss are different states. Retained formats must carry
  the quality that a clipped value cannot reconstruct. Decode bounds must be
  enforced before allocation or publication into runtime authority.
- Metrics 0.29 uses explicit `persistence::restore_*` entrypoints; recorder types
  are not arbitrary-report decoders. Storage qualifies its actual retained bytes,
  corruption refusal, ordering and continuity against its selected release.
- Logging checkpoints preserve append sequence/time watermarks after complete
  retention. Hosts select durable identity, allocator, cadence and lifecycle.
- Old one-map/raw-memory tests and native substitutes do not establish governed
  production allocation or installed-canister acceptance.

The [extraction contract](../extraction.md) and [logging boundary](../logging.md)
retain current ownership. No stable format, backing, library API or sibling was
changed by this documentation cleanup. Required durable compatibility evidence
stays with the adapter that owns the codec, not a historical experimental archive.
