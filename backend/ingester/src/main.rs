use axum::Router;
use serde::Deserialize;
use serde::Serialize;

#[derive(Deserialize, Serialize)]
struct EnvConfig {}

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

    let app = Router::new();
    
}
