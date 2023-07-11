use std::{net::SocketAddr, sync::Arc};

use axum::{
    extract::{Path, State},
    routing::{get, post},
    Json, Router,
};
use chrono::{DateTime, Utc};
use influxdb::{Client, InfluxDbWriteable};
use rand::{distributions::Alphanumeric, Rng};
use serde::{Deserialize, Serialize};
use sqlx::PgPool;
use tower_http::{
    services::{ServeDir, ServeFile},
    trace::TraceLayer,
};

mod error {
    use axum::{http::StatusCode, response::IntoResponse};

    #[derive(thiserror::Error, Debug)]
    pub enum Error {
        #[error("an error ocured with the database")]
        Sqlx(#[from] sqlx::Error),
        #[error("an error ocured with the database")]
        InfluxDb(#[from] influxdb::Error),
        #[error("user may not perform that action")]
        Forbidden,
    }

    impl Error {
        fn status_code(&self) -> StatusCode {
            match self {
                Self::Sqlx(sqlx::Error::RowNotFound) => StatusCode::NOT_FOUND,
                Self::Sqlx(_) => StatusCode::INTERNAL_SERVER_ERROR,
                Self::InfluxDb(_) => StatusCode::INTERNAL_SERVER_ERROR,
                Self::Forbidden => StatusCode::FORBIDDEN,
            }
        }
    }

    pub type Result<T> = std::result::Result<T, Error>;

    impl IntoResponse for Error {
        fn into_response(self) -> axum::response::Response {
            (self.status_code(), self.to_string()).into_response()
        }
    }
}

fn default_query() -> String {
    "power_usage".to_owned()
}

#[derive(Deserialize)]
struct EnvConfig {
    influxdb_url: String,
    #[serde(default = "default_query")]
    influxdb_query: String,
    influxdb_token: String,
    grafana_base_url: String,
    database_url: String,
    serve_dir: std::path::PathBuf,
    bind_addr: SocketAddr,
}

pub(crate) struct AppState {
    config: EnvConfig,
    influxdb_client: Client,
    db_pool: PgPool,
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

    let db_pool = sqlx::postgres::PgPoolOptions::new()
        .max_connections(16)
        .connect(&config.database_url)
        .await
        .unwrap();

    sqlx::migrate!().run(&db_pool).await.unwrap();

    let influxdb_client =
        Client::new(&config.influxdb_url, "data").with_token(&config.influxdb_token);

    let client_dir = config.serve_dir.join("client");

    let bind_addr = config.bind_addr;
    let app = Router::new()
        .nest(
            "/api",
            Router::new()
                .route("/admin/devices", get(get_all_devices).post(create_device))
                .route(
                    "/admin/devices/:device_id",
                    get(get_device).post(update_device).delete(delete_device),
                )
                .route("/locations", get(get_locations))
                .route("/submit", post(submit_data))
                .route("/dashboard", get(dashboard)),
        )
        .nest_service(
            "/client",
            ServeDir::new(&client_dir).fallback(ServeFile::new(client_dir.join("index.html"))),
        )
        .nest_service(
            "/",
            ServeDir::new(&config.serve_dir)
                .fallback(ServeFile::new(config.serve_dir.join("index.html"))),
        )
        .with_state(Arc::new(AppState {
            config,
            influxdb_client,
            db_pool,
        }))
        .layer(TraceLayer::new_for_http());

