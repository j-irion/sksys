# Aggregator Service

This service is used to fetch carbon intensity data from https://www.co2signal.com.

## Configuration

This service is configured using environment variables:

- `API_TOKEN` Api token from https://www.co2signal.com (required)
- `FETCH_INTERVAL` Interval in seconds to fetch CO2signal (default: 3600).
- `RUST_LOG` Configure service logging level (default: `info`: common values: `trace`, `debug`,
  `warn`; for more details see [Tracing Subscriber Docs](https://docs.rs/tracing-subscriber/0.3.17/tracing_subscriber/filter/struct.EnvFilter.html#directives)).

## Running

> If you want to run this service with Prometheus and other related services see
> [Dev Environment](../../infra/dev/).

You can run this binary using the following command:

```sh
# Run from project root
API_TOKEN="<redacted>" cargo run -p aggregator
```

## Accessing metrics

This service will provide an HTTP interface to access gathered metrics and provides following routes:

- `/metrics` Returns metrics using Prometheus metrics format.
