# Evidence and retention

Keep current decisions and compact results here, following the
[shared retention contract](https://github.com/dragginzgame/toko-tooling/blob/12459b6029115b830b8477879d3bea2f030b6e63/rules/engineering-details.md#changelogs-and-artifact-preservation).
Routine checks use changelogs, issues and CI results rather than another report.
Raw experimental output belongs under ignored `target/evidence/` and may be
removed by explicit workspace cleanup.

| Topic | Current summary |
| --- | --- |
| Contributor tooling and this cleanup | [Tooling](tooling.md) |
| Recorder design and retired arithmetic APIs | [Metrics history](metrics-history.md) |
| Historical structural/cost experiments | [Performance](performance.md) |
| Governed persistence boundary | [Persistence history](persistence-history.md) |
| Removed native Wire integration | [Wire history](wire-history.md) |
| Consumer qualification ownership | [Consumer history](consumer-history.md) |
| Exact release/publication identities | [Protected release receipts](releases/README.md) |
| Distribution and private-original custody | [Distribution record](archive-distribution-072.md) |

Experimental topics default to one current summary, at most two small supporting
text/data files and 100 KiB combined; all experimental topics together stay under
5 MiB. Summaries normally stay within 150 lines. These are ceilings, not targets.
Small release receipts and the existing distribution-custody record have separate
retention duties; they are not a reason to retain bulk experimental attachments.

## Retired raw evidence

The authorized 2026-11-05 cleanup retired superseded compressed bundles, their
standalone checksums, old source/manifest snapshots, raw Wasm report tables and
per-run adoption/experiment notes from the current working tree. Useful conclusions
are consolidated above. It did not create another archive or move the bulk into
hidden permanent storage. The retired tracked files remain in ordinary Git history;
for example, the pre-cleanup committed tree is
`d8374e3ce80095a8f50bdb80e9d88ecc8f3b0003`.

Historical receipts keep their original source, tool, package and observed-outcome
identities. Links to compact summaries or this notice do not make removed raw
artifacts independently verifiable from the current tree. Old hashes and reported
results are historical records, not proof of current availability or later source
qualification. Reproduce a required claim with admitted inputs, or obtain an
explicit minimal retention exception before publishing new raw evidence.

Existing ignored `target/` investigations, private originals, active deployment
recovery state, tool stores, Git refs/tags and published packages were outside this
cleanup. No history rewrite, remote archival or sibling cleanup was performed.
Do not infer that an old hosted artifact or ignored cache still exists from a
historical path alone.
