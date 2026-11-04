#[test]
fn retained_instrumentation_contract() {
    use ic_metrics::{
        MeasurementAggregate, MeasurementCounter, MeasurementCounterError, persistence,
    };
    let mut observations = MeasurementAggregate::EMPTY;
    observations.record(0);
    observations.record(u64::MAX);
    assert_eq!(observations.samples(), 2);
    assert_eq!(observations.maximum(), Some(u64::MAX));
    assert!(!observations.total_overflowed());
    let restored = persistence::restore_aggregate(
        observations.samples(),
        observations.total(),
        observations.maximum(),
        observations.samples_overflowed(),
        observations.total_overflowed(),
    )
    .unwrap();
    assert_eq!(restored, observations);
    let mut events = MeasurementCounter::ZERO;
    events.add(u128::MAX);
    assert_eq!(events.exact_total(), Ok(u128::MAX));
    events.add(1);
    assert_eq!(
        events.exact_total(),
        Err(MeasurementCounterError::TotalOverflow)
    );
}
