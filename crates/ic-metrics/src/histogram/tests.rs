mod restoration;

use super::{HistogramBoundsError, MeasurementHistogram, validate_histogram_bounds};
use crate::MeasurementAggregate;

#[test]
fn rejects_first_duplicate_or_descending_bound() {
    for (bounds, index) in [([3, 3, 4], 1), ([3, 2, 4], 1), ([1, 4, 3], 2)] {
        assert_eq!(
            validate_histogram_bounds(&bounds),
            Err(HistogramBoundsError { index })
        );
        assert_eq!(
            MeasurementHistogram::new(bounds),
            Err(HistogramBoundsError { index })
        );
        assert_eq!(HistogramBoundsError { index }.index(), index);
        assert_eq!(
            MeasurementHistogram::from_parts(
                bounds,
                [0; 3],
                0,
                [false; 3],
                false,
                MeasurementAggregate::EMPTY,
            ),
            Err(crate::MeasurementStateError::InvalidBounds)
        );
    }
}

#[test]
fn borrowed_bounds_admit_empty_single_and_extreme_values_in_const_context() {
    const VALID: Result<(), HistogramBoundsError> = validate_histogram_bounds(&[0, 1, u64::MAX]);
    assert_eq!(VALID, Ok(()));
    for bounds in [&[][..], &[0][..], &[u64::MAX][..], &[0, u64::MAX][..]] {
        assert_eq!(validate_histogram_bounds(bounds), Ok(()));
    }
    // Dynamic slices retain the index relative to the supplied bounds.
    let bounds = [9, 10, 20, 20, 30];
    assert_eq!(
        validate_histogram_bounds(&bounds[1..]),
        Err(HistogramBoundsError { index: 2 })
    );
}

#[test]
fn inclusive_bounds_assign_each_sample_to_one_bucket() {
    let mut histogram = MeasurementHistogram::new([10, 20]).unwrap();
    for value in [0, 9, 10, 11, 19, 20, 21, 22] {
        histogram.record(value);
    }
    assert_eq!(histogram.upper_bounds(), &[10, 20]);
    assert_eq!(histogram.bucket_counts(), &[3, 3]);
    assert_eq!(histogram.overflow(), 2);
    assert_eq!(histogram.aggregate().samples(), 8);
    assert_eq!(histogram.aggregate().total(), 112);
    assert_eq!(histogram.aggregate().maximum(), Some(22));
}

#[test]
fn empty_and_measured_zero_are_distinct() {
    let mut histogram = MeasurementHistogram::new([0, 10]).unwrap();
    assert_eq!(histogram.bucket_counts(), &[0, 0]);
    assert_eq!(histogram.overflow(), 0);
    assert_eq!(histogram.aggregate().samples(), 0);
    assert_eq!(histogram.aggregate().maximum(), None);

    histogram.record(0);
    assert_eq!(histogram.bucket_counts(), &[1, 0]);
    assert_eq!(histogram.overflow(), 0);
    assert_eq!(histogram.aggregate().samples(), 1);
    assert_eq!(histogram.aggregate().total(), 0);
    assert_eq!(histogram.aggregate().maximum(), Some(0));
}

#[test]
fn no_bounds_count_all_samples_in_overflow() {
    let mut histogram = MeasurementHistogram::new([]).unwrap();
    for value in [0, 7, u64::MAX] {
        histogram.record(value);
    }
    assert_eq!(histogram.upper_bounds(), &[] as &[u64; 0]);
    assert_eq!(histogram.bucket_counts(), &[] as &[u64; 0]);
    assert_eq!(histogram.overflow(), 3);
    assert_eq!(histogram.aggregate().samples(), 3);
    assert_eq!(histogram.aggregate().total(), u128::from(u64::MAX) + 7);
    assert_eq!(histogram.aggregate().maximum(), Some(u64::MAX));
}

#[test]
fn maximum_bound_includes_maximum_sample() {
    let mut histogram = MeasurementHistogram::new([0, u64::MAX]).unwrap();
    for value in [0, 1, u64::MAX] {
        histogram.record(value);
    }
    assert_eq!(histogram.bucket_counts(), &[1, 2]);
    assert_eq!(histogram.overflow(), 0);
    assert_eq!(histogram.aggregate().samples(), 3);
    assert_eq!(histogram.aggregate().total(), u128::from(u64::MAX) + 1);
}

#[test]
fn overflowed_bucket_does_not_freeze_other_buckets_or_aggregate() {
    let aggregate = MeasurementAggregate::from_parts(
        u64::MAX - 1,
        2 * u128::from(u64::MAX - 1),
        Some(2),
        false,
        false,
    )
    .unwrap();
    let mut histogram = MeasurementHistogram::from_parts(
        [2, 4],
        [u64::MAX - 1, 0],
        0,
        [false; 2],
        false,
        aggregate,
    )
    .unwrap();
    for value in [1, 2, 3, 5] {
        histogram.record(value);
    }
    assert_eq!(histogram.bucket_counts(), &[u64::MAX, 1]);
    assert_eq!(histogram.overflow(), 1);
    assert_eq!(histogram.bucket_overflowed(), &[true, false]);
    assert_eq!(histogram.aggregate().samples(), u64::MAX);
    assert!(histogram.aggregate().samples_overflowed());
    assert_eq!(
        histogram.aggregate().total(),
        2 * u128::from(u64::MAX - 1) + 11
    );
    assert_eq!(histogram.aggregate().maximum(), Some(5));
}

