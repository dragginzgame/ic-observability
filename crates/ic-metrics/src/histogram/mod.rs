//! Fixed-size distributions without sampling or reporting policy.

use core::fmt;

use crate::{MeasurementAggregate, MeasurementStateError, add_count};

mod restoration;
use restoration::validate_distribution;

#[cfg(test)]
mod tests;

/// A bound is not strictly greater than the preceding bound.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct HistogramBoundsError {
    index: usize,
}

impl HistogramBoundsError {
    /// Zero-based index of the first invalid bound, always at least one.
    #[must_use]
    pub const fn index(self) -> usize {
        self.index
    }
}

impl fmt::Display for HistogramBoundsError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            formatter,
            "histogram bound {} is not strictly increasing",
            self.index
        )
    }
}

impl core::error::Error for HistogramBoundsError {}

/// Why two histogram distributions cannot be combined.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct HistogramMergeError {
    index: usize,
}

impl HistogramMergeError {
    /// Zero-based index of the first differing inclusive upper bound.
    #[must_use]
    pub const fn index(self) -> usize {
        self.index
    }
}

impl fmt::Display for HistogramMergeError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(formatter, "histogram merge bound {} differs", self.index)
    }
}

impl core::error::Error for HistogramMergeError {}

/// Fixed-size histogram of observations in one consumer-selected unit.
///
/// `N` strictly increasing inclusive upper bounds define `N` disjoint buckets.
/// The first bucket includes zero; later buckets exclude the preceding bound.
/// Values above the last bound go into a separate overflow bucket. With no
/// bounds, every observation goes into overflow. A final bound of `u64::MAX`
/// is valid and leaves overflow empty.
///
/// Each observation updates one bucket and the accompanying
/// [`MeasurementAggregate`]. Counts clip independently at `u64::MAX`, with sticky
/// flags for actual overflow; exactly reached caps remain exact. Exact
/// bucket counts remain useful after the aggregate's total overflows. Overflow
/// can prevent bucket counts from summing to the aggregate's sample count.
/// Buckets describe ranges, not exact percentiles; no latest value is retained.
///
/// Storage is fixed arrays, overflow state and one aggregate, with no heap
/// allocation. Recording searches at most `N` bounds. Consumers choose bounds,
/// units, sample admission, identity and reset boundaries. Bounds are immutable
/// after construction; report encoding and persistence remain consumer-owned.
///
/// ```
/// use ic_metrics::MeasurementHistogram;
///
/// # fn main() -> Result<(), ic_metrics::HistogramBoundsError> {
/// let mut histogram = MeasurementHistogram::new([10, 100])?;
/// for value in [0, 10, 11, 101] {
///     histogram.record(value);
/// }
/// assert_eq!(histogram.bucket_counts(), &[2, 1]);
/// assert_eq!(histogram.overflow(), 1);
/// assert_eq!(histogram.aggregate().samples(), 4);
/// # Ok(())
/// # }
/// ```
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct MeasurementHistogram<const N: usize> {
    upper_bounds: [u64; N],
    bucket_counts: [u64; N],
    overflow: u64,
    bucket_overflowed: [bool; N],
    overflow_count_overflowed: bool,
    aggregate: MeasurementAggregate,
}

impl<const N: usize> MeasurementHistogram<N> {
    /// Restore disjoint buckets and an admitted aggregate without replaying samples.
    ///
    /// This checks structural arithmetic consistency, not observation provenance.
    /// Consumers retain units, attribution and reset identity.
    ///
    /// # Errors
    /// Rejects invalid bounds, overflow flags without clipped caps, disagreement
    /// between bucket counts and the aggregate, or an incompatible maximum.
    pub(crate) const fn from_parts(
        upper_bounds: [u64; N],
        bucket_counts: [u64; N],
        overflow: u64,
        bucket_overflowed: [bool; N],
        overflow_count_overflowed: bool,
        aggregate: MeasurementAggregate,
    ) -> Result<Self, MeasurementStateError> {
        if validate_histogram_bounds(&upper_bounds).is_err() {
            return Err(MeasurementStateError::InvalidBounds);
        }
        if let Err(error) = validate_distribution(
            &upper_bounds,
            &bucket_counts,
            overflow,
            &bucket_overflowed,
            overflow_count_overflowed,
            aggregate,
        ) {
            return Err(error);
        }
        Ok(Self {
            upper_bounds,
            bucket_counts,
            overflow,
            bucket_overflowed,
            overflow_count_overflowed,
            aggregate,
        })
    }

