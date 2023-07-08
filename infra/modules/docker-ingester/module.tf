terraform {
	required_providers {
		docker = {
			source = "kreuzwerker/docker"
			version = "3.0.2"
		}
	}
}

resource "docker_image" "ingester" {
	count = var.dev? 1: 0
	name = var.name
	build {
		dockerfile = "${path.module}/../../../backend/ingester/Dockerfile"
		context = "${path.module}/../../.."
	}
}

resource "docker_container" "main" {
	image = var.dev? docker_image.ingester.0.image_id: "git.tu-berlin.de:5000/r.oleynik/sksys/ingester"
	name = var.name
	hostname = var.name

	env = [
		"INFLUXDB_URL=${var.influxdb_url}",
		"INFLUXDB_TOKEN=${var.influxdb_token}",
		"DATABASE_URL=${var.postgres_url}",
		"BIND_ADDR=0.0.0.0:${var.port}",
		"SERVE_DIR=/dist",
		"RUST_LOG=debug"
	]

	networks_advanced {
		name = var.network_id
	}

	ports {
		internal = var.port
		external = var.port
	}
}