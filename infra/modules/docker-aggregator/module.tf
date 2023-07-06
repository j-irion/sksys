terraform {
	required_providers {
		docker = {
			source = "kreuzwerker/docker"
			version = "3.0.2"
		}
	}
}

resource "docker_image" "aggregator" {
	name = "aggregator"
	build {
		dockerfile = abspath("../../../backend/aggregator/Dockerfile")
		context = abspath("../../..")
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
		"RUST_LOG=debug"
	]
}
