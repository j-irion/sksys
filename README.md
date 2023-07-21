# Green Log

## Required Tools

- [yarn](https://yarnpkg.com/)
- [Terraform](https://www.terraform.io/)
- [Docker](https://www.docker.com/)

Development Tools:

- `cargo`/`rust` recommended way of installation: https://rustup.rs/

## Usage

> Note: A local rust is not required. You can use the provided Dockerfiles to build the Rust-Services.

This application can be deployed in two ways:

1. Deploy to a local Docker Engine, using the [Dev Environment](./infra#using-dev-environment)
2. Deploy to Google Cloud, using the [Production Deployment](./infra#production-deployment)

A running instance can be found under: http://34.159.153.108

## Project Structure

Our project contains of following artifacts:

- `./frontend/admin` SPA written in Vue. Used to edit the clients.
- `./frontend/client` SPA written in Vue. Used to simulate clients and test the application.
- `./backend/ingester` API service written in Rust. Used to access Database and add push Client metrics.
- `./backend/aggregator` API service written in Rust. Used to aggregate region specific carbon intensity.
- `./infra` Terraform Infrastructure. See [`infra/README.md`](./infra) for more details.

## Contributing

Before creating new commits, please run the following command to update the git hooks:

```sh
yarn
```
