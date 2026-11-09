//! Public typed tables preserve domain identity without codecs or Clone requirements.
#![cfg(feature = "recording")]

use ic_metrics::{BoundedCounterTable, LexicalMeasurementTable, MeasurementTableLimits};

#[derive(Debug, Eq, Ord, PartialEq, PartialOrd)]
struct Identity {
    target: u64,
    method: String,
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
