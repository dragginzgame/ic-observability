//! Link fixture for fixed application recording without a Wasm allocator or std.
//! The historical example name remains the owning CI artifact identity.

#![cfg_attr(target_family = "wasm", no_std)]
#![cfg_attr(target_family = "wasm", no_main)]
#![forbid(unsafe_code)]

use ic_metrics::{
    MeasurementAggregate, MeasurementCounter, MeasurementHistogram, MeasurementSummary,
    MeasurementWindow, persistence,
};

/// Record runtime input so constant folding cannot replace the instrumentation.
#[must_use]
pub fn recording(input: u64) -> Option<u128> {
    let mut aggregate = MeasurementAggregate::EMPTY;
    aggregate.record(input);
    let batch = aggregate;
    aggregate.record(0);
    aggregate.merge(batch);
    let mut counter = MeasurementCounter::ZERO;
    counter.add(u128::from(input));
    let mut summary = MeasurementSummary::EMPTY;
    summary.record(input);
    let mut histogram = MeasurementHistogram::new([10, 100]).ok()?;
    histogram.record(input);
    let mut other = MeasurementHistogram::new([10, 100]).ok()?;
    other.record(0);
    histogram.merge(&other).ok()?;
    let restored = persistence::restore_aggregate(
        aggregate.samples(),
        aggregate.total(),
        aggregate.maximum(),
        aggregate.samples_overflowed(),
        aggregate.total_overflowed(),
    )
    .ok()?;
    let mut window = MeasurementWindow::new(restored);
    window.reset(summary.aggregate());
    Some(
        counter.total()
            + aggregate.total()
            + histogram.aggregate().total()
            + window.state().total(),
    )
}

#[cfg(not(target_family = "wasm"))]
fn main() {
    assert_eq!(recording(7), Some(35));
}

#[cfg(target_family = "wasm")]
#[panic_handler]
fn panic(_: &core::panic::PanicInfo<'_>) -> ! {
    loop {}
}
