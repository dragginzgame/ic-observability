#[test]
fn retained_log_contract() {
    use ic_logging::{EntryInput, Filter, Level, Limits, Log, PageRequest};
    use std::num::NonZeroUsize;
    let one = NonZeroUsize::new(1).unwrap();
    let mut log = Log::new(Limits {
        max_entries: one,
        max_message_bytes: 32,
        max_label_bytes: 16,
        max_text_bytes: 64,
    });
    let receipt = log
        .append(EntryInput {
            created_at_secs: 1,
            source: "fixture",
            topic: None,
            level: Level::Info,
            message: "retained",
        })
        .unwrap();
    assert_eq!(receipt.sequence, 0);
    assert_eq!(
        log.page(
            Filter::default(),
            PageRequest {
                before: None,
                max_results: one,
                max_scanned: one
            }
        )
        .entries
        .len(),
        1
    );
    assert_eq!(log.prune_expired(3, 1, 1).removed, 1);
}
