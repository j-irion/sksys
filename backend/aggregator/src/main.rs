use std::time::Duration;

use chrono::{DateTime, Utc};
use influxdb::InfluxDbWriteable;
use reqwest::header::HeaderMap;
use serde::{Deserialize, Serialize};
use tokio::time::{sleep_until, Instant};

mod carbon;

#[derive(Deserialize, Serialize, Debug)]
pub struct EnvConfig {
    api_token: String,
    influxdb_url: String,
    influxdb_token: String,
    fetch_interval: Option<u64>,
    ingester_url: String,
}

#[derive(InfluxDbWriteable)]
struct CarbonIntensityData {
    time: DateTime<Utc>,
    carbon_intensity: f64,
    #[influxdb(tag)]
    location: String,
}

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt::init();

    let config: EnvConfig = match envy::from_env() {
        Ok(config) => config,
        Err(envy::Error::MissingValue(name)) => {
            tracing::error!("missing environment variable {}", name.to_uppercase());
            panic!()
        }
        Err(envy::Error::Custom(err)) => {
            tracing::error!("{err}");
            panic!()
        }
    };
    tracing::debug!("config = {config:#?}");

    let db_client =
        influxdb::Client::new(config.influxdb_url, "data").with_token(config.influxdb_token);

    db_client.ping().await.unwrap();

    let fetch_interval = Duration::from_secs(config.fetch_interval.unwrap_or(3600));
    let mut headers = HeaderMap::new();
    let api_key = config.api_token.parse().expect("invalid api key");
    headers.insert("auth-token", api_key);
    let co2_client = reqwest::Client::builder()
        .default_headers(headers)
        .build()
        .unwrap();
    loop {
        let now = Instant::now();

        // TODO: fetch locations
        let locations: Vec<String> =
            match reqwest::get(format!("{}/api/locations", config.ingester_url)).await {
                Ok(response) => match response.json().await {
                    Ok(result) => result,
                    Err(err) => {
                        tracing::error!("{err}");
                        Vec::new()
                    }
                },
                Err(err) => {
                    tracing::error!("request error: {err}");
                    Vec::new()
                }
            };

        let mut data = Vec::new();
        for location in locations {
            tracing::trace!(message = "fetch location data", location = location);
            let carbon_intensity = match carbon::fetch_intensity(&co2_client, &location).await {
                Ok(Some(result)) => result,
                Ok(None) => continue,
                Err(err) => {
                    tracing::error!("{err}");
                    continue;
                }
            };
            tracing::info!(location = location, intensity = carbon_intensity);
            let datapoint = CarbonIntensityData {
                time: Utc::now(),
                carbon_intensity,
                location: location.to_string(),
            };
            data.push(datapoint);
        }
        let query = data
            .into_iter()
            .map(|e| e.into_query("carbon_intensity"))
            .collect::<Vec<_>>();
        match db_client.query(query).await {
            Ok(query) => tracing::info!(message = "query completed", result = query),
            Err(err) => tracing::error!("{err}"),
        }

        let next = now + fetch_interval;
        tracing::trace!("wait for {} seconds", fetch_interval.as_secs());
        sleep_until(next).await;
    }
}
