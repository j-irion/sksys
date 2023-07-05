terraform {
	required_providers {
		google = {
			source = "hashicorp/google"
			version = "4.72.0"
		}
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

provider "google" {
	project = var.gce_project_id
}

provider "docker" {
	host = "ssh://sksys@${module.instance.ip_addr}"
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
