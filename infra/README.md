# Infrastructure Deployment with Terraform

This directory contains the infrastructure deployments for this project:

- [x] `modules/` Modules used for parts of the deployment
  - [x] `gc-docker-instance` Deployment of Google Compute Instance with support for Docker
  - [x] `docker-grafana/` Docker deployment of Grafana
  - [x] `docker-influxdb/` Docker deployment of InfluxDB service
  - [x] `docker-postgres/` Docker deployment of Postgres service
  - [x] `docker-ingester/` Docker deployment of Ingester service
  - [x] `docker-aggregator/` Docker deployment of aggregator services
  - [x] `grafana-config/` Grafana Dashboards and Datasources
- [x] `dev/` Deployment to local Docker instance
- [x] `prod/` Deployment to Google Compute Instance

## Using Dev Environment

> This section contains a short guide on how to deploy the dev environment to your local [Docker](https://www.docker.com/).
> You will need [Terraform](https://www.terraform.io/) and Docker to run the following commands.

The dev environment contains of following components:

- PostgreSQL running at `localhost:5432`,
- InfluxDB running at `localhost:8086`,
- Grafana running at `localhost:3000` and
- Admin running at `localhost:80`

### Configure

Before deployment some configuration parameters need to be changed. To do that create a `terraform.tfvars`
file inside `infra/dev` with following content:

```terraform
# You can get a token from https://www.co2signal.com/;
co2_token = "<redacted>"
```

### Deploy

> **Note:** Create a `infra/dev/terraform.tfvars` file to prevent persistently store the CO2signal
> API key.
>
> ```terraform
> co2_token = "<CO2 Signal>"
> ```

These services can be easily deployed using Terraform by running:

```sh
# Run inside project root

terraform -chdir=infra/dev init
# and
terraform -chdir=infra/dev apply
```

Terraform will prompt you to confirm deployment. Type `yes` in your terminal to confirm deployment.

### Credentials

As part of the deployment Terraform will generate a random password for the PostgreSQL and InfluxDB
service. You can access these passwords by running one of the following commands:

```sh
# Get PostgreSQL password
terraform -chdir="infra/dev" output postgres_password

# Get InfluxDB root user password
terraform -chdir="infra/dev" output influxdb_password
# Get InfluxDB root token
terraform -chdir="infra/dev" output influxdb_token
```

In addition, the dev environment uses following login credentials:

- PostgreSQL: `db=postgres`, `user=root` and password see above
- InfluxDB: `user=root`, for password or access token see above

### Destroy/Delete all Data

The following command will destroy the infrastructure and delete persistent data:

```sh
terraform -chdir=infra/dev destroy
```

You have to confirm the destruction with `yes`.

## Production Deployment

Requirements:

- `gcloud`
- `docker`
- `ssh`
- `terraform`

The production deployment consists of two stages:

1. Deploying a compute instance to Google Cloud Platform and
2. deploying docker container to the created VM.

Before we can start our deployment, we need to configure our stages.

```terraform
# infra/prod/gce/terraform.tfvars
gce_project_id = "<Google Cloud Project Id>"
```

In addition, we need to configure the second stage:

```terraform
# infra/prod/docker/terraform.tfvars
gce_priv_key_file = "~/.ssh/google_compute_engine"
co2_token = "<CO2 Signal Token>" # Get at https://www.co2signal.com/
registry_username = "<TU-GitLab Username>"
registry_password = "<TU-GitLab Registry Password>"
```

> **Note:** This projects uses GitLab's internal container registry hosted by TU.
> To access the stored containers, it is necessary to have read access (e.g. as Guest).

Our deployment Run the following commands:

```sh
./infra/prod/run.sh init
./infra/prod/run.sh apply
```

You may need to run the following command to create an SSH key, in case the second deployment stage
fails:

```sh
gcloud compute ssh sksys@sksys-runtime --command "docker version"
```

Rerun `./infra/prod/run.sh apply`
