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

	tags = ["docker", "allow-tcp-8000", "allow-tcp-3000"]

	boot_disk {
		initialize_params {
			image = "cos-cloud/cos-stable"
			type = "pd-standard"
			size = var.boot_disk_size
		}
	}

	network_interface {
		network = google_compute_network.default.name
		access_config {}
	}
}

resource "google_compute_firewall"  "default" {
	name = "${var.name}-firewall"
	network = google_compute_network.default.name

	source_ranges = ["0.0.0.0/0"]

	allow {
		protocol = "tcp"
		ports = ["22"]
	}
	allow {
		protocol = "tcp"
		ports = var.ports
	}
}

resource "google_compute_network" "default" {
	name = "${var.name}-network"
}