    axum::Server::bind(&bind_addr)
        .serve(app.into_make_service())
        .await
        .unwrap();
}

#[derive(InfluxDbWriteable, Debug)]
struct PowerUsageData {
    time: DateTime<Utc>,
    used_power: f64,
    #[influxdb(tag)]
    location: String,
    #[influxdb(tag)]
    machine_id: i32,
}

#[derive(Serialize, Debug)]
struct Device {
    id: i32,
    name: String,
    description: String,
    location: String,
}

#[derive(Deserialize, Debug)]
struct NewDevice {
    name: String,
    description: String,
    location: String,
}

async fn get_all_devices(
    State(state): State<Arc<AppState>>,
) -> crate::error::Result<Json<Vec<Device>>> {
    let devices = sqlx::query_as!(
        Device,
        "SELECT id, name, description, location FROM devices"
    )
    .fetch_all(&state.db_pool)
    .await?;

    Ok(Json(devices))
}

#[derive(Serialize, Debug)]
struct NewDeviceKey {
    key: String,
}

async fn create_device(
    State(state): State<Arc<AppState>>,
    Json(new_device): Json<NewDevice>,
) -> crate::error::Result<Json<NewDeviceKey>> {
    let key = rand::thread_rng()
        .sample_iter(&Alphanumeric)
        .take(120)
        .map(char::from)
        .collect::<String>();

    sqlx::query!(
        "INSERT INTO devices (name, description, location, authtoken) VALUES ($1, $2, $3, $4)",
        new_device.name,
        new_device.description,
        new_device.location,
        key
    )
    .execute(&state.db_pool)
    .await?;

    Ok(Json(NewDeviceKey { key }))
}

async fn get_device(
    Path(id): Path<i32>,
    State(state): State<Arc<AppState>>,
) -> crate::error::Result<Json<Device>> {
    let device = sqlx::query_as!(
        Device,
        "SELECT id, name, description, location FROM devices WHERE id = $1",
        id
    )
    .fetch_one(&state.db_pool)
    .await?;

    Ok(Json(device))
}

async fn update_device(
    Path(id): Path<i32>,
    State(state): State<Arc<AppState>>,
    Json(new_device): Json<NewDevice>,
) -> crate::error::Result<()> {
    sqlx::query!(
        "UPDATE devices SET name = $1, description = $2, location = $3 WHERE id = $4",
        new_device.name,
        new_device.description,
        new_device.location,
        id
    )
    .execute(&state.db_pool)
    .await?;
    Ok(())
}

async fn delete_device(
    Path(id): Path<i32>,
    State(state): State<Arc<AppState>>,
) -> crate::error::Result<()> {
    sqlx::query!("DELETE FROM devices WHERE id = $1", id)
        .execute(&state.db_pool)
        .await?;
    Ok(())
}

async fn get_locations(
    State(state): State<Arc<AppState>>,
) -> crate::error::Result<Json<Vec<String>>> {
    let locs = sqlx::query!("SELECT DISTINCT location FROM devices")
        .map(|r| r.location)
        .fetch_all(&state.db_pool)
        .await?;
    Ok(Json(locs))
}

async fn dashboard(State(state): State<Arc<AppState>>) -> String {
    state.config.grafana_base_url.clone()
}

#[derive(Deserialize, Debug)]
struct MachineTags {
    machine_id: i32,
    location: String,
}

mod unix_date_format {
    use chrono::{DateTime, NaiveDateTime, Utc};
    use serde::{self, Deserialize, Deserializer};

    pub fn deserialize<'de, D>(deserializer: D) -> Result<DateTime<Utc>, D::Error>
    where
        D: Deserializer<'de>,
    {
        let s = i64::deserialize(deserializer)?;
        Ok(DateTime::<Utc>::from_utc(
            NaiveDateTime::from_timestamp_opt(s, 0).unwrap(),
            Utc,
        ))
    }
}

#[derive(Deserialize, Debug)]
struct Submission {
    #[serde(with = "unix_date_format")]
    timestamp: DateTime<Utc>,
    used_power: f64,
    authtoken: String,
}

async fn submit_data(
    State(state): State<Arc<AppState>>,
    Json(submission): Json<Submission>,
) -> crate::error::Result<()> {
    let machine_info = sqlx::query_as!(
        MachineTags,
        "SELECT id as machine_id, location FROM devices WHERE authtoken = $1",
        submission.authtoken
    )
    .fetch_one(&state.db_pool)
    .await
    .map_err(|e| {
        use crate::error::Error;
        match e.into() {
            Error::Sqlx(sqlx::Error::RowNotFound) => Error::Forbidden,
            e => e,
        }
    })?;

    let pud = PowerUsageData {
        time: submission.timestamp,
        used_power: submission.used_power,
        location: machine_info.location,
        machine_id: machine_info.machine_id,
    };

    state
        .influxdb_client
        .query(
            vec![pud]
                .into_iter()
                .map(|e| e.into_query(&state.config.influxdb_query))
                .collect::<Vec<_>>(),
        )
        .await?;

    Ok(())
}
