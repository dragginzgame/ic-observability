//! Opaque structured history; consumers own payload admission and timestamp semantics.

use alloc::collections::VecDeque;
use core::fmt;

#[cfg(test)]
mod tests;

/// Immutable bounds on row count and caller-accounted payload bytes.
///
/// Bytes are a consumer-defined charge, not a measurement of all heap memory.
/// Consumers must bound each payload's fields before appending and account for
/// their retained content consistently. Inline metadata, spare capacity and
/// allocator overhead are not automatically charged.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct HistoryLimits {
    /// Maximum retained rows; zero disables admission.
    pub entries: usize,
    /// Maximum sum of retained row payload charges.
    pub payload_bytes: usize,
}

/// Successful admission and the oldest history removed to make room.
#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub struct HistoryAppend {
    /// Number of evicted rows.
    pub evicted: usize,
    /// Sum of the evicted rows' payload charges.
    pub evicted_payload_bytes: usize,
}

/// Why an opaque history refused an input before changing retained state.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum HistoryRejectionReason {
    /// The configured row capacity is zero.
    Disabled,
    /// The input cannot fit even in an empty history.
    PayloadTooLarge {
        /// Caller-supplied input charge.
        supplied: usize,
        /// Configured total payload ceiling.
        maximum: usize,
    },
}

impl fmt::Display for HistoryRejectionReason {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Disabled => formatter.write_str("history admission is disabled"),
            Self::PayloadTooLarge { supplied, maximum } => write!(
                formatter,
                "history payload charge {supplied} exceeds {maximum}"
            ),
        }
    }
}

impl core::error::Error for HistoryRejectionReason {}

/// Refused input, returned intact without requiring cloning.
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct HistoryRejection<T> {
    /// Input whose ownership returns to the caller.
    pub value: T,
    /// Typed refusal reason.
    pub reason: HistoryRejectionReason,
}

impl<T> fmt::Display for HistoryRejection<T> {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        self.reason.fmt(formatter)
    }
}

impl<T: fmt::Debug> core::error::Error for HistoryRejection<T> {}

#[derive(Clone, Debug)]
struct Row<T> {
    value: T,
    payload_bytes: usize,
}

/// Count- and payload-bounded heap history of consumer-owned structured rows.
///
/// Oldest rows are evicted first. Iteration borrows immutable rows in append
/// order and can be reversed for newest-first views. No `Clone` bound is needed.
/// There is no clock, timestamp ordering, sequence identity, truncation, codec,
/// checkpoint or global recorder. Consumers retain sanitization, field bounds,
/// privacy, synchronization and lifecycle; this is not a durable byte format.
/// Interior-mutability payloads must not grow their charged content while retained.
#[derive(Clone, Debug)]
pub struct BoundedHistory<T> {
    limits: HistoryLimits,
    rows: VecDeque<Row<T>>,
    payload_bytes: usize,
}

impl<T> BoundedHistory<T> {
    /// Construct an empty history without allocating.
    #[must_use]
    pub const fn new(limits: HistoryLimits) -> Self {
        Self {
            limits,
            rows: VecDeque::new(),
            payload_bytes: 0,
        }
    }

    /// Append one pre-admitted payload, evicting oldest rows until both bounds fit.
    ///
    /// Work is bounded by the configured retained row count. Payload charges
    /// are stored at admission and are not recomputed during eviction.
    ///
    /// # Errors
    /// Returns the original input when disabled or individually oversized.
    /// Refusal changes neither retained rows nor payload accounting.
    pub fn append(
        &mut self,
        value: T,
        payload_bytes: usize,
    ) -> Result<HistoryAppend, HistoryRejection<T>> {
        let reason = if self.limits.entries == 0 {
            Some(HistoryRejectionReason::Disabled)
        } else if payload_bytes > self.limits.payload_bytes {
            Some(HistoryRejectionReason::PayloadTooLarge {
                supplied: payload_bytes,
                maximum: self.limits.payload_bytes,
            })
        } else {
            None
        };
        if let Some(reason) = reason {
            return Err(HistoryRejection { value, reason });
        }

        let mut receipt = HistoryAppend::default();
        while self.rows.len() >= self.limits.entries
            || self.payload_bytes > self.limits.payload_bytes - payload_bytes
        {
            if let Some(row) = self.rows.pop_front() {
                self.payload_bytes -= row.payload_bytes;
                receipt.evicted += 1;
                receipt.evicted_payload_bytes += row.payload_bytes;
            }
        }
        self.rows.push_back(Row {
            value,
            payload_bytes,
        });
        self.payload_bytes += payload_bytes;
        Ok(receipt)
    }

    /// Borrow rows oldest first; reverse the iterator for newest-first projection.
    pub fn entries(&self) -> impl DoubleEndedIterator<Item = &T> + ExactSizeIterator + '_ {
        self.rows.iter().map(|row| &row.value)
    }

    /// Current sum of caller-accounted retained payload bytes.
    #[must_use]
    pub const fn retained_payload_bytes(&self) -> usize {
        self.payload_bytes
    }

    /// Immutable consumer-selected bounds.
    #[must_use]
    pub const fn limits(&self) -> HistoryLimits {
        self.limits
    }

    /// Drop all retained rows and charges, preserving limits.
    /// This establishes no instance/reset identity.
    pub fn clear(&mut self) {
        self.rows.clear();
        self.payload_bytes = 0;
    }
}
