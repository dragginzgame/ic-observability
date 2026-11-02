//! Optional native metadata delegates to the canonical Serde records.

use super::{AggregateFields, CounterFields, FixedArray, HistogramFields, SummaryFields};
use crate::{MeasurementAggregate, MeasurementCounter, MeasurementHistogram, MeasurementSummary};

impl<const N: usize> ic_wire::typescript::Wire for MeasurementHistogram<N> {
    fn native_schema(
        context: &mut ic_wire::typescript::SchemaContext,
    ) -> Result<ic_wire::__private::serde_json::Value, ic_wire::typescript::GenerationError> {
        context.describe::<HistogramFields<N>>()
    }
}

// Metadata follows the exact private Serde records, never the arithmetic fields.
// The records are fixed-size scalars; this adds no unbounded decoding work.
macro_rules! metadata {
    ($value:ty, $fields:ty) => {
        impl ic_wire::typescript::Wire for $value {
            fn native_schema(
                context: &mut ic_wire::typescript::SchemaContext,
            ) -> Result<ic_wire::__private::serde_json::Value, ic_wire::typescript::GenerationError>
            {
                context.describe::<$fields>()
            }
        }
    };
}
metadata!(MeasurementAggregate, AggregateFields);
metadata!(MeasurementCounter, CounterFields);
metadata!(MeasurementSummary, SummaryFields);

impl<T: ic_wire::typescript::Wire, const N: usize> ic_wire::typescript::Wire for FixedArray<T, N> {
    fn native_schema(
        context: &mut ic_wire::typescript::SchemaContext,
    ) -> Result<ic_wire::__private::serde_json::Value, ic_wire::typescript::GenerationError> {
        Ok(
            ic_wire::__private::serde_json::json!({"k":"array", "max":N, "item":context.describe::<T>()?}),
        )
    }
}
