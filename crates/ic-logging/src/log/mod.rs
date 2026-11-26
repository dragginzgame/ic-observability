//! Heap log admission, immutable rows, bounded retention and cursor paging.
//!
//! Callers own authorization, scheduling, time and any durable storage.

#[cfg(test)]
mod tests;

use alloc::{collections::VecDeque, string::String, vec::Vec};
use core::{num::NonZeroUsize, ops::ControlFlow};

/// Fixed, target-independent byte charge for each row in a retained-byte log.
/// This accounts for row metadata and excludes spare capacity and allocator overhead.
pub const RETAINED_ENTRY_OVERHEAD: usize = 96;

///
/// `Level`
/// Severity ordering used by minimum-level filters.
///

#[derive(Clone, Copy, Debug, Eq, Ord, PartialEq, PartialOrd)]
pub enum Level {
    /// Development detail.
    Debug,
    /// Ordinary informational observation.
    Info,
    /// Successful outcome, ordered above informational observations.
    Ok,
    /// Recoverable or suspicious condition.
    Warn,
    /// Failed operation or invariant observation.
    Error,
}

///
/// `Limits`
/// Fixed limits chosen by the host before constructing a log.
///

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct Limits {
    /// Maximum retained rows; count eviction removes the oldest row.
    pub max_entries: NonZeroUsize,
    /// Maximum retained message bytes, including any truncation suffix.
    pub max_message_bytes: usize,
    /// Maximum UTF-8 bytes in each source or topic label.
    pub max_label_bytes: usize,
    /// Maximum combined retained message/source/topic UTF-8 bytes.
    /// Excludes row metadata, allocator overhead and transient checkpoint copies.
    pub max_text_bytes: usize,
}

impl Limits {
    const fn policy(self) -> LogPolicy {
        LogPolicy {
            entry_limit: Some(self.max_entries),
            byte_limit: self.max_text_bytes,
            label_bytes: self.max_label_bytes,
            message_bytes: self.max_message_bytes,
        }
    }
}

///
/// `RetainedByteLimits`
/// One retention budget for row metadata and UTF-8 text.
///

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct RetainedByteLimits {
    /// Maximum combined charge, including [`RETAINED_ENTRY_OVERHEAD`] per row.
    /// Budgets below that charge refuse every append.
    pub max_retained_bytes: usize,
    /// Maximum retained message bytes, including any truncation suffix.
    pub max_message_bytes: usize,
    /// Maximum UTF-8 bytes in each source or topic label.
    pub max_label_bytes: usize,
}

impl RetainedByteLimits {
    const fn policy(self) -> LogPolicy {
        LogPolicy {
            entry_limit: None,
            byte_limit: self.max_retained_bytes,
            label_bytes: self.max_label_bytes,
            message_bytes: self.max_message_bytes,
        }
    }
}

///
/// `LogPolicy`
/// Admission limits shared by append, eviction and restoration.
///

#[derive(Debug)]
struct LogPolicy {
    entry_limit: Option<NonZeroUsize>,
    byte_limit: usize,
    label_bytes: usize,
    message_bytes: usize,
}

impl LogPolicy {
    const fn row_overhead(&self) -> usize {
        if self.entry_limit.is_none() {
            RETAINED_ENTRY_OVERHEAD
        } else {
            0
        }
    }

    fn charge_components(
        &self,
        source: &str,
        topic: Option<&str>,
        message_bytes: usize,
    ) -> [usize; 4] {
        [
            self.row_overhead(),
            source.len(),
            topic.map_or(0, str::len),
            message_bytes,
        ]
    }
}

///
/// `EntryInput`
/// Borrowed append input; bounded retained strings are copied only after admission.
///

#[derive(Clone, Copy, Debug)]
pub struct EntryInput<'a> {
    /// Caller-supplied whole seconds; may not regress within this log.
    pub created_at_secs: u64,
    /// Observation severity.
    pub level: Level,
    /// Application or component label.
    pub source: &'a str,
    /// Optional application-defined topic.
    pub topic: Option<&'a str>,
    /// Message to retain, truncated to the configured byte ceiling.
    pub message: &'a str,
}

