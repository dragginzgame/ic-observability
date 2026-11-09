//! Public typed tables preserve domain identity without codecs or Clone requirements.
#![cfg(feature = "recording")]

use ic_metrics::{
    BoundedCounterTable, LexicalMeasurementTable, LexicalTableLimitsError, MeasurementTableLimits,
};
use std::cmp::Ordering;

#[derive(Debug, Eq, Ord, PartialEq, PartialOrd)]
struct Identity {
    target: u64,
    method: String,
}

const NO_IDENTITIES: MeasurementTableLimits = MeasurementTableLimits {
    entries: 0,
    key_bytes: 0,
    total_key_bytes: 0,
};

// Const evaluation exercises opaque owned-string identity types without creating
// a key or allocating a retained map. These operations need only recorder math.
const OMITTED_COUNTERS: BoundedCounterTable<Identity> = {
    let mut table = BoundedCounterTable::new(NO_IDENTITIES);
    table.add_omitted(u128::MAX);
    table
};
const OMITTED_MEASUREMENTS: Result<LexicalMeasurementTable<Identity>, LexicalTableLimitsError> = {
    let mut result = LexicalMeasurementTable::new(NO_IDENTITIES);
    if let Ok(table) = &mut result {
        table.record_omitted(0);
        table.record_omitted(19);
    }
    result
};

#[test]
fn external_explicit_omission_is_const_without_constructing_owned_keys() {
    let counters = OMITTED_COUNTERS;
    assert_eq!(counters.omitted().exact_total(), Ok(u128::MAX));
    assert_eq!(counters.entries().len(), 0);
    assert_eq!(counters.retained_key_bytes(), 0);
    let measurements = OMITTED_MEASUREMENTS.unwrap();
    assert_eq!(measurements.omitted().samples(), 2);
    assert_eq!(measurements.omitted().total(), 19);
    assert_eq!(measurements.omitted().maximum(), Some(19));
    assert_eq!(measurements.entries().len(), 0);
    assert_eq!(measurements.retained_key_bytes(), 0);
}

#[derive(Debug, Eq, PartialEq)]
struct NeverCompared(u8);

impl Ord for NeverCompared {
    fn cmp(&self, _: &Self) -> Ordering {
        panic!("explicit omission must not compare keys");
    }
}

impl PartialOrd for NeverCompared {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

#[test]
fn external_explicit_omission_leaves_retained_state_without_comparing_keys() {
    let limits = MeasurementTableLimits {
        entries: 1,
        key_bytes: 8,
        total_key_bytes: 8,
    };
    let mut counters = BoundedCounterTable::new(limits);
    // First insertion into an empty map needs no comparison.
    counters.add(NeverCompared(7), 3, 12);
    counters.add_omitted(17);
    let (key, counter) = counters.entries().next().unwrap();
    assert_eq!(key.0, 7);
    assert_eq!(counter.exact_total(), Ok(12));
    assert_eq!(counters.entries().len(), 1);
    assert_eq!(counters.retained_key_bytes(), 3);
    assert_eq!(counters.limits(), limits);
    assert_eq!(counters.omitted().exact_total(), Ok(17));

    let mut measurements = LexicalMeasurementTable::new(limits).unwrap();
    measurements.record(NeverCompared(9), 4, 23);
    measurements.record_omitted(0);
    measurements.record_omitted(u64::MAX);
    let (key, aggregate) = measurements.entries().next().unwrap();
    assert_eq!(key.0, 9);
    assert_eq!(aggregate.samples(), 1);
    assert_eq!(aggregate.total(), 23);
    assert_eq!(aggregate.maximum(), Some(23));
    assert_eq!(measurements.entries().len(), 1);
    assert_eq!(measurements.retained_key_bytes(), 4);
    assert_eq!(measurements.limits(), limits);
    assert_eq!(measurements.omitted().samples(), 2);
    assert_eq!(measurements.omitted().total(), u128::from(u64::MAX));
    assert_eq!(measurements.omitted().maximum(), Some(u64::MAX));
}

#[test]
fn external_typed_tables_preserve_scalar_units_and_measurement_loss_accounting() {
    let limits = MeasurementTableLimits {
        entries: 1,
        key_bytes: 8,
        total_key_bytes: 8,
    };
    let identity = |target| Identity {
        target,
        method: "call".into(),
    };
    let mut counters = BoundedCounterTable::new(limits);
    counters.add(identity(2), 4, u128::MAX);
    counters.add(identity(1), 4, 7);
    assert_eq!(counters.entries().next().unwrap().0.target, 2);
    assert_eq!(
        counters.entries().next().unwrap().1.exact_total(),
        Ok(u128::MAX)
    );
    assert_eq!(counters.omitted().exact_total(), Ok(7));

    let mut measurements = LexicalMeasurementTable::new(limits).unwrap();
    measurements.record(identity(2), 4, 0);
    assert!(measurements.record_existing(&identity(2), 10));
    measurements.record(identity(1), 4, 20);
    let (key, aggregate) = measurements.entries().next().unwrap();
    assert_eq!(key.target, 1);
    assert_eq!(aggregate.total(), 20);
    assert_eq!(measurements.omitted().samples(), 2);
    assert_eq!(measurements.omitted().total(), 10);
    assert_eq!(measurements.omitted().maximum(), Some(10));
}
