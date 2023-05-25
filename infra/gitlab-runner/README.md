# Deploy a GitLab Runner

__Requirements__:

- [Terraform](https://www.terraform.io/)
- [Docker](https://www.docker.com/)

## Preparation

Run `terraform init` to initialize this deployment.

## Deploy and Destroy the Runner

Use the following commands to deploy or destroy the runner:

```sh
# Deploy/Create GitLab Runner
terraform apply -var-file="variables.tfvars"

# Destroy GitLab Runner
terraform destroy
```

## Register Gitlab Runner

Deploying a GitLab Runner does not register it to GitLab. You can fix this by running the following command in your terminal.

```sh
docker exec gitlab-runner gitlab-runner register --name "ci-runner-1" \
    --registration-token "_REDACTED_" \
    --template-config /etc/gitlab-runner/config.template.toml \
    --non-interactive
```

> **Note:** You can retrieve the `registration-token` by going to `Settings > CI/CD > Runners`.
