terraform {
	required_providers {
		google = {
			source = "hashicorp/google"
			version = "4.72.0"
		}
	}
}

provider "google" {
	project = var.gce_project_id
}