#[test]
fn overflow_bucket_and_total_overflow_do_not_freeze_other_observations() {
    let aggregate = MeasurementAggregate::from_parts(
        u64::MAX,
        u128::from(u64::MAX).pow(2),
        Some(u64::MAX),
        false,
        false,
    )
    .unwrap();
    let mut histogram =
        MeasurementHistogram::from_parts([1], [0], u64::MAX, [false], false, aggregate).unwrap();
    histogram.record(u64::MAX);
    histogram.record(u64::MAX);
    assert!(!histogram.aggregate().total_overflowed());
    histogram.record(u64::MAX);
    assert_eq!(histogram.overflow(), u64::MAX);
    assert_eq!(histogram.aggregate().total(), u128::MAX);
    assert!(histogram.aggregate().total_overflowed());
    histogram.record(u64::MAX);
    histogram.record(1);
    assert_eq!(histogram.bucket_counts(), &[1]);
    assert_eq!(histogram.overflow(), u64::MAX);
    assert_eq!(histogram.aggregate().samples(), u64::MAX);
    assert_eq!(histogram.aggregate().maximum(), Some(u64::MAX));
}

#[test]
fn construction_rejection_and_recording_are_available_in_constant_evaluation() {
    const HISTOGRAM: Result<MeasurementHistogram<2>, HistogramBoundsError> =
        match MeasurementHistogram::new([0, 10]) {
            Ok(mut histogram) => {
                histogram.record(0);
                histogram.record(5);
                histogram.record(11);
                Ok(histogram)
            }
            Err(error) => Err(error),
        };
    const INVALID: Result<MeasurementHistogram<2>, HistogramBoundsError> =
        MeasurementHistogram::new([1, 1]);
    const UNBOUNDED: Result<MeasurementHistogram<0>, HistogramBoundsError> =
        MeasurementHistogram::new([]);

    let histogram = HISTOGRAM.unwrap();
    assert_eq!(histogram.bucket_counts(), &[1, 1]);
    assert_eq!(histogram.overflow(), 1);
    assert_eq!(histogram.aggregate().samples(), 3);
    assert_eq!(histogram.aggregate().total(), 16);
    assert_eq!(INVALID, Err(HistogramBoundsError { index: 1 }));
    assert_eq!(UNBOUNDED.unwrap().aggregate().samples(), 0);
}

#[test]
fn merged_partitions_match_recording_and_reject_different_bounds_atomically() {
    let mut left = MeasurementHistogram::new([0, 10]).unwrap();
    let mut right = left;
    let mut expected = left;
    for (index, value) in [0, 1, 10, 11, u64::MAX, 3].into_iter().enumerate() {
        expected.record(value);
        if index % 2 == 0 {
            left.record(value);
        } else {
            right.record(value);
        }
    }
    let source = right;
    left.merge(&right).unwrap();
    assert_eq!(left, expected);
    assert_eq!(right, source);
    let before = left;
    let mut mismatched = MeasurementHistogram::new([0, 11]).unwrap();
    mismatched.record(2);
    assert_eq!(left.merge(&mismatched).unwrap_err().index(), 1);
    assert_eq!(left, before);
}

#[test]
fn merging_no_bounds_and_exact_value_caps_preserves_overflow_provenance() {
    let mut left = MeasurementHistogram::new([]).unwrap();
    let mut right = left;
    left.record(0);
    right.record(u64::MAX);
    left.merge(&right).unwrap();
    assert_eq!(left.overflow(), 2);
    assert!(!left.overflow_count_overflowed());
    assert_eq!(left.aggregate().samples(), 2);
    left.record(1);
    assert!(!left.aggregate().total_overflowed());
    assert_eq!(left.aggregate().total(), u128::from(u64::MAX) + 1);
    // Distribution-count overflow propagates even into an empty destination.
    let aggregate = MeasurementAggregate::from_parts(
        u64::MAX,
        u128::from(u64::MAX),
        Some(u64::MAX),
        true,
        false,
    )
    .unwrap();
    left = MeasurementHistogram::from_parts([], [], u64::MAX, [], true, aggregate).unwrap();
    let mut destination = MeasurementHistogram::new([]).unwrap();
    destination.merge(&left).unwrap();
    assert!(destination.overflow_count_overflowed());
}

#[test]
fn histogram_merging_supports_constant_evaluation() {
    const MERGED: Result<MeasurementHistogram<1>, super::HistogramMergeError> = {
        let Ok(mut left) = MeasurementHistogram::new([10]) else {
            panic!("test bounds");
        };
        let mut right = left;
        left.record(0);
        right.record(11);
        match left.merge(&right) {
            Ok(()) => Ok(left),
            Err(error) => Err(error),
        }
    };
    let merged = MERGED.unwrap();
    assert_eq!(merged.bucket_counts(), &[1]);
    assert_eq!(merged.overflow(), 1);
    assert_eq!(merged.aggregate().total(), 11);
}

#[test]
fn maximum_count_of_maximum_values_retains_exact_total_and_distribution() {
    let mut histogram = MeasurementHistogram::new([u64::MAX]).unwrap();
    for _ in 0..64 {
        histogram.merge(&histogram.clone()).unwrap();
        histogram.record(u64::MAX);
    }
    assert_eq!(histogram.aggregate().samples(), u64::MAX);
    assert_eq!(histogram.aggregate().total(), u128::from(u64::MAX).pow(2));
    assert_eq!(histogram.bucket_counts(), &[u64::MAX]);
    assert!(!histogram.bucket_overflowed()[0]);
    histogram.record(1);
    assert!(!histogram.aggregate().total_overflowed());
    assert!(histogram.aggregate().samples_overflowed());
    assert!(histogram.bucket_overflowed()[0]);
}
