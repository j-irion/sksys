#!/usr/bin/env bash

set -xeo pipefail

COMMAND="$1"
shift 1

if [ "$COMMAND" == "init" ]; then
	terraform -chdir=infra/prod/gce init "$@"
	terraform -chdir=infra/prod/docker init "$@"
elif [ "$COMMAND" == "apply" ]; then
	terraform -chdir=infra/prod/gce apply "$@"
	IP_ADDR=$(terraform -chdir=infra/prod/gce output -raw ip_addr)
	terraform -chdir=infra/prod/docker apply -var="gce_instance_host=$IP_ADDR" "$@"
elif [ "$COMMAND" == "destroy" ]; then
	terraform -chdir=infra/prod/docker destroy "$@"
	terraform -chdir=infra/prod/gce destroy "$@"
fi
