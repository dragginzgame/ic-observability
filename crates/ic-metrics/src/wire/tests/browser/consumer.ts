import { MetricsReport } from './reports.ts';

type Report = Parameters<typeof MetricsReport.encode>[0];
const aggregate: Report['aggregate'] = {
  samples: 1n, total: 0n, maximum: { some: 0n },
  samples_overflowed: false, total_overflowed: false,
};
const report: Report = {
  aggregate,
  counter: { total: 0n, total_overflowed: false },
  summary: { aggregate, latest: { some: 0n } },
  histogram: {
    upper_bounds: Array.from({ length: 37 }, (_, index) => BigInt(index)),
    bucket_counts: Array.from({ length: 37 }, (_, index) => index === 0 ? 1n : 0n),
    overflow: 0n, bucket_overflowed: Array<boolean>(37).fill(false),
    overflow_count_overflowed: false, aggregate,
  },
};
const encoded: Uint8Array = MetricsReport.encode(report);
const decoded = MetricsReport.decode(encoded);
const wide: bigint = decoded.counter.total;
const latest: null | { readonly some: bigint } = decoded.summary.latest;
void [wide, latest];
// @ts-expect-error Decoded wide totals cannot be consumed as a JavaScript number.
const lossy: number = decoded.counter.total;
void lossy;

// Wide arithmetic and option representations must survive generated typing.
// @ts-expect-error u128 transport uses bigint, never number.
MetricsReport.encode({ ...report, counter: { total: 0, total_overflowed: false } });
// @ts-expect-error Present option values require an explicit some wrapper.
const invalidMaximum: Report['aggregate']['maximum'] = 0n;
// @ts-expect-error The report requires all four measurement shapes.
MetricsReport.encode({ aggregate });
void invalidMaximum;
