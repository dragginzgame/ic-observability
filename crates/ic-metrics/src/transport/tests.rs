//! Validated Serde records with exact numeric admission.

extern crate std;

use super::*;
use std::{fmt::Debug, vec::Vec};

#[derive(Debug, PartialEq, Serialize, Deserialize)]
struct Report {
    aggregate: MeasurementAggregate,
    counter: MeasurementCounter,
    summary: MeasurementSummary,
    histogram: MeasurementHistogram<37>,
}

// Exercise the canonical numeric records without a schema or codec supplier.
fn reports() -> Vec<(&'static str, Report)> {
    [
        ("empty", 0, 0, None, false),
        ("zero", 1, 0, Some(0), false),
        ("wide", 2, 2 * u128::from(u64::MAX), Some(u64::MAX), false),
        (
            "cap",
            u64::MAX,
            u128::from(u64::MAX).pow(2),
            Some(u64::MAX),
            false,
        ),
        ("lost", u64::MAX, u128::MAX, Some(u64::MAX), true),
    ]
    .into_iter()
    .map(|(name, samples, total, maximum, lost)| {
        let aggregate =
            MeasurementAggregate::from_parts(samples, total, maximum, lost, lost).unwrap();
        let mut counts = [0; 37];
        let overflow = if name == "zero" {
            counts[0] = 1;
            0
        } else {
            samples
        };
        let report = Report {
            aggregate,
            counter: MeasurementCounter::from_parts(if samples > 1 { u128::MAX } else { 0 }, lost)
                .unwrap(),
            summary: MeasurementSummary::from_parts(aggregate, maximum).unwrap(),
            histogram: MeasurementHistogram::from_parts(
                core::array::from_fn(|index| index as u64),
                counts,
                overflow,
                [false; 37],
                lost,
                aggregate,
            )
            .unwrap(),
        };
        (name, report)
    })
    .collect()
}

fn round_trip<T: Serialize + serde::de::DeserializeOwned + Debug + PartialEq>(value: &T) {
    // Text serialization preserves u128 exactly; a serde_json::Value intermediary
    // would narrow these numbers without the arbitrary_precision feature.
    let json = serde_json::to_string(value).unwrap();
    assert_eq!(serde_json::from_str::<T>(&json).unwrap(), *value);
}

#[test]
fn serde_preserves_empty_zero_wide_caps_and_loss_without_metadata() {
    for (_, report) in reports() {
        round_trip(&report);
    }
}

fn histogram_round_trip<const N: usize>(bounds: [u64; N]) {
    let mut histogram = MeasurementHistogram::new(bounds).unwrap();
    for sample in [0, 1, 10, 100, u64::MAX] {
        histogram.record(sample);
    }
    round_trip(&histogram);
}

#[test]
fn serde_arrays_keep_zero_small_and_large_const_bounds() {
    histogram_round_trip([]);
    histogram_round_trip([0, 10, u64::MAX]);
    histogram_round_trip(core::array::from_fn::<_, 37, _>(|index| index as u64));
    for json in ["[1]", "[1,2,3]"] {
        assert!(
            serde_json::from_str::<FixedArray<u64, 2>>(json)
                .err()
                .unwrap()
                .is_data()
        );
    }
    let mut fields = serde_json::to_value(MeasurementHistogram::new([10, 20]).unwrap()).unwrap();
    fields["bucket_counts"] = serde_json::json!([0]);
    assert!(
        serde_json::from_value::<MeasurementHistogram<2>>(fields)
            .unwrap_err()
            .is_data()
    );
}

fn rejects<S: Serialize, T: serde::de::DeserializeOwned>(fields: &S) {
    let json = serde_json::to_string(fields).unwrap();
    let error = serde_json::from_str::<T>(&json)
        .err()
        .expect("invalid state must refuse");
    assert!(error.is_data());
}

