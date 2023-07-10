terraform {
	required_providers {
		docker = {
			source = "kreuzwerker/docker"
			version = "3.0.2"
		}
	}
}

resource "docker_image" "aggregator" {
	name = var.dev? "aggregator": "git.tu-berlin.de:5000/r.oleynik/sksys/aggregator"
	dynamic "build" {
		for_each = var.dev? [0]: []
		content {
			dockerfile = "${path.module}/../../../backend/aggregator/Dockerfile"
			context = "${path.module}/../../.."
		}
	}
}


resource "docker_container" "main" {
	image = docker_image.aggregator.image_id
	name = var.name
	hostname = var.name

	env = [
		"API_TOKEN=${var.co2_token}",
		"INFLUXDB_URL=${var.influxdb_url}",
		"INFLUXDB_TOKEN=${var.influxdb_token}",
		"INGESTER_URL=${var.ingester_url}",
		"RUST_LOG=debug"
	]

	log_opts = {
		"tag" = "{{.Name}}"
	}

	networks_advanced {
		name = var.network_id
	}
}