///
/// `Entry`
/// Immutable retained row; sequence identities belong to one log instance.
///

#[derive(Clone, Debug, Eq, PartialEq)]
pub struct Entry {
    /// Monotonic identity, starting at zero and never reused within one log.
    pub sequence: u64,
    /// Admitted caller-supplied timestamp.
    pub created_at_secs: u64,
    /// Observation severity.
    pub level: Level,
    /// Bounded application or component label.
    pub source: String,
    /// Optional bounded topic label.
    pub topic: Option<String>,
    /// Bounded message text.
    pub message: String,
    /// Whether the original message exceeded its byte limit.
    pub truncated: bool,
}

///
/// `Label`
/// Label rejected by append admission.
///

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum Label {
    /// Application or component source.
    Source,
    /// Optional topic.
    Topic,
}

///
/// `AppendError`
/// Append refusal; every variant leaves entries and watermarks unchanged.
///

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum AppendError {
    /// A label exceeded its configured byte ceiling.
    LabelTooLong {
        /// Rejected field.
        label: Label,
        /// Supplied UTF-8 byte length.
        actual_bytes: usize,
        /// Configured ceiling.
        max_bytes: usize,
    },
    /// The timestamp is older than the last admitted append, even after pruning.
    TimestampRegressed {
        /// Last admitted timestamp.
        previous: u64,
        /// Rejected timestamp.
        current: u64,
    },
    /// All sequence identities have been issued for this log instance.
    SequenceExhausted,
    /// This row's retained text cannot fit even in an otherwise empty log.
    TextBudgetExceeded {
        /// Required message/source/topic bytes after message truncation.
        required_bytes: u128,
        /// Configured total retained-text ceiling.
        max_bytes: usize,
    },
    /// This row's metadata and retained text cannot fit in an empty log.
    RetainedByteBudgetExceeded {
        /// Required row charge after message truncation.
        required_bytes: u128,
        /// Configured total retained-byte ceiling.
        max_bytes: usize,
    },
}

impl core::fmt::Display for AppendError {
    fn fmt(&self, formatter: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        match self {
            Self::LabelTooLong {
                label,
                actual_bytes,
                max_bytes,
            } => {
                let label = match label {
                    Label::Source => "source",
                    Label::Topic => "topic",
                };

                write!(
                    formatter,
                    "log {label} label exceeds {max_bytes} bytes ({actual_bytes} supplied)"
                )
            }
            Self::TimestampRegressed { previous, current } => write!(
                formatter,
                "log timestamp regressed from {previous} to {current} seconds"
            ),
            Self::SequenceExhausted => formatter.write_str("log sequence identities are exhausted"),
            Self::TextBudgetExceeded {
                required_bytes,
                max_bytes,
            } => write!(
                formatter,
                "log row requires {required_bytes} text bytes (limit {max_bytes})"
            ),
            Self::RetainedByteBudgetExceeded {
                required_bytes,
                max_bytes,
            } => write!(
                formatter,
                "log row requires {required_bytes} retained bytes (limit {max_bytes})"
            ),
        }
    }
}

impl core::error::Error for AppendError {}

///
/// `AppendReceipt`
/// Receipt for one admitted append; eviction is oldest-first.
///

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct AppendReceipt {
    /// Newly issued identity.
    pub sequence: u64,
    /// Whether the original message exceeded its individual byte ceiling.
    pub truncated: bool,
    /// Previously retained rows evicted to admit this row.
    pub evicted: usize,
}

///
/// `TopicMatch`
/// Match any topic, no topic, or one exact topic (including an empty label).
///

#[derive(Clone, Copy, Debug, Default, Eq, PartialEq)]
pub enum TopicMatch<'a> {
    /// Do not filter on topic presence or value.
    #[default]
    Any,
    /// Match only rows with no topic.
    Absent,
    /// Match a present topic exactly.
    Exact(&'a str),
}

///
/// `Filter`
/// Optional exact label filters and a minimum severity; all supplied filters apply.
///

#[derive(Clone, Copy, Debug, Default)]
pub struct Filter<'a> {
    /// Match this exact source when present.
    pub source: Option<&'a str>,
    /// Topic presence/value selection.
    pub topic: TopicMatch<'a>,
    /// Include this severity and higher when present.
    pub min_level: Option<Level>,
}

