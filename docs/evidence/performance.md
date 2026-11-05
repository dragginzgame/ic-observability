# Historical measurement conclusions

The old reader, arithmetic, histogram, quantile, stable-store and Wasm-inspector
experiments measured different source/dependency/workload combinations. Their raw
bundles are retired from the current tree under the
[retention policy](README.md#retired-raw-evidence). No instruction/cycle saving,
current binary size or performance recommendation is asserted from those reports.

## Selected historical absolute results

The former bounded inspector reported these structures for three frozen histogram
replay Wasms using released Metrics arithmetic 0.2.8. These are selected reported
results, not newly executed or independently reproducible current-tree evidence:

| Frozen variant | Complete raw Wasm bytes | Encoded code-section bytes | Encoded code-body bytes |
| --- | ---: | ---: | ---: |
| Count | 358,328 | 311,893 | 311,891 |
| Summary | 358,440 | 312,005 | 312,003 |
| Histogram | 358,611 | 312,175 | 312,173 |

The count module's historical SHA-256 was
`311d57ca56adc336643d109ea2847cc51fd8604a60950cc68d12e2fcfff68419`;
summary `ee81d342687b78e96ea90164f373bac92162204ff54940a7d4b153c96247bec4`;
histogram `e2c9c303d369db8e23b0afeff46cc1e882a48fad48c0daf0e41aa75b82bf99e5`.
The histogram replay archive was recorded as
`bede3e2f63cbcf95b482323dc0135034220de0b7166fc48ad6f8ae8548bd4cfb`.
Hashes identify those historical inputs; they do not preserve their bytes here.

The inspector was based on `4ad5837` plus then-working changes, using published
Host Artifacts/FS 0.8.1. The source-hash list and raw modules are no longer retained
in this tree, so this abbreviated base is not a reproducible inspector identity.
Its historical command was `ic-metrics-wasm-inspect count.wasm 1000000 1000 10000
1000`; that package and qualification target are retired. Historical details can
be read at pre-cleanup commit `d8374e3ce80095a8f50bdb80e9d88ecc8f3b0003`.

## Maintained interpretation

Complete fixture sizes are not Metrics' marginal contribution to an application.
Encoded Wasm bodies are not IC instruction counts; structural inspection does not
prove validation, installation, attribution or cycle charges. Native substitutes
and timing do not establish IC measurements. New size studies report complete
uncompressed modules and code-section sizes with actual source/tool identities.
Real IC instructions, actual IC cycles and raw Wasm bytes remain distinct units.

For new studies, use the owning published inspector/build interfaces and admitted
workloads; retain raw output under `target/evidence/`, then update this topic only
with useful compact results and their limits. A reproducibility claim requiring
durable raw payload needs an explicit scoped retention exception first.
