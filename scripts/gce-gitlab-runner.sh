#!/bin/sh

set -xe

GCE_COMPUTE_PATH="infra/gce-compute"
GITLAB_RUNNER_PATH="infra/gitlab-runner"

SSH_PRIV_KEY="$HOME/.ssh/google_compute_engine"
SSH_PUB_KEY="$HOME/.ssh/google_compute_engine.pub"

if [ ! -f "$GCE_COMPUTE_PATH/terraform.tfvars" ]; then
	echo "enter project id:"
	read -r GCE_PROJECT_ID

	tee "$GCE_COMPUTE_PATH/terraform.tfvars" << EOF
gce_project_id = "$GCE_PROJECT_ID"
gce_user = "gitlab-runner"
ssh_pub_key = "$SSH_PUB_KEY"
EOF
else
	cat "$GCE_COMPUTE_PATH/terraform.tfvars"
fi

	if [ "$1" = "destroy" ]; then
	terraform -chdir="$GITLAB_RUNNER_PATH" destroy
	terraform -chdir="$GCE_COMPUTE_PATH" destroy
elif [ "$1" = "apply" ]; then
	terraform -chdir="$GCE_COMPUTE_PATH" apply || exit
	GCE_INSTANCE_IP=$(terraform -chdir="$GCE_COMPUTE_PATH" output -raw "gce_instance_ip")
	tee "$GITLAB_RUNNER_PATH/terraform.tfvars" << EOF
docker_ssh_host = "ssh://gitlab-runner@$GCE_INSTANCE_IP"
ssh_priv_key = "$SSH_PRIV_KEY"
EOF
	sleep 10
	terraform -chdir="$GITLAB_RUNNER_PATH" apply || exit
elif [ "$1" = "register" ]; then
	echo "Name of Runner:"
	read -r RUNNER_NAME
	echo "GitLab URL:"
	read -r GITLAB_URL
	echo "Token:"
	read -r GITLAB_TOKEN
	GCE_INSTANCE_IP=$(terraform -chdir="$GCE_COMPUTE_PATH" output -raw "gce_instance_ip")
	ssh -i "$HOME/.ssh/google_compute_engine.pub" \
		-o UserKnownHostsFile=/dev/null \
		-o StrictHostKeyChecking=no \
		-l gitlab-runner -- "$GCE_INSTANCE_IP" \
		docker exec gitlab-runner gitlab-runner register -n \
			--name "$RUNNER_NAME" \
			-u "$GITLAB_URL" \
			-r "$GITLAB_TOKEN" \
			--executor "docker" \
			--docker-image "alpine"
else
	terraform -chdir="$GCE_COMPUTE_PATH" init || exit
	terraform -chdir="$GITLAB_RUNNER_PATH" init || exit
fi