impl Filter<'_> {
    fn matches(self, entry: &Entry) -> bool {
        let source_matches = self.source.is_none_or(|source| source == entry.source);
        let topic_matches = match self.topic {
            TopicMatch::Any => true,
            TopicMatch::Absent => entry.topic.is_none(),
            TopicMatch::Exact(topic) => entry.topic.as_deref() == Some(topic),
        };
        let level_matches = self.min_level.is_none_or(|level| entry.level >= level);

        source_matches && topic_matches && level_matches
    }
}

///
/// `PageRequest`
/// One newest-first scan using an exclusive sequence cursor.
///

#[derive(Clone, Copy, Debug)]
pub struct PageRequest {
    /// Scan entries older than this sequence, or begin at the newest entry.
    pub before: Option<u64>,
    /// Maximum matching rows to return.
    pub max_results: NonZeroUsize,
    /// Maximum candidate rows to examine after binary-search positioning.
    pub max_scanned: NonZeroUsize,
}

///
/// `Page`
/// Borrowed page; a continuation can be present even when no row matched.
///

#[derive(Debug)]
pub struct Page<'a> {
    /// Matching rows, newest first.
    pub entries: Vec<&'a Entry>,
    /// Number of candidate rows examined, not the total number of matches.
    pub scanned: usize,
    /// Exclusive cursor for the next older scan, if retained candidates remain.
    pub next_before: Option<u64>,
}

///
/// `PageScan`
/// Progress of one bounded visitor scan, including a caller-requested early stop.
///

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct PageScan {
    /// Matching rows delivered to the visitor, including a row returning `Break`.
    pub matched: usize,
    /// Candidate rows examined after positioning.
    pub scanned: usize,
    /// Continue strictly before this identity when retained candidates remain.
    pub next_before: Option<u64>,
}

///
/// `LogCheckpoint`
/// Borrowed complete checkpoint view; obtaining/iterating it allocates nothing.
/// Hosts own encoding budgets. The immutable borrow keeps rows and watermarks fixed.
///

#[derive(Clone, Copy, Debug)]
pub struct LogCheckpoint<'a, L = Limits> {
    limits: L,
    entries: &'a VecDeque<Entry>,
    next_sequence: Option<u64>,
    last_created_at_secs: Option<u64>,
}

impl<'a, L: Copy> LogCheckpoint<'a, L> {
    /// Fixed retention limits.
    #[must_use]
    pub const fn limits(&self) -> L {
        self.limits
    }

    /// All retained rows, oldest first, without cloning text.
    pub fn entries(&self) -> impl ExactSizeIterator<Item = &'a Entry> + DoubleEndedIterator + 'a {
        self.entries.iter()
    }

    /// Next identity, including permanent exhaustion after complete pruning.
    #[must_use]
    pub const fn next_sequence(&self) -> Option<u64> {
        self.next_sequence
    }

    /// Last admitted time, including after complete pruning.
    #[must_use]
    pub const fn last_created_at_secs(&self) -> Option<u64> {
        self.last_created_at_secs
    }
}

///
/// `RetentionBatch`
/// Result of a bounded age-retention call.
///

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct RetentionBatch {
    /// Number of rows removed by this call.
    pub removed: usize,
    /// Whether the oldest remaining row is also expired.
    pub more_due: bool,
}

///
/// `LogSnapshot`
/// Complete passive checkpoint, with rows ordered oldest first.
///
/// Consumers own durable encoding, identity and allocation and must bound
/// allocation before decoding a checkpoint. Restore through [`Log::restore`] or
/// [`Log::restore_retained_bytes`], according to the checkpoint's limits.
///

#[derive(Clone, Debug, Eq, PartialEq)]
pub struct LogSnapshot<L = Limits> {
    /// Fixed bounds of the original log.
    pub limits: L,
    /// Retained contiguous suffix of issued identities, oldest first.
    pub entries: Vec<Entry>,
    /// Next unissued identity; `None` means permanent sequence exhaustion.
    pub next_sequence: Option<u64>,
    /// Last admitted timestamp, retained even when no rows remain.
    pub last_created_at_secs: Option<u64>,
}