    /// Construct an empty histogram with inclusive upper bounds.
    ///
    /// Bounds and observations must use the same unit. A bound of zero and an
    /// empty bounds array are valid.
    ///
    /// # Errors
    ///
    /// Returns [`HistogramBoundsError`] for the first duplicate or descending
    /// bound. The error identifies the right-hand bound in that pair.
    pub const fn new(upper_bounds: [u64; N]) -> Result<Self, HistogramBoundsError> {
        if let Err(error) = validate_histogram_bounds(&upper_bounds) {
            return Err(error);
        }
        Ok(Self {
            upper_bounds,
            bucket_counts: [0; N],
            overflow: 0,
            bucket_overflowed: [false; N],
            overflow_count_overflowed: false,
            aggregate: MeasurementAggregate::EMPTY,
        })
    }

    /// Record one completed observation, including zero.
    ///
    /// Updates the aggregate and exactly one disjoint bucket. Every observation
    /// must use the same unit as the bounds and earlier observations.
    pub const fn record(&mut self, value: u64) {
        self.aggregate.record(value);
        let mut index = 0;
        while index < N {
            // Both arrays have length N; the guard establishes valid indices.
            if value <= self.upper_bounds[index] {
                add_count(
                    &mut self.bucket_counts[index],
                    &mut self.bucket_overflowed[index],
                    1,
                );
                return;
            }
            index += 1;
        }
        add_count(&mut self.overflow, &mut self.overflow_count_overflowed, 1);
    }

    /// Immutable inclusive upper bounds corresponding to [`Self::bucket_counts`].
    #[must_use]
    pub const fn upper_bounds(&self) -> &[u64; N] {
        &self.upper_bounds
    }

    /// Disjoint bucket counts, each saturating independently at `u64::MAX`.
    ///
    /// These exclude overflow and are not cumulative counts. Inspect
    /// [`Self::bucket_overflowed`] before using clipped counts as exact values.
    #[must_use]
    pub const fn bucket_counts(&self) -> &[u64; N] {
        &self.bucket_counts
    }

    /// Count above the last bound, saturating independently at `u64::MAX`.
    ///
    /// With no bounds, this counts all observations. Inspect
    /// [`Self::overflow_count_overflowed`] before treating the clipped count as exact.
    #[must_use]
    pub const fn overflow(&self) -> u64 {
        self.overflow
    }

    /// Sticky actual-overflow flags corresponding to [`Self::bucket_counts`].
    #[must_use]
    pub const fn bucket_overflowed(&self) -> &[bool; N] {
        &self.bucket_overflowed
    }

    /// Whether the overflow bucket's count has actually overflowed.
    #[must_use]
    pub const fn overflow_count_overflowed(&self) -> bool {
        self.overflow_count_overflowed
    }

    /// Mergeable aggregate of all observations, including overflow.
    #[must_use]
    pub const fn aggregate(&self) -> MeasurementAggregate {
        self.aggregate
    }

    /// Combine a distribution with exactly the same finite bounds.
    ///
    /// Consumers establish matching units and deliberate sample attribution.
    /// This adds observations without deduplication or ordering. Source overflow
    /// propagates independently for each count and the aggregate.
    ///
    /// # Errors
    /// Returns [`HistogramMergeError`] for the first differing bound, leaving
    /// the entire destination unchanged. Different bound counts are different
    /// Rust types and cannot be merged.
    pub const fn merge(&mut self, other: &Self) -> Result<(), HistogramMergeError> {
        let mut index = 0;
        while index < N {
            if self.upper_bounds[index] != other.upper_bounds[index] {
                return Err(HistogramMergeError { index });
            }
            index += 1;
        }
        index = 0;
        while index < N {
            add_count(
                &mut self.bucket_counts[index],
                &mut self.bucket_overflowed[index],
                other.bucket_counts[index],
            );
            self.bucket_overflowed[index] |= other.bucket_overflowed[index];
            index += 1;
        }
        add_count(
            &mut self.overflow,
            &mut self.overflow_count_overflowed,
            other.overflow,
        );
        self.overflow_count_overflowed |= other.overflow_count_overflowed;
        self.aggregate.merge(other.aggregate);
        Ok(())
    }
}

/// Validate borrowed inclusive histogram bounds without constructing a histogram.
///
/// Empty bounds, zero and `u64::MAX` are valid. This checks ordering only;
/// storage adapters own their bound-count limits and units remain caller-owned.
///
/// # Errors
/// Returns [`HistogramBoundsError`] for the first duplicate or descending bound,
/// identifying the right-hand bound in that pair.
///
pub const fn validate_histogram_bounds(upper_bounds: &[u64]) -> Result<(), HistogramBoundsError> {
    let mut index = 1;
    while index < upper_bounds.len() {
        // Both indices are within the slice, including when it is empty.
        if upper_bounds[index - 1] >= upper_bounds[index] {
            return Err(HistogramBoundsError { index });
        }
        index += 1;
    }
    Ok(())
}
