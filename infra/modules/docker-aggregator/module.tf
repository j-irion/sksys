terraform {
	required_providers {
		docker = {
			source = "kreuzwerker/docker"
			version = "3.0.2"
		}
	}
}

resource "docker_image" "aggregator" {
	count = var.dev? 1: 0
	name = "aggregator"
	build {
		dockerfile = "${path.module}/../../../backend/aggregator/Dockerfile"
		context = "${path.module}/../../.."
	}
}


resource "docker_container" "main" {
	image = var.dev? docker_image.aggregator.0.image_id: "git.tu-berlin.de:5000/r.oleynik/sksys/aggregator"
	name = var.name
	hostname = var.name

	env = [
		"API_TOKEN=${var.co2_token}",
		"INFLUXDB_URL=${var.influxdb_url}",
		"INFLUXDB_TOKEN=${var.influxdb_token}",
		"INGESTER_URL=${var.ingester_url}",
		"RUST_LOG=debug"
	]

	networks_advanced {
		name = var.network_id
	}
}
