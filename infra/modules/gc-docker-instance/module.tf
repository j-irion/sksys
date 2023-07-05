terraform {
	required_providers {
		google = {
			source = "hashicorp/google"
			version = "4.72.0"
		}
	}
}

resource "google_compute_instance" "main" {
	name = var.name
	machine_type = var.machine_type
	zone = var.zone

	tags = ["docker"]

	boot_disk {
		initialize_params {
			image = "cos-cloud/cos-stable"
			type = "pd-standard"
			size = var.boot_disk_size
		}
	}

	network_interface {
		network = "default"
		access_config {}
	}
}
