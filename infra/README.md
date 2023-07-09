# Infrastructure Deployment with Terraform

This directory contains the infrastructure deployments for this project:

- [x] `gitlab-runner/` A Terraform deployment running a GitLab runner on Docker
- [x] `modules/` Modules used for parts of the deployment

  - [x] `grafana/` Terraform module to deploy Grafana to Docker
  - [x] `influxdb/` Terraform module to deploy InfluxDB to Docker
  - [x] `postgres/` Terraform module to deploy Postgres to Docker

- [x] `dev/` Generic deployment to a local docker.
- [ ] `prod/` Deployment to a Google Cloud hosted docker instance.

## Using Dev Environment

> This section contains a short guide on how to deploy the dev environment to your local [Docker](https://www.docker.com/).
> You will need [Terraform](https://www.terraform.io/) and Docker to run the following commands.

The dev environment contains of following components:

- PostgreSQL running at `localhost:5432`,
- InfluxDB running at `localhost:8086` and
- Grafana running at `localhost:3000`

### Configure

Before deployment some configuration parameters need to be changed. To do that create a `terraform.tfvars`
file inside `infra/dev` with following content:

```terraform
# You can get a token from https://www.co2signal.com/;
co2signal_token = "<redacted>"
```

### Deploy

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
terraform -chdir="infra/dev" output auth_postgres_password

# Get InfluxDB root user password
terraform -chdir="infra/dev" output timeseries_token
# Get InfluxDB root token
terraform -chdir="infra/dev" output timeseries_password
```

In addition, the dev environment uses following login credentials:

- PostgreSQL (auth): `db=auth`, `user=auth` and password see above
- InfluxDB (timeseries): `user=root`, for password or access token see above

### Destroy/Delete all Data

The following command will destroy the infrastructure and delete persistent data:

```sh
terraform -chdir=infra/dev destroy
```

You have to confirm the destruction with `yes`.
