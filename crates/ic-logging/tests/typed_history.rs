//! External typed-history composition without a payload codec or Clone requirement.

use ic_logging::{BoundedHistory, HistoryLimits, HistoryRejectionReason};

#[derive(Debug, PartialEq)]
struct Failure {
    occurred_at_ns: u64,
    correlation: Option<u64>,
    redacted: bool,
}

#[test]
fn external_structured_history_preserves_payload_without_time_or_schema_policy() {
    let mut history = BoundedHistory::new(HistoryLimits {
        entries: 2,
        payload_bytes: 8,
    });
    for (occurred_at_ns, correlation) in [(9, None), (1, Some(7)), (1, Some(8))] {
        history
            .append(
                Failure {
                    occurred_at_ns,
                    correlation,
                    redacted: true,
                },
                4,
            )
            .unwrap();
    }
    let rows: Vec<_> = history.entries().rev().collect();
    assert_eq!(rows[0].correlation, Some(8));
    assert_eq!(rows[1].correlation, Some(7));
    assert_eq!(rows[0].occurred_at_ns, 1);
    assert!(rows.iter().all(|row| row.redacted));
    let rejected = history
        .append(
            Failure {
                occurred_at_ns: 99,
                correlation: None,
                redacted: false,
            },
            9,
        )
        .unwrap_err();
    assert!(matches!(
        rejected.reason,
        HistoryRejectionReason::PayloadTooLarge { .. }
    ));
    assert_eq!(rejected.value.occurred_at_ns, 99);
    assert_eq!(history.entries().len(), 2);
}
