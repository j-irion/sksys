terraform {
	required_providers {
		docker = {
			source  = "kreuzwerker/docker"
			version = "3.0.2"
		}
	}
}

variable "docker_ssh_host" {
	type = string
}

variable "ssh_priv_key" {
	type = string
	sensitive = true
}

provider "docker" {
	host = var.docker_ssh_host
	ssh_opts = [
		"-i", var.ssh_priv_key,
		"-o", "UserKnownHostsFile=/dev/null",
		"-o", "StrictHostKeyChecking=no"
	]
}

resource "docker_image" "gitlab-runner" {
  name = "gitlab/gitlab-runner:alpine"
}

resource "docker_container" "gitlab-runner" {
  name    = "gitlab-runner"
  image   = docker_image.gitlab-runner.image_id
  restart = "always"

  volumes {
    host_path      = abspath("${path.module}/config.toml")
    container_path = "/etc/gitlab-runner/config.template.toml"
  }

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }
}
