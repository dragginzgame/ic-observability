//! Application-owned composition; neither library depends on the other.

use ic_logging::{AppendError, AppendReceipt, EntryInput, Level, Limits, Log};
use ic_metrics::{MeasurementCounter, MeasurementWindow};
use std::num::NonZeroUsize;

#[derive(Debug, Default)]
struct Diagnostics {
    accepted: MeasurementCounter,
    truncated: MeasurementCounter,
    evicted: MeasurementCounter,
    refused: MeasurementCounter,
}

fn append(
    log: &mut Log,
    metrics: &mut Diagnostics,
    input: EntryInput<'_>,
) -> Result<AppendReceipt, AppendError> {
    let result = log.append(input);
    match &result {
        Ok(receipt) => {
            metrics.accepted.add(1);
            metrics.evicted.add(receipt.evicted as u128);
            if receipt.truncated {
                metrics.truncated.add(1);
            }
        }
        Err(_) => metrics.refused.add(1),
    }
    result
}

fn entry(created_at_secs: u64, message: &str) -> EntryInput<'_> {
    EntryInput {
        created_at_secs,
        level: Level::Info,
        source: "worker",
        topic: Some("delivery"),
        message,
    }
}

fn main() {
    let mut log = Log::new(Limits {
        max_entries: NonZeroUsize::new(2).expect("positive capacity"),
        max_message_bytes: 8,
        max_label_bytes: 16,
        max_text_bytes: 64,
    });
    let mut window = MeasurementWindow::new(Diagnostics::default());
    append(&mut log, window.state_mut(), entry(10, "accepted")).unwrap();
    append(&mut log, window.state_mut(), entry(11, "a long message")).unwrap();
    append(&mut log, window.state_mut(), entry(12, "done")).unwrap();
    assert_eq!(
        append(&mut log, window.state_mut(), entry(9, "refused")),
        Err(AppendError::TimestampRegressed {
            previous: 12,
            current: 9,
        })
    );
    let metrics = window.state();
    assert_eq!(metrics.accepted.exact_total(), Ok(3));
    assert_eq!(metrics.truncated.exact_total(), Ok(1));
    assert_eq!(metrics.evicted.exact_total(), Ok(1));
    assert_eq!(metrics.refused.exact_total(), Ok(1));

    // The host chooses the window/reset boundary. Refusals are counted without
    // recursively logging them; these counters do not claim a paid effect ran.
    window.reset(Diagnostics::default());
    assert_eq!(window.sequence(), Some(1));
    assert_eq!(window.state().accepted.exact_total(), Ok(0));
    assert_eq!(log.len(), 2);
    assert_eq!(log.checkpoint().next_sequence(), Some(3));
}
