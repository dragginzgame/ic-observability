use super::*;
use alloc::{string::String, vec::Vec};

fn limits() -> MeasurementTableLimits {
    MeasurementTableLimits {
        entries: 2,
        key_bytes: 4,
        total_key_bytes: 8,
    }
}

#[test]
fn lexical_retention_merges_complete_evicted_history_and_rejections_once() {
    let mut table = LexicalMeasurementTable::<String>::new(limits()).unwrap();
    table.record("zz".into(), 2, 0);
    table.record_existing("zz", u64::MAX);
    table.record("y".into(), 1, 3);
    table.record("b".into(), 1, 5);
    assert_eq!(table.omitted().samples(), 2);
    assert_eq!(table.omitted().total(), u128::from(u64::MAX));
    assert_eq!(table.omitted().maximum(), Some(u64::MAX));
    table.record("a".into(), 1, 7);
    assert_eq!(
        table.record("z".into(), 1, 11),
        MeasurementAttribution::Omitted(MeasurementOmission::Entries)
    );
    assert_eq!(
        table.record("large".into(), 5, 0),
        MeasurementAttribution::Omitted(MeasurementOmission::KeyBytes)
    );
    assert!(!table.record_existing("missing", 100));
    assert!(table.record_existing("a", 0));
    let rows = table.entries().collect::<Vec<_>>();
    assert_eq!(
        rows.iter().map(|(k, _)| k.as_str()).collect::<Vec<_>>(),
        ["a", "b"]
    );
    assert_eq!(table.retained_key_bytes(), 2);
    assert_eq!(table.omitted().samples(), 5);
    let mut total = table.omitted();
    for (_, aggregate) in rows {
        total.merge(aggregate);
    }
    assert_eq!(total.samples(), 8);
    assert_eq!(total.total(), u128::from(u64::MAX) + 26);
    assert_eq!(total.maximum(), Some(u64::MAX));
}

#[test]
fn lexical_eviction_preserves_actual_overflow_quality() {
    let mut table = LexicalMeasurementTable::new(limits()).unwrap();
    table.record(3, 1, 0);
    table.record(2, 1, 0);
    let overflowed =
        MeasurementAggregate::from_parts(u64::MAX, u128::MAX, Some(u64::MAX), true, true).unwrap();
    table.entries.get_mut(&3).unwrap().1 = overflowed;
    table.record(1, 1, 0);
    assert_eq!(table.omitted(), overflowed);
    table.record(4, 1, 0);
    assert!(table.omitted().samples_overflowed());
    assert!(table.omitted().total_overflowed());
    table.clear();
    assert_eq!(table.limits(), limits());
    assert_eq!(table.retained_key_bytes(), 0);
    assert_eq!(table.entries().len(), 0);
    assert_eq!(table.omitted(), MeasurementAggregate::EMPTY);
}

#[test]
fn lexical_limits_refuse_weighted_pressure_and_overflow_before_construction() {
    let too_small = MeasurementTableLimits {
        total_key_bytes: 7,
        ..limits()
    };
    assert!(matches!(
        LexicalMeasurementTable::<u8>::new(too_small),
        Err(LexicalTableLimitsError::KeyBudgetTooSmall)
    ));
    let overflow = MeasurementTableLimits {
        entries: 2,
        key_bytes: usize::MAX,
        total_key_bytes: usize::MAX,
    };
    assert!(matches!(
        LexicalMeasurementTable::<u8>::new(overflow),
        Err(LexicalTableLimitsError::KeyBudgetOverflow)
    ));
    let mut table = LexicalMeasurementTable::new(MeasurementTableLimits {
        entries: 1,
        key_bytes: usize::MAX,
        total_key_bytes: usize::MAX,
    })
    .unwrap();
    table.record(2, usize::MAX, 1);
    table.record(1, 0, 0);
    assert_eq!(table.retained_key_bytes(), 0);
    assert_eq!(table.omitted().total(), 1);
    let mut disabled = LexicalMeasurementTable::new(MeasurementTableLimits {
        entries: 0,
        key_bytes: 0,
        total_key_bytes: 0,
    })
    .unwrap();
    assert_eq!(
        disabled.record(1, 0, 0),
        MeasurementAttribution::Omitted(MeasurementOmission::Entries)
    );
    assert_eq!(disabled.omitted().samples(), 1);
}

fn permutations(values: &mut [u8], at: usize, output: &mut Vec<Vec<u8>>) {
    if at == values.len() {
        output.push(values.to_vec());
    } else {
        for i in at..values.len() {
            values.swap(at, i);
            permutations(values, at + 1, output);
            values.swap(at, i);
        }
    }
}

#[test]
fn lexical_all_arrival_orders_match_independent_observation_oracle() {
    let mut orders = Vec::new();
    permutations(&mut [0, 1, 2, 3, 4], 0, &mut orders);
    for capacity in 0..=5 {
        for order in &orders {
            let limits = MeasurementTableLimits {
                entries: capacity,
                key_bytes: 4,
                total_key_bytes: capacity * 4,
            };
            let mut table = LexicalMeasurementTable::new(limits).unwrap();
            let mut seen = [false; 5];
            let mut all = Vec::new();
            for &key in order {
                seen[usize::from(key)] = true;
                for sample in [0, u64::from(key) * 11, u64::MAX] {
                    table.record(key, usize::from(key), sample);
                    all.push((key, sample));
                }
                let expected: Vec<_> = (0..5u8)
                    .filter(|k| seen[usize::from(*k)])
                    .take(capacity)
                    .collect();
                assert_eq!(
                    table.entries().map(|(k, _)| *k).collect::<Vec<_>>(),
                    expected
                );
                for (&retained, actual) in table.entries() {
                    let samples: Vec<_> = all
                        .iter()
                        .filter(|(k, _)| *k == retained)
                        .map(|(_, v)| *v)
                        .collect();
                    assert_eq!(actual.samples(), u64::try_from(samples.len()).unwrap());
                    assert_eq!(actual.total(), samples.iter().map(|v| u128::from(*v)).sum());
                    assert_eq!(actual.maximum(), samples.iter().copied().max());
                }
                let omitted: Vec<_> = all
                    .iter()
                    .filter(|(k, _)| !expected.contains(k))
                    .map(|(_, v)| *v)
                    .collect();
                assert_eq!(
                    table.omitted().samples(),
                    u64::try_from(omitted.len()).unwrap()
                );
                assert_eq!(
                    table.omitted().total(),
                    omitted.iter().map(|v| u128::from(*v)).sum()
                );
                assert_eq!(table.omitted().maximum(), omitted.iter().copied().max());
            }
        }
    }
}
