resource "docker_image" "gitlab-runner" {
	name = "gitlab/gitlab-runner:alpine"
}

resource "docker_container" "gitlab-runner" {
	name = "gitlab-runner"
	image = docker_image.gitlab-runner.image_id
	restart = "always"

	volumes {
		host_path = abspath("${path.module}/config.toml")
		container_path = "/etc/gitlab-runner/config.template.toml"
	}

	volumes {
		host_path = "/var/run/docker.sock"
		container_path = "/var/run/docker.sock"
	}
}
