use std::net::{Ipv6Addr, SocketAddr};
use std::sync::Arc;
use std::time::Duration;

use axum::http::{HeaderMap, StatusCode};
use axum::routing::get;
use axum::{extract::State, Router};
use prometheus::CarbonIntensityMetric;
use prometheus_client::registry::Registry;
use reqwest::Client;
use serde::{Deserialize, Serialize};
use tokio::time::{sleep_until, Instant};

mod carbon;
mod prometheus;

#[derive(Deserialize, Serialize)]
pub struct EnvConfig {
    api_token: String,
}

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt::init();

    let config: EnvConfig = match envy::from_env() {
        Ok(config) => config,
        Err(envy::Error::MissingValue(name)) => {
            panic!("missing environment variable {}", name.to_uppercase())
        }
        Err(envy::Error::Custom(err)) => {
            tracing::error!("{err}");
            panic!()
        }
    };

    let (registry, metric) = prometheus::setup_registry();

    let handler = tokio::task::spawn(aggergate_metrics(config, metric));

    let app = Router::new()
        .route("/metrics", get(prometheus_metric))
        .with_state(Arc::new(registry));

    let addr = SocketAddr::from((Ipv6Addr::UNSPECIFIED, 8000));
    tracing::info!("listening on {addr}");
    axum::Server::bind(&addr)
        .serve(app.into_make_service())
        .await
        .expect("failed to serve metrics");

    if let Err(err) = handler.await {
        tracing::error!("failed to join aggregate metrics task: {err}");
    }
}

async fn aggergate_metrics(config: EnvConfig, metric: CarbonIntensityMetric) {
    let mut headers = HeaderMap::new();
    let api_key = config.api_token.parse().expect("invalid api key");
    headers.insert("auth-token", api_key);
    let client = Client::builder().default_headers(headers).build().unwrap();
    loop {
        let now = Instant::now();

        // TODO: fetch locations
        const LOCATIONS: &[&str] = &["DE"];

        for location in LOCATIONS {
            tracing::trace!(message = "fetch location data", location = location);
            let carbon_intensity = match carbon::fetch_intensity(&client, *location).await {
                Ok(result) => result,
                Err(err) => {
                    tracing::error!("{err}");
                    continue;
                }
            };
            if let Some(carbon_intensity) = carbon_intensity {
                tracing::debug!(location = location, intensity = carbon_intensity);
                let label = prometheus::CarbonIntensityLabel::with_location(*location);
                metric.get_or_create(&label).set(carbon_intensity);
            }
        }

        let next = now + Duration::from_secs(3600);
        tracing::trace!("wait for 1h");
        sleep_until(next).await;
    }
}

async fn prometheus_metric(State(registry): State<Arc<Registry>>) -> Result<String, StatusCode> {
    tracing::trace!("fetch metrics");
    let mut buffer = String::new();
    prometheus_client::encoding::text::encode(&mut buffer, &registry).map_err(|err| {
        tracing::error!("failed to encode. {err}");
        StatusCode::INTERNAL_SERVER_ERROR
    })?;
    Ok(buffer)
}