///
/// `RestoreError`
/// Refusal of a checkpoint that the maintained engine cannot produce.
///

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum RestoreError {
    /// Retained row count exceeds the fixed limit.
    TooManyEntries,
    /// Rows are not contiguous or the next identity contradicts the retained tail.
    InvalidSequence,
    /// Row times regress or the timestamp watermark is inconsistent.
    InvalidTimestamp,
    /// A label/message exceeds its bound or truncated text is inconsistent.
    InvalidEntry,
    /// Combined retained text exceeds the checkpoint's configured ceiling.
    TextBudgetExceeded,
    /// Combined row metadata and retained text exceed the checkpoint's ceiling.
    RetainedByteBudgetExceeded,
}

impl core::fmt::Display for RestoreError {
    fn fmt(&self, formatter: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        formatter.write_str(match self {
            Self::TooManyEntries => "log checkpoint exceeds its entry limit",
            Self::InvalidSequence => "invalid log checkpoint sequence",
            Self::InvalidTimestamp => "invalid log checkpoint timestamp",
            Self::InvalidEntry => "invalid bounded log checkpoint entry",
            Self::TextBudgetExceeded => "log checkpoint exceeds its text budget",
            Self::RetainedByteBudgetExceeded => "log checkpoint exceeds its retained-byte budget",
        })
    }
}

impl core::error::Error for RestoreError {}

///
/// `Log`
/// Caller-owned heap history with fixed limits and monotonic append watermarks.
///

#[derive(Debug)]
pub struct Log<L = Limits> {
    limits: L,
    policy: LogPolicy,
    entries: VecDeque<Entry>,
    accounted_bytes: usize,
    next_sequence: Option<u64>,
    last_created_at_secs: Option<u64>,
}

impl Log<Limits> {
    /// Construct an empty log without preallocating the configured maximum.
    #[must_use]
    pub const fn new(limits: Limits) -> Self {
        Self::empty(limits, limits.policy())
    }

    /// Combined retained text bytes, excluding row metadata and allocator overhead.
    #[must_use]
    pub const fn retained_text_bytes(&self) -> usize {
        self.accounted_bytes
    }

    /// Admit a count-and-text checkpoint without replaying entries.
    ///
    /// # Errors
    /// Rejects inconsistent bounds, row order, append watermarks or truncation state.
    pub fn restore(snapshot: LogSnapshot) -> Result<Self, RestoreError> {
        let policy = snapshot.limits.policy();

        Self::restore_with_policy(snapshot, policy)
    }
}

impl Log<RetainedByteLimits> {
    /// Construct an empty log with a single retained-byte budget and no separate row cap.
    #[must_use]
    pub const fn with_retained_byte_limit(limits: RetainedByteLimits) -> Self {
        Self::empty(limits, limits.policy())
    }

    /// Return accounted metadata and text bytes in constant time.
    #[must_use]
    pub const fn retained_bytes(&self) -> usize {
        self.accounted_bytes
    }

    /// Combined retained text bytes, excluding row metadata and allocator overhead.
    #[must_use]
    pub fn retained_text_bytes(&self) -> usize {
        self.accounted_bytes - RETAINED_ENTRY_OVERHEAD * self.entries.len()
    }

    /// Admit a retained-byte checkpoint and recompute its current byte usage.
    ///
    /// # Errors
    /// Rejects inconsistent bounds, row order, append watermarks or truncation state,
    /// including rows whose combined charge exceeds the configured budget.
    pub fn restore_retained_bytes(
        snapshot: LogSnapshot<RetainedByteLimits>,
    ) -> Result<Self, RestoreError> {
        let policy = snapshot.limits.policy();

        Self::restore_with_policy(snapshot, policy)
    }
}

impl<L: Copy> Log<L> {
    const fn empty(limits: L, policy: LogPolicy) -> Self {
        Self {
            limits,
            policy,
            entries: VecDeque::new(),
            accounted_bytes: 0,
            next_sequence: Some(0),
            last_created_at_secs: None,
        }
    }

