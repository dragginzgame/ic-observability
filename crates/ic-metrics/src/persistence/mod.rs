//! Canonical restoration for governed Metrics storage adapters.
//!
//! Storage owns durable encoding, identity, allocation, continuity and lifecycle.
//! These functions admit retained instrumentation state without replaying samples.
//! They do not validate arbitrary report DTOs or establish observation provenance.
//! Recorder types deliberately implement neither Serde nor Wire traits.

use crate::HistogramBoundsError;
pub use crate::state::MeasurementStateError;
use crate::{MeasurementAggregate, MeasurementCounter, MeasurementHistogram, MeasurementSummary};

/// Restore retained sample count, total, maximum and actual-overflow quality.
///
/// # Errors
/// Rejects inconsistent empty state, missing maxima, invalid overflow flags and
/// totals outside the range admitted by the count and maximum.
pub const fn restore_aggregate(
    samples: u64,
    total: u128,
    maximum: Option<u64>,
    samples_overflowed: bool,
    total_overflowed: bool,
) -> Result<MeasurementAggregate, MeasurementStateError> {
    MeasurementAggregate::from_parts(
        samples,
        total,
        maximum,
        samples_overflowed,
        total_overflowed,
    )
}

/// Restore a retained diagnostic total and its sticky actual-overflow flag.
///
/// # Errors
/// Rejects an overflow flag without the clipped total. An exactly reached cap
/// with a false flag remains exact; missing provenance cannot be recovered.
pub const fn restore_counter(
    total: u128,
    total_overflowed: bool,
) -> Result<MeasurementCounter, MeasurementStateError> {
    MeasurementCounter::from_parts(total, total_overflowed)
}

/// Restore the latest ordered observation alongside an admitted aggregate.
///
/// # Errors
/// Rejects missing or inconsistent latest values. Ordering and identity remain
/// the storage adapter's responsibility.
pub const fn restore_summary(
    aggregate: MeasurementAggregate,
    latest: Option<u64>,
) -> Result<MeasurementSummary, MeasurementStateError> {
    MeasurementSummary::from_parts(aggregate, latest)
}

/// Restore retained disjoint buckets with their configured bounds and aggregate.
///
/// # Errors
/// Rejects invalid bounds, inconsistent counts, overflow flags or maximum
/// placement. Bound-count limits and configuration identity remain storage-owned.
pub const fn restore_histogram<const N: usize>(
    upper_bounds: [u64; N],
    bucket_counts: [u64; N],
    overflow: u64,
    bucket_overflowed: [bool; N],
    overflow_count_overflowed: bool,
    aggregate: MeasurementAggregate,
) -> Result<MeasurementHistogram<N>, MeasurementStateError> {
    MeasurementHistogram::from_parts(
        upper_bounds,
        bucket_counts,
        overflow,
        bucket_overflowed,
        overflow_count_overflowed,
        aggregate,
    )
}

/// Admit borrowed histogram configuration before a governed storage lookup.
///
/// # Errors
/// Returns the first duplicate or descending bound. This avoids constructing a
/// temporary histogram; storage owns the bound-count limit and unit binding.
pub const fn validate_histogram_bounds(bounds: &[u64]) -> Result<(), HistogramBoundsError> {
    crate::histogram::validate_histogram_bounds(bounds)
}
