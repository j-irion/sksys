terraform {
	required_providers {
		docker = {
			source = "kreuzwerker/docker"
			version = "3.0.2"
		}
		random = {
			source = "hashicorp/random"
			version = "3.5.1"
		}
	}
}

provider "docker" {
	host = "ssh://sksys@${var.gce_instance_host}"
	ssh_opts = [
		"-i", var.gce_priv_key_file,
		"-o", "UserKnownHostsFile=/dev/null",
		"-o", "StrictHostKeyChecking=no"
	]
}

resource "random_password" "postgres" {
	length = 32
	special = false
}
