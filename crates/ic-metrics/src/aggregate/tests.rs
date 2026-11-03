mod restoration;

use super::*;

fn aggregate(values: &[u64]) -> MeasurementAggregate {
    let mut result = MeasurementAggregate::EMPTY;
    for &value in values {
        result.record(value);
    }
    result
}

#[test]
fn exact_caps_and_actual_overflow_have_distinct_quality() {
    let mut result = aggregate(&[u64::MAX]);
    result.record(0);
    result.record(1);
    assert_eq!(result.samples(), 3);
    assert_eq!(result.total(), u128::from(u64::MAX) + 1);
    assert!(!result.total_overflowed());
    assert_eq!(result.maximum(), Some(u64::MAX));

    let mut largest_batch = MeasurementAggregate::EMPTY;
    for _ in 0..64 {
        largest_batch.merge(largest_batch);
        largest_batch.record(u64::MAX);
    }
    assert_eq!(largest_batch.samples(), u64::MAX);
    assert_eq!(largest_batch.total(), u128::from(u64::MAX).pow(2));
    assert!(!largest_batch.samples_overflowed());
    assert!(!largest_batch.total_overflowed());
    largest_batch.record(u64::MAX);
    largest_batch.record(u64::MAX);
    assert_eq!(largest_batch.total(), u128::MAX);
    assert!(largest_batch.samples_overflowed());
    assert!(!largest_batch.total_overflowed());
    largest_batch.record(0);
    assert!(!largest_batch.total_overflowed());
    largest_batch.record(1);
    assert!(largest_batch.total_overflowed());
    assert_eq!(largest_batch.total(), u128::MAX);
    let mut inherited = MeasurementAggregate::EMPTY;
    inherited.merge(largest_batch);
    assert_eq!(inherited, largest_batch);
    result.merge(largest_batch);
    assert!(result.samples_overflowed());
    assert!(result.total_overflowed());
    result.merge(MeasurementAggregate::EMPTY);
    assert!(result.total_overflowed());

    let mut count = MeasurementAggregate::EMPTY;
    for _ in 0..64 {
        count.merge(count);
        count.record(0);
    }
    assert_eq!(count.samples(), u64::MAX);
    assert!(!count.samples_overflowed());
    count.record(0);
    assert!(count.samples_overflowed());
    let mut empty = MeasurementAggregate::EMPTY;
    empty.merge(count);
    assert_eq!(empty, count);
}

#[test]
fn merge_is_additive_commutative_associative_and_preserves_empty_zero() {
    let empty = MeasurementAggregate::EMPTY;
    assert_eq!(empty, MeasurementAggregate::default());
    assert_eq!(empty.samples(), 0);
    assert_eq!(empty.maximum(), None);
    assert_eq!(aggregate(&[0]).samples(), 1);
    assert_eq!(aggregate(&[0]).maximum(), Some(0));
    for values in [&[0, 2, 9][..], &[u64::MAX, 0, 1][..]] {
        let a = aggregate(&values[..1]);
        let b = aggregate(&values[1..2]);
        let c = aggregate(&values[2..]);
        let mut forward = a;
        forward.merge(b);
        let mut reverse = b;
        reverse.merge(a);
        assert_eq!(forward, reverse);
        forward.merge(c);
        let mut tail = b;
        tail.merge(c);
        let mut grouped = a;
        grouped.merge(tail);
        assert_eq!(forward, grouped);
        assert_eq!(forward, aggregate(values));
        forward.merge(empty);
        assert_eq!(forward, grouped);
    }
    let mut duplicate = aggregate(&[3]);
    duplicate.merge(duplicate);
    assert_eq!((duplicate.samples(), duplicate.total()), (2, 6));
}

#[test]
fn recording_and_merging_support_constant_evaluation() {
    const RESULT: MeasurementAggregate = {
        let mut left = MeasurementAggregate::EMPTY;
        left.record(0);
        let mut right = MeasurementAggregate::EMPTY;
        right.record(7);
        left.merge(right);
        left
    };
    assert_eq!(RESULT, aggregate(&[0, 7]));
}
