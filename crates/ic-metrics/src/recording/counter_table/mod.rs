//! First-admitted typed scalar diagnostics, with no measurement-sample conversion.

use alloc::collections::BTreeMap;
use core::borrow::Borrow;

use super::{MeasurementAttribution, MeasurementOmission, MeasurementTableLimits};
use crate::MeasurementCounter;

#[cfg(test)]
mod tests;

/// First-admitted typed identities with canonical scalar/omitted counters.
///
/// Consumers supply stable identity ordering and a consistent retained key-payload
/// byte charge. Limits bound those charges, not fixed key metadata, map nodes or
/// allocator overhead. Key fields and their charged content must not mutate while
/// retained. These are diagnostic increments, never balances or spending authority.
/// Iteration is lexical by `K::Ord`, not admission order. No DTO or codec is owned.
#[derive(Clone, Debug)]
pub struct BoundedCounterTable<K> {
    limits: MeasurementTableLimits,
    entries: BTreeMap<K, MeasurementCounter>,
    retained_key_bytes: usize,
    omitted: MeasurementCounter,
}

impl<K: Ord> BoundedCounterTable<K> {
    /// Construct an empty table without allocating.
    #[must_use]
    pub const fn new(limits: MeasurementTableLimits) -> Self {
        Self {
            limits,
            entries: BTreeMap::new(),
            retained_key_bytes: 0,
            omitted: MeasurementCounter::ZERO,
        }
    }

    /// Add a scalar increment once, under a retained identity or to `omitted`.
    ///
    /// Checks per-key charge first, then existing identity, entry capacity and
    /// remaining total charge. Existing identities continue at capacity; their
    /// original charge remains fixed. Zero increments can admit identities.
    pub fn add(&mut self, key: K, key_bytes: usize, increment: u128) -> MeasurementAttribution {
        let reason = if key_bytes > self.limits.key_bytes {
            Some(MeasurementOmission::KeyBytes)
        } else if self.add_existing(&key, increment) {
            return MeasurementAttribution::Retained;
        } else if self.entries.len() >= self.limits.entries {
            Some(MeasurementOmission::Entries)
        } else if key_bytes > self.limits.total_key_bytes - self.retained_key_bytes {
            Some(MeasurementOmission::TotalKeyBytes)
        } else {
            None
        };
        if let Some(reason) = reason {
            self.omitted.add(increment);
            return MeasurementAttribution::Omitted(reason);
        }
        let mut counter = MeasurementCounter::ZERO;
        counter.add(increment);
        self.entries.insert(key, counter);
        self.retained_key_bytes += key_bytes;
        MeasurementAttribution::Retained
    }

    /// Update an admitted borrowed identity without constructing or allocating a key.
    ///
    /// Returns false for an absent key without changing any counters, including
    /// omitted state. Then use [`Self::add`] to perform new-key admission once.
    pub fn add_existing<Q: Ord + ?Sized>(&mut self, key: &Q, increment: u128) -> bool
    where
        K: Borrow<Q>,
    {
        self.entries.get_mut(key).is_some_and(|counter| {
            counter.add(increment);
            true
        })
    }

    /// Borrow typed identities and copy scalar state in lexical order.
    pub fn entries(
        &self,
    ) -> impl DoubleEndedIterator<Item = (&K, MeasurementCounter)> + ExactSizeIterator {
        self.entries.iter().map(|(key, value)| (key, *value))
    }

    /// Scalar increments whose identity could not be retained, with actual-overflow quality.
    #[must_use]
    pub const fn omitted(&self) -> MeasurementCounter {
        self.omitted
    }

    /// Retained key-payload charges, excluding map/allocator overhead.
    #[must_use]
    pub const fn retained_key_bytes(&self) -> usize {
        self.retained_key_bytes
    }

    /// Immutable consumer-selected limits.
    #[must_use]
    pub const fn limits(&self) -> MeasurementTableLimits {
        self.limits
    }

    /// Clear identities and all counters without changing limits or establishing reset identity.
    pub fn clear(&mut self) {
        self.entries.clear();
        self.retained_key_bytes = 0;
        self.omitted = MeasurementCounter::ZERO;
    }
}
