use reqwest::{Client, Url};
use serde::{Deserialize, Serialize};

/// Simplified version of carbon intensity response see
/// https://docs.co2signal.com/#get-latest-by-geographic-coordinate.
#[derive(Deserialize, Serialize, Debug)]
#[allow(non_snake_case)]
pub struct CarbonIntensity {
    countryCode: String,
    data: CarbonIntensityData,
}

#[derive(Deserialize, Serialize, Debug)]
#[allow(non_snake_case)]
pub struct CarbonIntensityData {
    carbonIntensity: f64,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct Error {
    #[serde(alias = "message")]
    error: String,
}

/// Send request to electricity maps to get the current carbon intensity data from the given
/// `country_code`. Will return `-1` if request was not successful.
pub async fn fetch_intensity(
    client: &Client,
    country_code: impl Into<String>,
) -> reqwest::Result<Option<f64>> {
    let zone = country_code.into();
    let params = &[("countryCode", zone)];
    let url = Url::parse_with_params("https://api.co2signal.com/v1/latest", params).unwrap();
    let response = client.get(url).send().await?;
    if !response.status().is_success() {
        let error: Error = response.json().await?;
        tracing::error!("{}", error.error);
        return Ok(None);
    }
    let response: CarbonIntensity = response.json().await?;
    tracing::debug!("{response:#?}");
    Ok(Some(response.data.carbonIntensity))
}
