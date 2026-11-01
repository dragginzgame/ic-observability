//! Caller-owned UTF-8 export with a body budget and lossless cursor continuation.

use ic_logging::{EntryInput, Filter, Level, Limits, Log, PageRequest};
use std::{num::NonZeroUsize, ops::ControlFlow};

#[derive(Debug, Eq, PartialEq)]
struct ExportPage {
    body: String,
    emitted: usize,
    scanned: usize,
    next_before: Option<u64>,
}

#[derive(Debug, Eq, PartialEq)]
enum ExportError {
    EntryTooLarge {
        sequence: u64,
        required_bytes: usize,
        max_bytes: usize,
    },
}

// This budget bounds returned body bytes, not temporary formatting allocations
// or an enclosing transport envelope. The host owns the format and those bounds.
fn export(
    log: &Log,
    filter: Filter<'_>,
    request: PageRequest,
    max_bytes: usize,
) -> Result<ExportPage, ExportError> {
    let mut body = String::new();
    let mut emitted = 0;
    let mut last_emitted = None;
    let mut stopped_for_budget = false;
    let mut error = None;
    let scan = log.visit_page(filter, request, |entry| {
        let encoded = format!("{}: {}\n", entry.sequence, entry.message);
        if encoded.len() > max_bytes.saturating_sub(body.len()) {
            stopped_for_budget = true;
            if emitted == 0 {
                error = Some(ExportError::EntryTooLarge {
                    sequence: entry.sequence,
                    required_bytes: encoded.len(),
                    max_bytes,
                });
            }
            return ControlFlow::Break(());
        }
        body.push_str(&encoded);
        emitted += 1;
        last_emitted = Some(entry.sequence);
        ControlFlow::Continue(())
    });
    if let Some(error) = error {
        return Err(error);
    }
    Ok(ExportPage {
        body,
        emitted,
        scanned: scan.scanned,
        // Break consumes its candidate in the engine. The candidate that did
        // not fit has not been emitted, so resume from the last delivered row.
        next_before: if stopped_for_budget {
            last_emitted
        } else {
            scan.next_before
        },
    })
}

const fn request(before: Option<u64>) -> PageRequest {
    PageRequest {
        before,
        max_results: NonZeroUsize::new(3).unwrap(),
        max_scanned: NonZeroUsize::new(3).unwrap(),
    }
}

fn history() -> Log {
    let mut log = Log::new(Limits {
        max_entries: NonZeroUsize::new(3).unwrap(),
        max_message_bytes: 32,
        max_label_bytes: 16,
        max_text_bytes: 128,
    });
    for (time, message) in ["a", "é", "🙂"].into_iter().enumerate() {
        log.append(EntryInput {
            created_at_secs: u64::try_from(time).unwrap(),
            source: "worker",
            topic: None,
            level: Level::Info,
            message,
        })
        .unwrap();
    }
    log
}

fn main() {
    let log = history();
    let first = export(&log, Filter::default(), request(None), 8).unwrap();
    assert_eq!(first.body, "2: 🙂\n");
    let second = export(&log, Filter::default(), request(first.next_before), 8).unwrap();
    assert_eq!(second.body, "1: é\n");
    let third = export(&log, Filter::default(), request(second.next_before), 8).unwrap();
    assert_eq!(third.body, "0: a\n");
    assert_eq!(third.next_before, None);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn budget_stop_does_not_skip_the_unemitted_utf8_candidate() {
        let log = history();
        let first = export(&log, Filter::default(), request(None), 8).unwrap();
        assert_eq!(first.body, "2: 🙂\n");
        assert_eq!(first.emitted, 1);
        assert_eq!(first.scanned, 2);
        assert_eq!(first.next_before, Some(2));
        let second = export(&log, Filter::default(), request(first.next_before), 8).unwrap();
        assert_eq!(second.body, "1: é\n");
        assert_eq!(second.next_before, Some(1));
        let last = export(&log, Filter::default(), request(second.next_before), 8).unwrap();
        assert_eq!(last.body, "0: a\n");
        assert_eq!(last.next_before, None);
    }

    #[test]
    fn oversized_first_row_returns_a_typed_error_instead_of_a_retry_loop() {
        let log = history();
        for max_bytes in [0, 7] {
            assert_eq!(
                export(&log, Filter::default(), request(None), max_bytes),
                Err(ExportError::EntryTooLarge {
                    sequence: 2,
                    required_bytes: 8,
                    max_bytes,
                })
            );
        }
        assert_eq!(log.checkpoint().next_sequence(), Some(3));
    }

    #[test]
    fn empty_filtered_scans_use_the_engine_continuation() {
        let log = history();
        let filter = Filter {
            min_level: Some(Level::Error),
            ..Filter::default()
        };
        let mut before = None;
        for expected in [Some(2), Some(1), None] {
            let mut request = request(before);
            request.max_scanned = NonZeroUsize::new(1).unwrap();
            let page = export(&log, filter, request, 0).unwrap();
            assert_eq!(page.body, "");
            assert_eq!(page.emitted, 0);
            assert_eq!(page.scanned, 1);
            assert_eq!(page.next_before, expected);
            before = page.next_before;
        }
    }

    #[test]
    fn count_and_scan_limits_still_apply_with_a_large_body_budget() {
        let log = history();
        for (results, scanned) in [(1, 3), (3, 1)] {
            let mut request = request(None);
            request.max_results = NonZeroUsize::new(results).unwrap();
            request.max_scanned = NonZeroUsize::new(scanned).unwrap();
            let page = export(&log, Filter::default(), request, 128).unwrap();
            assert_eq!(page.body, "2: 🙂\n");
            assert_eq!(page.emitted, 1);
            assert_eq!(page.scanned, 1);
            assert_eq!(page.next_before, Some(2));
        }
    }
}
