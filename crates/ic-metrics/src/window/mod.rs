//! Heap-local reset bookkeeping for consumer-defined measurement state.

/// A reset window containing any consumer-defined combination of metric shapes.
///
/// The reset sequence is local to this instance and becomes unavailable rather
/// than wrapping. It is not a globally unique identity or a persistence epoch.
/// Consumers must establish the same host/heap lifetime, units and append-only
/// continuity before using it to qualify numeric deltas. Platform clocks,
/// replication decisions and reset authorization remain consumer-owned.
#[derive(Clone, Debug)]
pub struct MeasurementWindow<T> {
    state: T,
    sequence: Option<u64>,
}

impl<T> MeasurementWindow<T> {
    /// Create a fresh instance with consumer-supplied empty state.
    pub const fn new(state: T) -> Self {
        Self {
            state,
            sequence: Some(0),
        }
    }

    /// Borrow the current measurement state without cloning a report.
    pub const fn state(&self) -> &T {
        &self.state
    }

    /// Access state for recording. Use `reset` when replacing a measurement window.
    pub const fn state_mut(&mut self) -> &mut T {
        &mut self.state
    }

    /// Heap-local reset sequence, or unavailable after sequence exhaustion.
    pub const fn sequence(&self) -> Option<u64> {
        self.sequence
    }

    /// Replace all state and advance the reset sequence, without a platform clock.
    /// Replacement state, policy and authorization are supplied by the consumer.
    pub fn reset(&mut self, state: T) {
        self.state = state;
        self.sequence = self.sequence.and_then(|value| value.checked_add(1));
    }
}

#[cfg(test)]
mod tests;
