# Public evidence distribution and original custody

[#72 — Review private consumer source in existing evidence archives](https://github.com/dragginzgame/ic-observability/issues/72)
owns the historical source-export decision. The reviewed 0.9.0 checkout was
`fe4d14f2a24138794878a17a354885a1e7222487` plus incoming Shared Tooling 0.10
adoption. This record protects the distinction between public sanitized payloads,
original identities and separately retained private originals; it is not a new
source-export authorization or current issue-status observation.

## Current cleanup disposition

The authorized 2026-11-05 cleanup removed the obsolete public experiment bundles
and their checksums from the current tracked tree, under the
[evidence retention contract](README.md#retired-raw-evidence). It did not rewrite
published history, alter the identity ledger, modify private originals, export
private source or delete active deployment/recovery state. The pre-cleanup
committed public tree is `d8374e3ce80095a8f50bdb80e9d88ecc8f3b0003`.

The [identity ledger](archive-distribution-072.json) remains byte-identical. It
records historical original/replacement SHA-256 values, Git blobs, containing
tags and intentional omissions. Those identities are historical metadata;
removed raw payloads are not independently verifiable from the current tree.

## Historical distribution review

The original review inspected 36 top-level archives and ten nested archives.
Four receipts included private consumer source, one private checkout observations
and one consumer feedback. Read access was not export authority. Private source,
manifest/lock copies, search excerpts and issue bodies were omitted from public
replacements; the review did not assume filenames alone identified private data.

| Historical receipt stem | Omitted files | Projected files | Byte-identical files |
| --- | ---: | ---: | ---: |
| consumer-review-082 | 12 | 1 | 45 |
| counter-082 | 1 | 1 | 175 |
| error-cut-090 | 13 | 1 | 431 |
| memory-083 | 2 | 1 | 202 |
| release-080 | 1 | 1 | 31 |
| summary-restoration-081 | 3 | 2 | 196 |

The six public replacements retained 1,080 byte-identical original files, with seven
separately identified projections and six provenance records. Original source,
compiler, workload and failure identities retained their original scope. The
historical recursive readback inspected 5,013 regular payloads and checked names,
containment, duplicates and private-content exclusions. These are observations
of that original review, not fresh verification after retirement of the bundles.

## Private-original custody and published history

The original record retained six exact original archives and checksum manifests
under ignored `.private-evidence/archive-review-072/originals/`, with owner-only
permissions, outside target. It recorded matching hashes/readback and distinguished
local custody from an external backup. That directory and its underlying source
custody were outside this cleanup and remain subject to the source owner's review.
No private raw payload was copied into another tracked summary or hidden archive.

The historical public Git/tag record contained the original blobs: v0.8.1–v0.9.0
for summary restoration and release feedback; v0.8.2–v0.9.0 for consumer review and
scalar counter; v0.8.3–v0.9.0 for Memory checkout observations. Retirement from a
working tree does not remove existing clones, tagged downloads, caches or old Git
objects. Repository links and previously published references do not grant fresh
permission to redistribute private source. A history/remote removal decision
requires its own explicit authority and preservation of necessary private custody.

Future public summaries select own/public data explicitly. Keep private source,
search output, issue bodies and mixed private observations out of tracked evidence.
Inspect any separately authorized export's complete payload, not just filenames.
