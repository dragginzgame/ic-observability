//! Caller-owned UTF-8 export with a body budget and lossless cursor continuation.

use ic_logging::{EntryInput, Filter, Level, Limits, Log, PageRequest};
use std::{fmt::NumBuffer, num::NonZeroUsize, ops::ControlFlow};

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

// This budget bounds returned body bytes, not the String's spare capacity
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
    let mut stopped_for_budget = Ok(false);
    let mut sequence_buffer = NumBuffer::new();
    let scan = log.visit_page(filter, request, |entry| {
        let sequence = entry.sequence.format_into(&mut sequence_buffer);
        let required_bytes = sequence.len() + 2 + entry.message.len() + 1;
        if required_bytes > max_bytes.saturating_sub(body.len()) {
            stopped_for_budget = if emitted == 0 {
                Err(ExportError::EntryTooLarge {
                    sequence: entry.sequence,
                    required_bytes,
                    max_bytes,
                })
            } else {
                Ok(true)
            };
            return ControlFlow::Break(());
        }
        body.reserve(required_bytes);
        body.push_str(sequence);
        body.push_str(": ");
        body.push_str(&entry.message);
        body.push('\n');
        emitted += 1;
        last_emitted = Some(entry.sequence);
        ControlFlow::Continue(())
    });
    let stopped_for_budget = stopped_for_budget?;
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
mod tests;
