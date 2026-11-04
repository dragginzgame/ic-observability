use super::*;
use crate::{MeasurementAggregate, MeasurementCounter};

#[test]
fn window_resets_all_shapes_without_manufacturing_instance_identity() {
    let mut window =
        MeasurementWindow::new((MeasurementAggregate::EMPTY, MeasurementCounter::ZERO));
    window.state_mut().0.record(0);
    window.state_mut().1.add(9);
    assert_eq!(window.state().0.samples(), 1);
    assert_eq!(window.state().1.total(), 9);
    assert_eq!(window.sequence(), Some(0));
    window.reset((MeasurementAggregate::EMPTY, MeasurementCounter::ZERO));
    assert_eq!(window.sequence(), Some(1));
    assert_eq!(window.state().0.samples(), 0);
    assert_eq!(window.state().1.total(), 0);
}

#[test]
fn window_sequence_exhaustion_never_wraps_or_recovers_on_reset() {
    let mut window = MeasurementWindow {
        state: (),
        sequence: Some(u64::MAX),
    };
    window.reset(());
    assert_eq!(window.sequence(), None);
    window.reset(());
    assert_eq!(window.sequence(), None);
}
