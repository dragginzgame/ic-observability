use super::*;

#[test]
fn byte_budget_handles_decimal_widths_and_utf8_through_sequence_exhaustion() {
    for sequence in [0, 9, 10, 99, 100, u64::MAX] {
        for message in ["", "é🙂"] {
            let mut snapshot = history().into_snapshot();
            let mut entry = snapshot.entries.pop().unwrap();
            entry.sequence = sequence;
            entry.message = message.into();
            snapshot.entries = vec![entry];
            snapshot.next_sequence = sequence.checked_add(1);
            let log = Log::restore(snapshot).unwrap();
            let expected = format!("{sequence}: {message}\n");
            let exact = export(&log, Filter::default(), request(None), expected.len()).unwrap();
            assert_eq!(exact.body, expected);
            assert_eq!(exact.emitted, 1);
            assert_eq!(exact.scanned, 1);
            assert_eq!(exact.next_before, None);
            assert_eq!(
                export(&log, Filter::default(), request(None), expected.len() - 1),
                Err(ExportError::EntryTooLarge {
                    sequence,
                    required_bytes: expected.len(),
                    max_bytes: expected.len() - 1,
                })
            );
        }
    }
}

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
