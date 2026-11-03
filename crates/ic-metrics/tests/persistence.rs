//! External client of the explicit persistence contract; no private imports.

use ic_metrics::{
    MeasurementAggregate, MeasurementCounter, MeasurementHistogram, MeasurementSummary,
    persistence::{self, MeasurementStateError},
};

#[test]
fn retained_fields_round_trip_all_recorders_and_recording_continues() {
    for observations in [&[][..], &[0][..], &[0, 7, u64::MAX, u64::MAX][..]] {
        let mut summary = MeasurementSummary::EMPTY;
        let mut histogram = MeasurementHistogram::new([0, 10, u64::MAX]).unwrap();
        let mut counter = MeasurementCounter::ZERO;
        for &value in observations {
            summary.record(value);
            histogram.record(value);
            counter.add(u128::from(value));
        }
        let aggregate = summary.aggregate();
        let restored_aggregate = persistence::restore_aggregate(
            aggregate.samples(),
            aggregate.total(),
            aggregate.maximum(),
            aggregate.samples_overflowed(),
            aggregate.total_overflowed(),
        )
        .unwrap();
        let mut restored_summary =
            persistence::restore_summary(restored_aggregate, summary.latest()).unwrap();
        let mut restored_histogram = persistence::restore_histogram(
            *histogram.upper_bounds(),
            *histogram.bucket_counts(),
            histogram.overflow(),
            *histogram.bucket_overflowed(),
            histogram.overflow_count_overflowed(),
            restored_aggregate,
        )
        .unwrap();
        let mut restored_counter =
            persistence::restore_counter(counter.total(), counter.total_overflowed()).unwrap();
        assert_eq!(restored_aggregate, aggregate);
        assert_eq!(restored_summary, summary);
        assert_eq!(restored_histogram, histogram);
        assert_eq!(restored_counter, counter);
        summary.record(0);
        histogram.record(0);
        counter.add(1);
        restored_summary.record(0);
        restored_histogram.record(0);
        restored_counter.add(1);
        assert_eq!(restored_summary, summary);
        assert_eq!(restored_histogram, histogram);
        assert_eq!(restored_counter, counter);
    }
}

#[test]
fn persistence_preserves_exact_caps_sticky_overflow_and_typed_refusals() {
    let mut aggregate = persistence::restore_aggregate(
        u64::MAX,
        u128::from(u64::MAX).pow(2),
        Some(u64::MAX),
        false,
        false,
    )
    .unwrap();
    assert!(!aggregate.samples_overflowed());
    aggregate.record(u64::MAX);
    aggregate.record(u64::MAX);
    assert_eq!(aggregate.total(), u128::MAX);
    assert!(aggregate.samples_overflowed());
    assert!(!aggregate.total_overflowed());
    aggregate.record(1);
    let restored = persistence::restore_aggregate(
        aggregate.samples(),
        aggregate.total(),
        aggregate.maximum(),
        aggregate.samples_overflowed(),
        aggregate.total_overflowed(),
    )
    .unwrap();
    assert_eq!(restored, aggregate);
    let mut counter = persistence::restore_counter(u128::MAX, false).unwrap();
    assert_eq!(counter.exact_total(), Ok(u128::MAX));
    counter.add(1);
    assert_eq!(persistence::restore_counter(u128::MAX, true), Ok(counter));
    assert_eq!(
        persistence::restore_counter(1, true),
        Err(MeasurementStateError::InvalidOverflowFlag)
    );
    assert_eq!(
        persistence::restore_aggregate(0, 0, Some(0), false, false),
        Err(MeasurementStateError::InvalidEmpty)
    );
    assert_eq!(
        persistence::restore_summary(MeasurementAggregate::EMPTY, Some(0)),
        Err(MeasurementStateError::InvalidLatest)
    );
    assert_eq!(
        persistence::restore_histogram(
            [1, 1],
            [0, 0],
            0,
            [false; 2],
            false,
            MeasurementAggregate::EMPTY
        ),
        Err(MeasurementStateError::InvalidBounds)
    );
    assert_eq!(
        persistence::restore_histogram([1], [1], 0, [false], false, MeasurementAggregate::EMPTY),
        Err(MeasurementStateError::InvalidDistribution)
    );
    assert_eq!(
        persistence::validate_histogram_bounds(&[0, u64::MAX]),
        Ok(())
    );
    assert_eq!(
        persistence::validate_histogram_bounds(&[3, 3])
            .unwrap_err()
            .index(),
        1
    );
}

#[cfg(feature = "recording")]
#[test]
fn application_recording_keeps_omission_and_reset_semantics() {
    use ic_metrics::{BoundedMeasurementTable, MeasurementTableLimits, MeasurementWindow};
    let limits = MeasurementTableLimits {
        entries: 1,
        key_bytes: 16,
        total_key_bytes: 16,
    };
    let mut window = MeasurementWindow::new(BoundedMeasurementTable::new(limits));
    window.state_mut().record("query", 0);
    window.state_mut().record("query", 9);
    window.state_mut().record("update", 4);
    let (_, retained) = window.state().entries().next().unwrap();
    assert_eq!((retained.samples(), retained.total()), (2, 9));
    assert_eq!(
        (
            window.state().omitted().samples(),
            window.state().omitted().total()
        ),
        (1, 4)
    );
    window.reset(BoundedMeasurementTable::new(limits));
    assert_eq!(window.sequence(), Some(1));
    assert_eq!(window.state().entries().len(), 0);
    assert_eq!(window.state().omitted(), MeasurementAggregate::EMPTY);
}
