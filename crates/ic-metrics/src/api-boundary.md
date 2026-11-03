
## Public instrumentation boundary

These compile-fail examples enforce the hard cut tracked in
[issue #130](https://github.com/dragginzgame/ic-observability/issues/130).
General numeric helpers and implementation state are not application APIs.

```compile_fail
use ic_metrics::checked_scaled_ratio;
```

```compile_fail
use ic_metrics::checked_scaled_ratio_nearest;
```

```compile_fail
use ic_metrics::MeasurementRatioError;
```

```compile_fail
use ic_metrics::CheckedMeasurementAggregate;
```

```compile_fail
use ic_metrics::MeasurementRecordError;
```

```compile_fail
use ic_metrics::MeasurementMeanError;
```

```compile_fail
use ic_metrics::MeasurementInterval;
```

```compile_fail
use ic_metrics::MeasurementIntervalError;
```

```compile_fail
use ic_metrics::HistogramRange;
```

```compile_fail
use ic_metrics::HistogramQueryError;
```

```compile_fail
use ic_metrics::MeasurementStateError;
```

```compile_fail
use ic_metrics::validate_histogram_bounds;
```

```compile_fail
let _ = ic_metrics::MeasurementAggregate::EMPTY.mean();
```

```compile_fail
let _ = ic_metrics::MeasurementAggregate::EMPTY.scaled_mean(10);
```

```compile_fail
let _ = ic_metrics::MeasurementAggregate::EMPTY.interval_since(ic_metrics::MeasurementAggregate::EMPTY);
```

```compile_fail
let _ = ic_metrics::MeasurementCounter::ZERO.delta_since(ic_metrics::MeasurementCounter::ZERO);
```

```compile_fail
let _ = ic_metrics::MeasurementHistogram::new([10]).unwrap().cumulative_count(0);
```

```compile_fail
let _ = ic_metrics::MeasurementHistogram::new([10]).unwrap().quantile_bucket(1, 2);
```

```compile_fail
let _ = ic_metrics::MeasurementAggregate::from_parts(0, 0, None, false, false);
```

```compile_fail
let _ = ic_metrics::MeasurementCounter::from_parts(0, false);
```

```compile_fail
let _ = ic_metrics::MeasurementSummary::from_parts(ic_metrics::MeasurementAggregate::EMPTY, None);
```

```compile_fail
let _ = ic_metrics::MeasurementHistogram::from_parts([], [], 0, [], false, ic_metrics::MeasurementAggregate::EMPTY);
```

Recorder state is not a report or codec DTO. Serde is a development-only
dependency for these trait-refusal checks.

```compile_fail
fn report<T: serde::Serialize>() {}
report::<ic_metrics::MeasurementAggregate>();
```

```compile_fail
fn decode<T: for<'de> serde::Deserialize<'de>>() {}
decode::<ic_metrics::MeasurementAggregate>();
```

```compile_fail
fn report<T: serde::Serialize>() {}
report::<ic_metrics::MeasurementCounter>();
```

```compile_fail
fn decode<T: for<'de> serde::Deserialize<'de>>() {}
decode::<ic_metrics::MeasurementCounter>();
```

```compile_fail
fn report<T: serde::Serialize>() {}
report::<ic_metrics::MeasurementSummary>();
```

```compile_fail
fn decode<T: for<'de> serde::Deserialize<'de>>() {}
decode::<ic_metrics::MeasurementSummary>();
```

```compile_fail
fn report<T: serde::Serialize>() {}
report::<ic_metrics::MeasurementHistogram<2>>();
```

```compile_fail
fn decode<T: for<'de> serde::Deserialize<'de>>() {}
decode::<ic_metrics::MeasurementHistogram<2>>();
```
