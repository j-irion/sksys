terraform {
	required_providers {
		google = {
			source = "hashicorp/google"
			version = "~> 4.67.0"
		}
	}
}

variable "gce_project_id" {
	type = string
}

variable "gce_user" {
	type = string
}

variable "ssh_pub_key" {
	type = string
}

provider "google" {
	project = var.gce_project_id
	region = "europe-west3"
	zone = "europe-west3-c"
}

resource "google_compute_instance" "gitlab-runner" {
	name         = "gitlab-runner"
	machine_type = "e2-micro"
	tags         = ["docker", "gitlab-runner"]

	scheduling {
		preemptible = true
		automatic_restart = false
		provisioning_model = "SPOT"
	}

	boot_disk {
		initialize_params {
			image = "cos-cloud/cos-stable"
			type = "pd-standard"
			size = 20
		}
	}

	network_interface {
		network = "default"

		access_config {}
	}
}

output "gce_instance_ip" {
	value = google_compute_instance.gitlab-runner.network_interface.0.access_config.0.nat_ip
}
