//! Recompute admission from the event journal without the engine's map/cache.

extern crate std;

use crate::{
    BoundedMeasurementTable, MeasurementAggregate, MeasurementAttribution, MeasurementOmission,
    MeasurementTableLimits, MeasurementWindow,
};
use std::vec::Vec;

#[derive(Default)]
struct Model {
    retained: Vec<(&'static str, Vec<u64>)>,
    omitted: Vec<u64>,
    last: Option<MeasurementAttribution>,
}

fn replay(limits: MeasurementTableLimits, history: &[(&'static str, u64)]) -> Model {
    let mut model = Model::default();
    for &(key, observation) in history {
        let existing = model
            .retained
            .iter()
            .position(|(retained, _)| *retained == key);
        let bytes: usize = model.retained.iter().map(|(key, _)| key.len()).sum();
        let refusal = [
            (key.len() > limits.key_bytes, MeasurementOmission::KeyBytes),
            (
                existing.is_none() && model.retained.len() == limits.entries,
                MeasurementOmission::Entries,
            ),
            (
                existing.is_none() && bytes + key.len() > limits.total_key_bytes,
                MeasurementOmission::TotalKeyBytes,
            ),
        ]
        .into_iter()
        .find_map(|(fails, reason)| fails.then_some(reason));
        if let Some(reason) = refusal {
            model.omitted.push(observation);
            model.last = Some(MeasurementAttribution::Omitted(reason));
        } else {
            let index = existing.unwrap_or_else(|| {
                model.retained.push((key, Vec::new()));
                model.retained.len() - 1
            });
            model.retained[index].1.push(observation);
            model.last = Some(MeasurementAttribution::Retained);
        }
    }
    model
}

fn check_aggregate(actual: MeasurementAggregate, observations: &[u64]) {
    assert_eq!(actual.samples(), u64::try_from(observations.len()).unwrap());
    assert_eq!(
        actual.total(),
        observations.iter().map(|&x| u128::from(x)).sum::<u128>()
    );
    assert_eq!(actual.maximum(), observations.iter().copied().max());
    // These bounded histories fit u64 counts and u128 totals even with MAX inputs.
    assert!(!actual.samples_overflowed());
    assert!(!actual.total_overflowed());
}

fn check_table(actual: &BoundedMeasurementTable, model: &Model, limits: MeasurementTableLimits) {
    assert_eq!(actual.limits(), limits);
    assert_eq!(actual.entries().len(), model.retained.len());
    assert_eq!(
        actual.retained_key_bytes(),
        model
            .retained
            .iter()
            .map(|(key, _)| key.len())
            .sum::<usize>()
    );
    for (key, aggregate) in actual.entries() {
        let observations = &model
            .retained
            .iter()
            .find(|(name, _)| *name == key)
            .unwrap()
            .1;
        check_aggregate(aggregate, observations);
    }
    check_aggregate(actual.omitted(), &model.omitted);
}

#[test]
fn mixed_record_clear_and_window_reset_match_event_journal() {
    const KEYS: [&str; 8] = ["", "a", "bb", "é", "éé", "中", "🙂", "oversized"];
    let mut seen_omissions = [false; 3];
    for entries in [0, 1, 3] {
        for key_bytes in [0, 1, 3, 4, 8] {
            for total_key_bytes in [0, 1, 4, 5, 9] {
                let limits = MeasurementTableLimits {
                    entries,
                    key_bytes,
                    total_key_bytes,
                };
                for seed in [0_u64, 1, 0xdead_beef, u64::MAX] {
                    std::eprintln!("recording limits={limits:?}, seed={seed}");
                    let mut window = MeasurementWindow::new(BoundedMeasurementTable::new(limits));
                    let mut history = Vec::new();
                    let mut sequence = 0;
                    let mut state = seed;
                    for _ in 0..128 {
                        state = state
                            .wrapping_mul(6_364_136_223_846_793_005)
                            .wrapping_add(1);
                        let result = match state & 15 {
                            0 => {
                                window.state_mut().clear();
                                history.clear();
                                None
                            }
                            1 => {
                                window.reset(BoundedMeasurementTable::new(limits));
                                sequence += 1;
                                history.clear();
                                None
                            }
                            _ => {
                                let key = KEYS[usize::try_from((state >> 8) % 8).unwrap()];
                                let observation = match (state >> 16) % 3 {
                                    0 => 0,
                                    1 => u64::MAX,
                                    _ => state,
                                };
                                history.push((key, observation));
                                Some(window.state_mut().record(key, observation))
                            }
                        };
                        let model = replay(limits, &history);
                        if let Some(result) = result {
                            assert_eq!(Some(result), model.last);
                            if let MeasurementAttribution::Omitted(reason) = result {
                                let index = match reason {
                                    MeasurementOmission::KeyBytes => 0,
                                    MeasurementOmission::Entries => 1,
                                    MeasurementOmission::TotalKeyBytes => 2,
                                };
                                seen_omissions[index] = true;
                            }
                        }
                        check_table(window.state(), &model, limits);
                        assert_eq!(window.sequence(), Some(sequence));
                    }
                }
            }
        }
    }
    assert_eq!(seen_omissions, [true; 3]);
}
