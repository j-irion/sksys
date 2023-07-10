terraform {
	required_providers {
		docker = {
			source = "kreuzwerker/docker"
			version = "3.0.2"
		}
	}
}

resource "docker_image" "grafana" {
	name = "influxdb:2.7.1-alpine"
}

resource "docker_container" "main" {
	image = docker_image.grafana.image_id
	name = var.name
	hostname = var.name
	env = [
		"DOCKER_INFLUXDB_INIT_MODE=setup",
		"DOCKER_INFLUXDB_INIT_USERNAME=${var.user}",
		"DOCKER_INFLUXDB_INIT_PASSWORD=${var.passwd}",
		"DOCKER_INFLUXDB_INIT_ORG=sksys",
		"DOCKER_INFLUXDB_INIT_BUCKET=${var.bucket}",
		"DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=${var.token}",
	]
	volumes {
		container_path = "/var/lib/influxdb2"
		volume_name = docker_volume.data.name
	}
	volumes {
		container_path = "/etc/influxdb2"
		volume_name = docker_volume.config.name
	}
	log_opts = {
		"tag" = "{{.Name}}"
	}
	ports {
		internal = 8086
		external = var.port
	}
	networks_advanced {
		name = var.network_id
	}
}

resource "docker_volume" "data" {
	name = "${var.name}-data"
}

resource "docker_volume" "config" {
	name = "${var.name}-conf"
}
