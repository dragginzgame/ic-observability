use super::*;
use alloc::{string::String, vec::Vec};

#[derive(Debug, Eq, PartialEq)]
struct Diagnostic {
    time_ns: u64,
    code: u32,
    text: String,
    redacted: bool,
}

fn row(time_ns: u64, text: &str) -> Diagnostic {
    Diagnostic {
        time_ns,
        code: 17,
        text: text.into(),
        redacted: true,
    }
}

#[test]
fn history_preserves_nonclone_structured_rows_and_consumer_time_order() {
    let mut history = BoundedHistory::new(HistoryLimits {
        entries: 2,
        payload_bytes: 8,
    });
    history.append(row(9_000_000_001, "é"), 2).unwrap();
    history.append(row(1, "next"), 4).unwrap();
    assert_eq!(history.entries().len(), 2);
    let latest = history.entries().next_back().unwrap();
    assert_eq!(latest.time_ns, 1);
    assert_eq!(latest.code, 17);
    assert_eq!(latest.text, "next");
    assert!(latest.redacted);
    let receipt = history.append(row(3, "last"), 4).unwrap();
    assert_eq!(
        receipt,
        HistoryAppend {
            evicted: 1,
            evicted_payload_bytes: 2
        }
    );
    assert_eq!(history.retained_payload_bytes(), 8);
    assert_eq!(
        history
            .entries()
            .rev()
            .map(|r| r.time_ns)
            .collect::<Vec<_>>(),
        [3, 1]
    );
}

#[test]
fn history_byte_pressure_evicts_multiple_rows_but_refusal_is_transactional() {
    let mut history = BoundedHistory::new(HistoryLimits {
        entries: 4,
        payload_bytes: 6,
    });
    for i in 0..3 {
        history.append(row(i, "é"), 2).unwrap();
    }
    let refused = history.append(row(8, "large"), 7).unwrap_err();
    assert_eq!(refused.value, row(8, "large"));
    assert_eq!(
        refused.reason,
        HistoryRejectionReason::PayloadTooLarge {
            supplied: 7,
            maximum: 6
        }
    );
    assert_eq!(history.entries().len(), 3);
    assert_eq!(history.retained_payload_bytes(), 6);
    assert_eq!(
        history.append(row(9, "four"), 4).unwrap(),
        HistoryAppend {
            evicted: 2,
            evicted_payload_bytes: 4
        }
    );
    assert_eq!(
        history.entries().map(|r| r.time_ns).collect::<Vec<_>>(),
        [2, 9]
    );
}

#[test]
fn history_zero_limits_exact_usize_boundary_and_clear() {
    let mut disabled = BoundedHistory::new(HistoryLimits {
        entries: 0,
        payload_bytes: 0,
    });
    let refused = disabled.append(17, 0).unwrap_err();
    assert_eq!(refused.reason, HistoryRejectionReason::Disabled);
    assert_eq!(refused.value, 17);
    assert_eq!(disabled.entries().len(), 0);
    let mut empty = BoundedHistory::new(HistoryLimits {
        entries: 1,
        payload_bytes: 0,
    });
    empty.append(1, 0).unwrap();
    assert_eq!(empty.append(2, 0).unwrap().evicted, 1);
    assert!(empty.append(3, 1).is_err());

    let limits = HistoryLimits {
        entries: 2,
        payload_bytes: usize::MAX,
    };
    let mut huge = BoundedHistory::new(limits);
    huge.append(1, usize::MAX).unwrap();
    huge.append(2, 0).unwrap();
    assert_eq!(
        huge.append(3, usize::MAX).unwrap().evicted_payload_bytes,
        usize::MAX
    );
    assert_eq!(huge.retained_payload_bytes(), usize::MAX);
    huge.clear();
    assert_eq!(huge.limits(), limits);
    assert_eq!(huge.retained_payload_bytes(), 0);
    assert_eq!(huge.entries().len(), 0);
    assert_eq!(huge.append(4, 0).unwrap(), HistoryAppend::default());
}

#[test]
fn history_matches_independent_prefix_eviction_model() {
    for capacity in 0..5 {
        for budget in 0..8 {
            let limits = HistoryLimits {
                entries: capacity,
                payload_bytes: budget,
            };
            let mut history = BoundedHistory::new(limits);
            let mut model = Vec::new();
            for id in 0..100usize {
                let charge = (id * 7 + 3) % 10;
                if capacity == 0 || charge > budget {
                    assert!(history.append(id, charge).is_err());
                } else {
                    model.push((id, charge));
                    let mut evicted = Vec::new();
                    while model.len() > capacity
                        || model.iter().map(|(_, n)| n).sum::<usize>() > budget
                    {
                        evicted.push(model.remove(0));
                    }
                    let receipt = history.append(id, charge).unwrap();
                    assert_eq!(receipt.evicted, evicted.len());
                    assert_eq!(
                        receipt.evicted_payload_bytes,
                        evicted.iter().map(|(_, n)| n).sum()
                    );
                }
                assert_eq!(
                    history.entries().copied().collect::<Vec<_>>(),
                    model.iter().map(|(id, _)| *id).collect::<Vec<_>>()
                );
                assert_eq!(
                    history.retained_payload_bytes(),
                    model.iter().map(|(_, n)| n).sum()
                );
            }
        }
    }
}