    /// Return the fixed bounds without copying retained messages.
    #[must_use]
    pub const fn limits(&self) -> L {
        self.limits
    }

    /// Borrow rows and append watermarks together, without copying or consuming the log.
    #[must_use]
    pub const fn checkpoint(&self) -> LogCheckpoint<'_, L> {
        LogCheckpoint {
            limits: self.limits,
            entries: &self.entries,
            next_sequence: self.next_sequence,
            last_created_at_secs: self.last_created_at_secs,
        }
    }

    /// Copy all retained rows and both append watermarks for explicit checkpointing.
    /// Work and allocation scale with retained history, not a cursor-page limit.
    #[must_use]
    pub fn snapshot(&self) -> LogSnapshot<L> {
        LogSnapshot {
            limits: self.limits,
            entries: self.entries.iter().cloned().collect(),
            next_sequence: self.next_sequence,
            last_created_at_secs: self.last_created_at_secs,
        }
    }

    /// Consume the log into a checkpoint without cloning retained entries.
    /// Fixed limits, row order and both append watermarks are preserved, including
    /// empty histories and permanent sequence exhaustion.
    #[must_use]
    pub fn into_snapshot(self) -> LogSnapshot<L> {
        LogSnapshot {
            limits: self.limits,
            entries: self.entries.into(),
            next_sequence: self.next_sequence,
            last_created_at_secs: self.last_created_at_secs,
        }
    }

    fn restore_with_policy(
        snapshot: LogSnapshot<L>,
        policy: LogPolicy,
    ) -> Result<Self, RestoreError> {
        let accounted_bytes = validate_snapshot(&snapshot, &policy)?;
        let LogSnapshot {
            limits,
            entries,
            next_sequence,
            last_created_at_secs,
        } = snapshot;

        Ok(Self {
            limits,
            policy,
            entries: entries.into(),
            accounted_bytes,
            next_sequence,
            last_created_at_secs,
        })
    }

    /// Return the retained row count.
    #[must_use]
    pub fn len(&self) -> usize {
        self.entries.len()
    }

    /// Whether this log currently has no retained rows.
    #[must_use]
    pub fn is_empty(&self) -> bool {
        self.entries.is_empty()
    }

    /// Admit one row, evicting the oldest rows until the retention limits fit.
    ///
    /// # Errors
    /// Returns a typed refusal for oversized labels, regressed time or exhausted
    /// sequence identities, or a row that cannot fit the byte budget by itself.
    /// Validation completes before any eviction or mutation. Error priority is
    /// source, topic, regressed time, sequence exhaustion, then the byte budget.
    pub fn append(&mut self, input: EntryInput<'_>) -> Result<AppendReceipt, AppendError> {
        self.validate_label(Label::Source, input.source)?;
        if let Some(topic) = input.topic {
            self.validate_label(Label::Topic, topic)?;
        }

        if let Some(previous) = self.last_created_at_secs
            && input.created_at_secs < previous
        {
            return Err(AppendError::TimestampRegressed {
                previous,
                current: input.created_at_secs,
            });
        }
        let sequence = self.next_sequence.ok_or(AppendError::SequenceExhausted)?;

        let (prefix, suffix) = message_parts(input.message, self.policy.message_bytes);
        let required_bytes = self
            .policy
            .charge_components(input.source, input.topic, prefix.len() + suffix.len())
            .into_iter()
            .map(|bytes| bytes as u128)
            .sum();
        let max_bytes = self.policy.byte_limit;
        let row_charge = usize::try_from(required_bytes)
            .ok()
            .filter(|bytes| *bytes <= max_bytes)
            .ok_or_else(|| {
                if self.policy.entry_limit.is_some() {
                    AppendError::TextBudgetExceeded {
                        required_bytes,
                        max_bytes,
                    }
                } else {
                    AppendError::RetainedByteBudgetExceeded {
                        required_bytes,
                        max_bytes,
                    }
                }
            })?;

        let truncated = input.message.len() > self.policy.message_bytes;
        let entry = Entry {
            sequence,
            created_at_secs: input.created_at_secs,
            level: input.level,
            source: String::from(input.source),
            topic: input.topic.map(String::from),
            message: bounded_message(prefix, suffix),
            truncated,
        };

        let mut evicted = 0;
        while (self
            .policy
            .entry_limit
            .is_some_and(|limit| self.entries.len() >= limit.get())
            || self.accounted_bytes > max_bytes - row_charge)
            && self.remove_oldest()
        {
            evicted += 1;
        }

        self.entries.push_back(entry);
        self.accounted_bytes += row_charge;
        self.next_sequence = sequence.checked_add(1);
        self.last_created_at_secs = Some(input.created_at_secs);

        Ok(AppendReceipt {
            sequence,
            truncated,
            evicted,
        })
    }

    /// Remove at most `max_remove` entries strictly older than the age cutoff.
    /// An entry remains available through its full configured age second.
    pub fn prune_expired(
        &mut self,
        now_secs: u64,
        max_age_secs: u64,
        max_remove: usize,
    ) -> RetentionBatch {
        let cutoff = now_secs.saturating_sub(max_age_secs);
        let mut removed = 0;
        while removed < max_remove && self.expired_before(cutoff) {
            self.remove_oldest();
            removed += 1;
        }

        RetentionBatch {
            removed,
            more_due: self.expired_before(cutoff),
        }
    }

    /// First second at which the oldest row expires; `None` for empty history or overflow.
    #[must_use]
    pub fn next_expiry_secs(&self, max_age_secs: u64) -> Option<u64> {
        self.entries
            .front()?
            .created_at_secs
            .checked_add(max_age_secs)?
            .checked_add(1)
    }

    /// Scan newest-first without cloning retained messages or counting every match.
    /// Follow `next_before` with the same filters, including after an empty page.
    #[must_use]
    pub fn page(&self, filter: Filter<'_>, request: PageRequest) -> Page<'_> {
        let mut entries = Vec::new();
        let scan = self.visit_page(filter, request, |entry| {
            entries.push(entry);

            ControlFlow::Continue(())
        });

        Page {
            entries,
            scanned: scan.scanned,
            next_before: scan.next_before,
        }
    }

    /// Visit matching rows without allocating a page collection or cloning text.
    /// `Break` stops after consuming that matched row; the returned cursor resumes
    /// at the next older candidate. Empty filtered scans can still have a cursor.
    /// Callback work/allocation belongs to the caller; filter/limits match `page`.
    pub fn visit_page<'a>(
        &'a self,
        filter: Filter<'_>,
        request: PageRequest,
        mut visit: impl FnMut(&'a Entry) -> ControlFlow<()>,
    ) -> PageScan {
        let mut cursor = request.before.map_or(self.entries.len(), |sequence| {
            self.entries
                .binary_search_by_key(&sequence, |entry| entry.sequence)
                .unwrap_or_else(|index| index)
        });

        let mut matched = 0;
        let mut scanned = 0;
        while cursor > 0
            && scanned < request.max_scanned.get()
            && matched < request.max_results.get()
        {
            cursor -= 1;
            let entry = &self.entries[cursor];
            scanned += 1;
            if filter.matches(entry) {
                matched += 1;
                if visit(entry).is_break() {
                    break;
                }
            }
        }

        PageScan {
            matched,
            scanned,
            // Nonzero limits guarantee a visit whenever the initial cursor is nonzero.
            next_before: if cursor > 0 {
                self.entries.get(cursor).map(|entry| entry.sequence)
            } else {
                None
            },
        }
    }

    const fn validate_label(&self, label: Label, text: &str) -> Result<(), AppendError> {
        if text.len() > self.policy.label_bytes {
            return Err(AppendError::LabelTooLong {
                label,
                actual_bytes: text.len(),
                max_bytes: self.policy.label_bytes,
            });
        }

        Ok(())
    }

    fn expired_before(&self, cutoff: u64) -> bool {
        self.entries
            .front()
            .is_some_and(|entry| entry.created_at_secs < cutoff)
    }

    fn remove_oldest(&mut self) -> bool {
        let Some(entry) = self.entries.pop_front() else {
            return false;
        };

        // Each component was admitted into the cached sum before insertion.
        for bytes in self.policy.charge_components(
            &entry.source,
            entry.topic.as_deref(),
            entry.message.len(),
        ) {
            self.accounted_bytes -= bytes;
        }

        true
    }
}

