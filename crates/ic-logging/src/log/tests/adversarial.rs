//! Independently corrupted snapshots derived from public append operations.

use super::{input, log, positive};
use crate::{Log, RestoreError};
use alloc::string::String;

#[test]
fn generated_utf8_snapshots_refuse_corruption() {
    for text in ["", "\0", "e\u{301}", "é中🙂", "\u{10ffff}\n"] {
        for repetitions in [1, 5, 32] {
            let mut log = log(8, 32);
            for time in 0..3 {
                log.append(input(time, &text.repeat(repetitions))).unwrap();
            }
            let original = log.into_snapshot();
            assert_eq!(Log::restore(original.clone()).unwrap().snapshot(), original);

            let mut invalid = original.clone();
            invalid.limits.max_entries = positive(2);
            assert_eq!(
                Log::restore(invalid).unwrap_err(),
                RestoreError::TooManyEntries
            );

            let mut invalid = original.clone();
            invalid.next_sequence = Some(4);
            assert_eq!(
                Log::restore(invalid).unwrap_err(),
                RestoreError::InvalidSequence
            );

            let mut invalid = original.clone();
            invalid.entries[1].sequence = invalid.entries[0].sequence;
            assert_eq!(
                Log::restore(invalid).unwrap_err(),
                RestoreError::InvalidSequence
            );

            let mut invalid = original.clone();
            invalid.last_created_at_secs = Some(3);
            assert_eq!(
                Log::restore(invalid).unwrap_err(),
                RestoreError::InvalidTimestamp
            );

            let mut invalid = original.clone();
            invalid.entries[1].created_at_secs = 0;
            invalid.entries[0].created_at_secs = 1;
            assert_eq!(
                Log::restore(invalid).unwrap_err(),
                RestoreError::InvalidTimestamp
            );

            let mut invalid = original.clone();
            invalid.entries[0].source = String::from("source-is-over-the-label-limit");
            assert_eq!(
                Log::restore(invalid).unwrap_err(),
                RestoreError::InvalidEntry
            );

            let mut invalid = original.clone();
            invalid.entries[0].message = "🙂".repeat(9);
            assert_eq!(
                Log::restore(invalid).unwrap_err(),
                RestoreError::InvalidEntry
            );

            let mut invalid = original.clone();
            invalid.limits.max_text_bytes = 0;
            assert_eq!(
                Log::restore(invalid).unwrap_err(),
                RestoreError::TextBudgetExceeded
            );

            let mut invalid = original.clone();
            invalid.entries[0].truncated = true;
            invalid.entries[0].message = String::from("missing suffix");
            assert_eq!(
                Log::restore(invalid).unwrap_err(),
                RestoreError::InvalidEntry
            );

            // Invalid restoration must not affect another independently owned
            // checkpoint; it still supports the next append with the same ID.
            let mut restored = Log::restore(original).unwrap();
            assert_eq!(
                restored.append(input(3, "after restore")).unwrap().sequence,
                3
            );
        }
    }
}
