use std::sync::atomic::AtomicU64;

use prometheus_client::{
    encoding::EncodeLabelSet,
    metrics::{family::Family, gauge::Gauge},
    registry::Registry,
};

#[derive(Clone, Debug, Hash, PartialEq, Eq, EncodeLabelSet)]
pub struct CarbonIntensityLabel {
    location: String,
}

pub type CarbonIntensityMetric = Family<CarbonIntensityLabel, Gauge<f64, AtomicU64>>;

pub fn setup_registry() -> (Registry, CarbonIntensityMetric) {
    let mut registry = Registry::default();
    let carbon_intensity = Family::default();
    registry.register(
        "carbon_intensity",
        "Location carbon intensity in gCO2eq/kWh",
        carbon_intensity.clone(),
    );
    (registry, carbon_intensity)
}

impl CarbonIntensityLabel {
    pub fn with_location(location: impl Into<String>) -> Self {
        CarbonIntensityLabel {
            location: location.into(),
        }
    }
}
