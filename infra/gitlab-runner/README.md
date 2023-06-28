# Deploy a GitLab Runner

Contains the deployment for a gitlab-runner on GCE.

**Requirements**:

- [Terraform](https://www.terraform.io/)
- [Docker](https://www.docker.com/)
- [gcloud CLI](https://cloud.google.com/sdk/gcloud/)

## Preparation

Run the following command to initialize this deployment:

```sh
# Run in project root
./scripts/gce-gitlab-runner.sh init
```

## Deploy and Destroy the Runner

Use the following commands to deploy or destroy the runner:

```sh
# Run in project root

# Deploy/Create GitLab Runner
./scripts/gce-gitlab-runner.sh apply

# Destroy GitLab Runner
./scripts/gce-gitlab-runner.sh destroy
```

## Register Gitlab Runner

Deploying a GitLab Runner does not register it to GitLab. You can fix this by running the following command in your terminal.

```sh
# Run in project root
./scripts/gce-gitlab-runner.sh register
```

> **Note:** You can retrieve the `registration-token` by going to `Settings > CI/CD > Runners`.
