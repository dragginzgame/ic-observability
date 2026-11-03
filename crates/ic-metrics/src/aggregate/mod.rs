//! Application-owned observations, without report arithmetic.

use crate::{MeasurementStateError, add_count, add_total};

#[cfg(test)]
mod tests;

/// Mergeable count, total and maximum in one consumer-selected unit.
///
/// Counts clip at `u64::MAX` and totals at `u128::MAX`; sticky flags record actual
/// overflow, so an exactly reached cap remains exact. Maximum is an individual
/// observation and remains valid after overflow. There is no latest observation:
/// unordered batches cannot establish ordering. Every `u64` sample fits in a
/// `u128` total while the sample count remains exact. No allocation or platform reads.
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub struct MeasurementAggregate {
    samples: u64,
    total: u128,
    maximum: u64,
    samples_overflowed: bool,
    total_overflowed: bool,
}

impl MeasurementAggregate {
    /// Restore explicit fields after numeric consistency checks.
    ///
    /// Exactly reached caps with false flags stay exact. This admits arithmetic
    /// consistency only; the caller owns provenance, units and window identity.
    ///
    /// # Errors
    /// Rejects invalid empty state, missing maxima, inconsistent overflow flags
    /// and totals outside the range allowed by count and maximum.
    pub(crate) const fn from_parts(
        samples: u64,
        total: u128,
        maximum: Option<u64>,
        samples_overflowed: bool,
        total_overflowed: bool,
    ) -> Result<Self, MeasurementStateError> {
        if samples == 0 {
            return if total == 0 && maximum.is_none() && !samples_overflowed && !total_overflowed {
                Ok(Self::EMPTY)
            } else {
                Err(MeasurementStateError::InvalidEmpty)
            };
        }
        let Some(maximum) = maximum else {
            return Err(MeasurementStateError::MissingMaximum);
        };
        if (samples_overflowed && samples != u64::MAX)
            || (total_overflowed && (total != u128::MAX || !samples_overflowed))
        {
            return Err(MeasurementStateError::InvalidOverflowFlag);
        }
        if total < maximum as u128
            || (maximum == 0 && total != 0)
            || (!samples_overflowed && total > samples as u128 * maximum as u128)
        {
            return Err(MeasurementStateError::InvalidTotal);
        }
        Ok(Self {
            samples,
            total,
            maximum,
            samples_overflowed,
            total_overflowed,
        })
    }

    /// Empty aggregate, without a maximum observation.
    pub const EMPTY: Self = Self {
        samples: 0,
        total: 0,
        maximum: 0,
        samples_overflowed: false,
        total_overflowed: false,
    };

    /// Record one admitted observation, including zero, in the existing unit.
    pub const fn record(&mut self, value: u64) {
        add_count(&mut self.samples, &mut self.samples_overflowed, 1);
        add_total(&mut self.total, &mut self.total_overflowed, value as u128);
        if value > self.maximum {
            self.maximum = value;
        }
    }

    /// Combine observations from a batch without claiming ordering or identity.
    ///
    /// Consumers must establish common units and deliberate sample attribution.
    /// This is addition, not deduplication: merging the same batch twice records
    /// it twice. Source overflow remains sticky even when its clipped value fits.
    pub const fn merge(&mut self, other: Self) {
        add_count(
            &mut self.samples,
            &mut self.samples_overflowed,
            other.samples,
        );
        add_total(&mut self.total, &mut self.total_overflowed, other.total);
        self.samples_overflowed |= other.samples_overflowed;
        self.total_overflowed |= other.total_overflowed;
        if other.maximum > self.maximum {
            self.maximum = other.maximum;
        }
    }

    /// Sample count, clipped at `u64::MAX`; check [`Self::samples_overflowed`].
    #[must_use]
    pub const fn samples(self) -> u64 {
        self.samples
    }

    /// Total, clipped at `u128::MAX`; check [`Self::total_overflowed`].
    #[must_use]
    pub const fn total(self) -> u128 {
        self.total
    }

    /// Whether recording or merging has actually overflowed the sample count.
    #[must_use]
    pub const fn samples_overflowed(self) -> bool {
        self.samples_overflowed
    }

    /// Whether recording or merging has actually overflowed the value total.
    #[must_use]
    pub const fn total_overflowed(self) -> bool {
        self.total_overflowed
    }

    /// Largest observation, or `None` when empty, including after overflow.
    #[must_use]
    pub const fn maximum(self) -> Option<u64> {
        if self.samples == 0 {
            None
        } else {
            Some(self.maximum)
        }
    }
}
