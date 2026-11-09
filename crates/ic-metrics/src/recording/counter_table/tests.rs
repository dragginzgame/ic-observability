use super::*;
use alloc::{string::String, vec::Vec};

fn limits() -> MeasurementTableLimits {
    MeasurementTableLimits {
        entries: 2,
        key_bytes: 4,
        total_key_bytes: 5,
    }
}

#[derive(Debug, Eq, Ord, PartialEq, PartialOrd)]
struct TargetMethod {
    target: u64,
    method: String,
}

#[test]
fn typed_counters_use_original_scalar_units_and_first_admission() {
    let mut table = BoundedCounterTable::new(limits());
    let key = |target, method: &str| TargetMethod {
        target,
        method: method.into(),
    };
    table.add(key(2, "é"), 2, u128::from(u64::MAX) + 1);
    table.add(key(1, "rpc"), 3, 0);
    assert_eq!(
        table.add(key(0, "a"), 1, 7),
        MeasurementAttribution::Omitted(MeasurementOmission::Entries)
    );
    assert_eq!(
        table.add(key(2, "é"), 2, 1),
        MeasurementAttribution::Retained
    );
    let rows = table.entries().collect::<Vec<_>>();
    assert_eq!(rows[0].0.target, 1);
    assert_eq!(rows[0].1, MeasurementCounter::ZERO);
    assert_eq!(rows[1].1.total(), u128::from(u64::MAX) + 2);
    assert!(!rows[1].1.total_overflowed());
    assert_eq!(table.omitted().exact_total(), Ok(7));
    assert_eq!(table.retained_key_bytes(), 5);
}

#[test]
fn typed_counter_budget_refusals_and_borrowed_updates_count_once() {
    let mut table = BoundedCounterTable::<String>::new(limits());
    assert!(!table.add_existing("missing", 10));
    assert_eq!(table.omitted(), MeasurementCounter::ZERO);
    table.add("four".into(), 4, 1);
    assert_eq!(
        table.add("é".into(), 2, 2),
        MeasurementAttribution::Omitted(MeasurementOmission::TotalKeyBytes)
    );
    assert_eq!(
        table.add("large".into(), 5, 3),
        MeasurementAttribution::Omitted(MeasurementOmission::KeyBytes)
    );
    assert!(table.add_existing("four", 4));
    assert_eq!(table.entries().next().unwrap().1.exact_total(), Ok(5));
    assert_eq!(table.omitted().exact_total(), Ok(5));
    assert_eq!(table.retained_key_bytes(), 4);
}

#[test]
fn typed_counter_exact_caps_overflow_and_clear() {
    let mut table = BoundedCounterTable::new(limits());
    table.add(1, 1, u128::MAX);
    assert!(!table.entries().next().unwrap().1.total_overflowed());
    table.add_existing(&1, 1);
    assert!(table.entries().next().unwrap().1.total_overflowed());
    table.add(2, 1, 0);
    table.add(3, 1, u128::MAX);
    assert!(!table.omitted().total_overflowed());
    table.add(4, 1, 0);
    assert!(!table.omitted().total_overflowed());
    table.add(4, 1, 1);
    assert!(table.omitted().total_overflowed());
    table.clear();
    assert_eq!(table.limits(), limits());
    assert_eq!(table.retained_key_bytes(), 0);
    assert_eq!(table.omitted(), MeasurementCounter::ZERO);
    assert_eq!(table.entries().len(), 0);
}

#[test]
fn typed_counter_zero_budgets_and_usize_max_are_admitted_without_wrapping() {
    let mut table = BoundedCounterTable::new(MeasurementTableLimits {
        entries: 0,
        key_bytes: 0,
        total_key_bytes: 0,
    });
    assert_eq!(
        table.add(0, 0, 1),
        MeasurementAttribution::Omitted(MeasurementOmission::Entries)
    );
    let mut table = BoundedCounterTable::new(MeasurementTableLimits {
        entries: 3,
        key_bytes: usize::MAX,
        total_key_bytes: usize::MAX,
    });
    table.add(0, usize::MAX, 1);
    table.add(1, 0, 1);
    assert_eq!(
        table.add(2, 1, 1),
        MeasurementAttribution::Omitted(MeasurementOmission::TotalKeyBytes)
    );
    assert_eq!(table.retained_key_bytes(), usize::MAX);
}

#[test]
fn typed_counters_match_independent_first_admission_and_scalar_conservation() {
    for capacity in 0..4 {
        for budget in 0..7 {
            let limits = MeasurementTableLimits {
                entries: capacity,
                key_bytes: 3,
                total_key_bytes: budget,
            };
            let mut table = BoundedCounterTable::new(limits);
            let mut admitted = Vec::<(u8, usize, u128)>::new();
            let mut omitted = 0;
            let mut total = 0;
            for turn in 0..100u8 {
                let key = ((turn % 9) * 7) % 9;
                let charge = usize::from(key % 5);
                let amount = u128::from(turn) * u128::from(turn);
                total += amount;
                let used: usize = admitted.iter().map(|(_, bytes, _)| bytes).sum();
                let existing = admitted.iter_mut().find(|(k, _, _)| *k == key);
                let expected = if charge > 3 {
                    MeasurementAttribution::Omitted(MeasurementOmission::KeyBytes)
                } else if let Some((_, _, counter)) = existing {
                    *counter += amount;
                    MeasurementAttribution::Retained
                } else if admitted.len() >= capacity {
                    MeasurementAttribution::Omitted(MeasurementOmission::Entries)
                } else if used + charge > budget {
                    MeasurementAttribution::Omitted(MeasurementOmission::TotalKeyBytes)
                } else {
                    admitted.push((key, charge, amount));
                    MeasurementAttribution::Retained
                };
                if matches!(expected, MeasurementAttribution::Omitted(_)) {
                    omitted += amount;
                }
                assert_eq!(table.add(key, charge, amount), expected);
                for (key, actual) in table.entries() {
                    assert_eq!(
                        actual.total(),
                        admitted.iter().find(|(k, _, _)| k == key).unwrap().2
                    );
                    assert!(!actual.total_overflowed());
                }
                assert_eq!(table.omitted().total(), omitted);
                assert_eq!(
                    table.retained_key_bytes(),
                    admitted.iter().map(|(_, bytes, _)| bytes).sum()
                );
                assert_eq!(
                    table
                        .entries()
                        .map(|(_, value)| value.total())
                        .sum::<u128>()
                        + omitted,
                    total
                );
            }
        }
    }
}
