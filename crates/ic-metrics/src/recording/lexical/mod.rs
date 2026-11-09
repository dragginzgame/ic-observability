//! Typed lexical-prefix retention with complete aggregate loss accounting.

use alloc::collections::BTreeMap;
use core::{borrow::Borrow, fmt};

use super::{MeasurementAttribution, MeasurementOmission, MeasurementTableLimits};
use crate::MeasurementAggregate;

#[cfg(test)]
mod tests;

/// Invalid limits for arrival-order-independent lexical retention.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum LexicalTableLimitsError {
    /// Entry capacity times the per-key maximum cannot be represented.
    KeyBudgetOverflow,
    /// The total key budget cannot hold every permitted row at its maximum.
    KeyBudgetTooSmall,
}

impl fmt::Display for LexicalTableLimitsError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter.write_str(match self {
            Self::KeyBudgetOverflow => "lexical key capacity overflows usize",
            Self::KeyBudgetTooSmall => {
                "lexical total key budget is smaller than capacity times per-key bytes"
            }
        })
    }
}

impl core::error::Error for LexicalTableLimitsError {}

/// Bounded typed observation identities selected by lexical order, not arrival order.
///
/// Consumers supply stable `Ord` identity and a consistent key-payload byte charge.
/// Metadata, map nodes and allocator overhead are not charged automatically. Keys
/// and their charges must not change while retained. Oversized identities are
/// ineligible; other identities retain the lexically smallest `limits.entries` keys.
/// Construction requires enough total key budget for every slot at its per-key
/// maximum. This prevents weighted-byte pressure from making the retained set
/// depend on arrival order or requiring storage of previously omitted keys.
/// Each evicted aggregate is merged completely into `omitted`, including sticky
/// overflow quality. Omitted history is never reconstructed.
/// The retained identity set is order-independent for fixed key eligibility.
/// Units, attribution, reset identity and reporting remain consumer-owned.
#[derive(Clone, Debug)]
pub struct LexicalMeasurementTable<K> {
    limits: MeasurementTableLimits,
    entries: BTreeMap<K, (usize, MeasurementAggregate)>,
    retained_key_bytes: usize,
    omitted: MeasurementAggregate,
}

impl<K: Ord> LexicalMeasurementTable<K> {
    /// Construct an empty table without allocating.
    ///
    /// # Errors
    /// Refuses an overflowing worst-case key budget or a total budget smaller
    /// than entry capacity times the per-key maximum. No table is constructed.
    pub const fn new(limits: MeasurementTableLimits) -> Result<Self, LexicalTableLimitsError> {
        let Some(required) = limits.entries.checked_mul(limits.key_bytes) else {
            return Err(LexicalTableLimitsError::KeyBudgetOverflow);
        };
        if required > limits.total_key_bytes {
            return Err(LexicalTableLimitsError::KeyBudgetTooSmall);
        }
        Ok(Self {
            limits,
            entries: BTreeMap::new(),
            retained_key_bytes: 0,
            omitted: MeasurementAggregate::EMPTY,
        })
    }

    /// Record one observation or account for it once in `omitted`.
    ///
    /// At capacity, an earlier eligible key replaces the greatest retained key,
    /// merging that key's entire history into `omitted`. Refused keys never
    /// evict existing state. Every update uses ordered-map lookup; admission
    /// evicts at most one identity.
    pub fn record(&mut self, key: K, key_bytes: usize, observation: u64) -> MeasurementAttribution {
        if key_bytes > self.limits.key_bytes {
            return self.omit(observation, MeasurementOmission::KeyBytes);
        }
        if self.record_existing(&key, observation) {
            return MeasurementAttribution::Retained;
        }
        if self.limits.entries == 0 {
            return self.omit(observation, MeasurementOmission::Entries);
        }
        if self.entries.len() >= self.limits.entries {
            if self
                .entries
                .last_key_value()
                .is_none_or(|(last, _)| key >= *last)
            {
                return self.omit(observation, MeasurementOmission::Entries);
            }
            if let Some((_, (bytes, aggregate))) = self.entries.pop_last() {
                self.retained_key_bytes -= bytes;
                self.omitted.merge(aggregate);
            }
        }
        let mut aggregate = MeasurementAggregate::EMPTY;
        aggregate.record(observation);
        self.entries.insert(key, (key_bytes, aggregate));
        self.retained_key_bytes += key_bytes;
        MeasurementAttribution::Retained
    }

    /// Update an admitted borrowed identity without constructing or allocating a key.
    /// Returns false for an absent identity with no change, including to omitted state.
    pub fn record_existing<Q: Ord + ?Sized>(&mut self, key: &Q, observation: u64) -> bool
    where
        K: Borrow<Q>,
    {
        self.entries.get_mut(key).is_some_and(|(_, aggregate)| {
            aggregate.record(observation);
            true
        })
    }

    /// Record one measurement whose identity the caller cannot retain.
    ///
    /// No key is constructed or compared, no allocation occurs, and retained
    /// entries, charges and limits are unchanged. Measured zero is a sample;
    /// maximum and actual-overflow quality follow canonical aggregate recording.
    /// The caller owns why identity was omitted. Use this instead of admission
    /// for that observation, never in addition to it.
    pub const fn record_omitted(&mut self, observation: u64) {
        self.omitted.record(observation);
    }

    const fn omit(
        &mut self,
        observation: u64,
        reason: MeasurementOmission,
    ) -> MeasurementAttribution {
        self.record_omitted(observation);
        MeasurementAttribution::Omitted(reason)
    }

    /// Borrow retained typed keys and copy aggregate state in lexical order.
    pub fn entries(
        &self,
    ) -> impl DoubleEndedIterator<Item = (&K, MeasurementAggregate)> + ExactSizeIterator {
        self.entries.iter().map(|(key, (_, value))| (key, *value))
    }

    /// All rejected observations and complete evicted histories, accounted once.
    /// This counts observations, never distinct identities; measured zero is retained.
    #[must_use]
    pub const fn omitted(&self) -> MeasurementAggregate {
        self.omitted
    }

    /// Current retained key-payload charges.
    #[must_use]
    pub const fn retained_key_bytes(&self) -> usize {
        self.retained_key_bytes
    }

    /// Immutable consumer-selected limits.
    #[must_use]
    pub const fn limits(&self) -> MeasurementTableLimits {
        self.limits
    }

    /// Clear all identities and observations, preserving limits without establishing reset identity.
    pub fn clear(&mut self) {
        self.entries.clear();
        self.retained_key_bytes = 0;
        self.omitted = MeasurementAggregate::EMPTY;
    }
}