#[test]
fn serde_decode_requires_canonical_numeric_admission() {
    rejects::<_, MeasurementAggregate>(&AggregateFields {
        samples: 1,
        total: 2,
        maximum: Some(1),
        samples_overflowed: false,
        total_overflowed: false,
    });
    rejects::<_, MeasurementCounter>(&CounterFields {
        total: 1,
        total_overflowed: true,
    });
    let aggregate = MeasurementAggregate::from_parts(1, 5, Some(5), false, false).unwrap();
    rejects::<_, MeasurementSummary>(&SummaryFields {
        aggregate,
        latest: Some(6),
    });
    rejects::<_, MeasurementHistogram<2>>(&HistogramFields {
        upper_bounds: FixedArray([10, 20]),
        bucket_counts: FixedArray([0, 1]),
        overflow: 0,
        bucket_overflowed: FixedArray([false; 2]),
        overflow_count_overflowed: false,
        aggregate,
    });
}

#[test]
fn serde_rejects_missing_and_unknown_record_fields() {
    for json in [
        r#"{"total":0}"#,
        r#"{"total":0,"total_overflowed":false,"other":0}"#,
    ] {
        assert!(
            serde_json::from_str::<MeasurementCounter>(json)
                .unwrap_err()
                .is_data()
        );
    }
}

#[test]
fn serde_record_order_and_numeric_representations_are_stable() {
    let aggregate = MeasurementAggregate::from_parts(1, 9, Some(9), false, false).unwrap();
    assert_eq!(
        serde_json::to_string(&aggregate).unwrap(),
        r#"{"samples":1,"total":9,"maximum":9,"samples_overflowed":false,"total_overflowed":false}"#
    );
    for lost in [false, true] {
        let counter = MeasurementCounter::from_parts(u128::MAX, lost).unwrap();
        let expected = if lost {
            r#"{"total":340282366920938463463374607431768211455,"total_overflowed":true}"#
        } else {
            r#"{"total":340282366920938463463374607431768211455,"total_overflowed":false}"#
        };
        assert_eq!(serde_json::to_string(&counter).unwrap(), expected);
        assert_eq!(
            serde_json::from_str::<MeasurementCounter>(expected).unwrap(),
            counter
        );
    }
    let summary = MeasurementSummary::from_parts(aggregate, Some(9)).unwrap();
    assert_eq!(
        serde_json::to_string(&summary).unwrap(),
        r#"{"aggregate":{"samples":1,"total":9,"maximum":9,"samples_overflowed":false,"total_overflowed":false},"latest":9}"#
    );
    let mut histogram = MeasurementHistogram::new([10, 20]).unwrap();
    histogram.record(0);
    histogram.record(11);
    assert_eq!(
        serde_json::to_string(&histogram).unwrap(),
        r#"{"upper_bounds":[10,20],"bucket_counts":[1,1],"overflow":0,"bucket_overflowed":[false,false],"overflow_count_overflowed":false,"aggregate":{"samples":2,"total":11,"maximum":11,"samples_overflowed":false,"total_overflowed":false}}"#
    );
}

#[test]
fn malformed_records_preserve_all_numeric_admission_boundaries() {
    for fields in [
        AggregateFields {
            samples: 0,
            total: 1,
            maximum: None,
            samples_overflowed: false,
            total_overflowed: false,
        },
        AggregateFields {
            samples: 1,
            total: 1,
            maximum: None,
            samples_overflowed: false,
            total_overflowed: false,
        },
        AggregateFields {
            samples: 1,
            total: 1,
            maximum: Some(1),
            samples_overflowed: true,
            total_overflowed: false,
        },
    ] {
        rejects::<_, MeasurementAggregate>(&fields);
    }
    rejects::<_, MeasurementSummary>(&SummaryFields {
        aggregate: MeasurementAggregate::EMPTY,
        latest: Some(0),
    });
    for (bounds, counts, lost, aggregate) in [
        ([10, 10], [0, 0], [false; 2], MeasurementAggregate::EMPTY),
        ([10, 20], [1, 0], [false; 2], MeasurementAggregate::EMPTY),
        (
            [10, 20],
            [1, 0],
            [true, false],
            MeasurementAggregate::from_parts(1, 5, Some(5), false, false).unwrap(),
        ),
        (
            [10, 20],
            [1, 0],
            [false; 2],
            MeasurementAggregate::from_parts(1, 11, Some(11), false, false).unwrap(),
        ),
    ] {
        rejects::<_, MeasurementHistogram<2>>(&HistogramFields {
            upper_bounds: FixedArray(bounds),
            bucket_counts: FixedArray(counts),
            overflow: 0,
            bucket_overflowed: FixedArray(lost),
            overflow_count_overflowed: false,
            aggregate,
        });
    }
}
