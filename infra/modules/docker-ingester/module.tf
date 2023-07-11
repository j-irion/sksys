terraform {
	required_providers {
		docker = {
			source = "kreuzwerker/docker"
			version = "3.0.2"
		}
	}
}

resource "docker_image" "ingester" {
	name = var.dev? "ingester": "git.tu-berlin.de:5000/r.oleynik/sksys/ingester"
	dynamic "build" {
		for_each = var.dev? [0]: []
		content {
			dockerfile = "${path.module}/../../../backend/ingester/Dockerfile"
			context = "${path.module}/../../.."
		}
	}
}

resource "docker_container" "main" {
	image = docker_image.ingester.image_id
	name = var.name
	hostname = var.name

	env = [
		"INFLUXDB_URL=${var.influxdb_url}",
		"INFLUXDB_TOKEN=${var.influxdb_token}",
		"DATABASE_URL=${var.postgres_url}",
		"BIND_ADDR=0.0.0.0:${var.port}",
		"GRAFANA_BASE_URL=${var.grafana_base_url}",
		"SERVE_DIR=/dist",
		"RUST_LOG=debug"
	]

	log_opts = {
		"tag" = "{{.Name}}"
	}

	networks_advanced {
		name = var.network_id
	}

	ports {
		internal = var.port
		external = var.port
	}
}