fn validate_snapshot<L>(
    snapshot: &LogSnapshot<L>,
    policy: &LogPolicy,
) -> Result<usize, RestoreError> {
    let LogSnapshot {
        entries,
        next_sequence,
        last_created_at_secs,
        ..
    } = snapshot;
    let (next_sequence, last_created_at_secs) = (*next_sequence, *last_created_at_secs);

    if policy
        .entry_limit
        .is_some_and(|limit| entries.len() > limit.get())
    {
        return Err(RestoreError::TooManyEntries);
    }
    if (next_sequence == Some(0)) != last_created_at_secs.is_none() {
        return Err(RestoreError::InvalidTimestamp);
    }
    // The last row cannot expire at the final representable timestamp, and
    // eviction always leaves the newly admitted row behind.
    if entries.is_empty() && last_created_at_secs == Some(u64::MAX) {
        return Err(RestoreError::InvalidTimestamp);
    }

    let budget_error = if policy.entry_limit.is_some() {
        RestoreError::TextBudgetExceeded
    } else {
        RestoreError::RetainedByteBudgetExceeded
    };
    // A budget that cannot admit an empty row cannot have append watermarks.
    if entries.is_empty()
        && last_created_at_secs.is_some()
        && policy.byte_limit < policy.row_overhead()
    {
        return Err(budget_error);
    }

    let mut previous: Option<&Entry> = None;
    let mut accounted_bytes = 0_usize;
    for entry in entries {
        if entry.source.len() > policy.label_bytes
            || entry
                .topic
                .as_ref()
                .is_some_and(|topic| topic.len() > policy.label_bytes)
            || !valid_retained_message(entry, policy.message_bytes)
        {
            return Err(RestoreError::InvalidEntry);
        }

        for bytes in
            policy.charge_components(&entry.source, entry.topic.as_deref(), entry.message.len())
        {
            accounted_bytes = accounted_bytes
                .checked_add(bytes)
                .filter(|total| *total <= policy.byte_limit)
                .ok_or(budget_error)?;
        }

        if let Some(previous) = previous {
            if previous.sequence.checked_add(1) != Some(entry.sequence) {
                return Err(RestoreError::InvalidSequence);
            }
            if entry.created_at_secs < previous.created_at_secs {
                return Err(RestoreError::InvalidTimestamp);
            }
        }
        previous = Some(entry);
    }

    if let Some(last) = previous {
        if last.sequence.checked_add(1) != next_sequence {
            return Err(RestoreError::InvalidSequence);
        }
        if Some(last.created_at_secs) != last_created_at_secs {
            return Err(RestoreError::InvalidTimestamp);
        }
    }

    Ok(accounted_bytes)
}

