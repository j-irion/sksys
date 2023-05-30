# Infrastructure Deployment with Terraform

This directory contains the infrastructure deployments for this project:

-   [x] `gitlab-runner/` A Terraform deployment running a GitLab runner on Docker
-   [x] `modules/` Modules used for parts of the deployment

    -   [x] `grafana/` Terraform module to deploy Grafana to Docker
    -   [x] `indluxdb/` Terraform module to deploy InfluxDB to Docker
    -   [x] `postgres/` Terraform module to deploy Postgres to Docker

-   [x] `dev/` Generic deployment to a local docker.
-   [ ] `prod/` Deployment to a Google Cloud hosted docker.

## Using Dev Environment

> This section contains a short guide on how to deploy the dev environment to your local [Docker](https://www.docker.com/).
> You will need [Terraform](https://www.terraform.io/) and Docker to run the following commands.

The dev environment contains of following components:

-   PostgreSQL running at `localhost:5432`,
-   InfluxDB running at `localhost:8086` and
-   Grafana running at `localhost:3000`

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

# Get InfluxDB password
terraform -chdir="infra/dev" output timeseries_db_password
```

In addition, the dev environment uses following login credentials:

-   PostgreSQL (auth): `db=auth`, `user=auth` and password see above
-   InfluxDB (timeseries): `user=time`, `org=sksys`, `bucket=sksys` and password see above

### Destroy

> **Important:** This will not delete persistent data. If you want to delete this data destroy the infrastructure
> and delete `.dev` directory (you will need root permissions for this)

The following command will destroy the infrastructure:

```sh
terraform -chdir=infra/dev destroy
```

You have to confirm the destruction with `yes`.