const TRUNCATION_SUFFIX: &str = "...[truncated]";

const fn truncation_suffix(max_bytes: usize) -> &'static str {
    if max_bytes > TRUNCATION_SUFFIX.len() {
        TRUNCATION_SUFFIX
    } else {
        ""
    }
}

fn valid_retained_message(entry: &Entry, max_bytes: usize) -> bool {
    if entry.message.len() > max_bytes {
        return false;
    }
    if !entry.truncated {
        return true;
    }
    let suffix = truncation_suffix(max_bytes);
    let Some(prefix) = entry.message.strip_suffix(suffix) else {
        return false;
    };
    let budget = max_bytes - suffix.len();

    budget.saturating_sub(prefix.len()) < 4
}

fn bounded_message(prefix: &str, suffix: &str) -> String {
    let mut retained = String::with_capacity(prefix.len() + suffix.len());
    retained.push_str(prefix);
    retained.push_str(suffix);

    retained
}

fn message_parts(message: &str, max_bytes: usize) -> (&str, &'static str) {
    if message.len() <= max_bytes {
        return (message, "");
    }
    let suffix = truncation_suffix(max_bytes);
    let mut end = max_bytes - suffix.len();
    while !message.is_char_boundary(end) {
        end -= 1;
    }

    (&message[..end], suffix)
}
