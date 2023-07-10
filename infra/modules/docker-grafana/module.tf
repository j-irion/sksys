terraform {
	required_providers {
		docker = {
			source = "kreuzwerker/docker"
			version = "3.0.2"
		}
	}
}

resource "docker_image" "grafana" {
	name = "grafana/grafana-oss:10.0.1"
}

resource "docker_container" "main" {
	image = docker_image.grafana.image_id
	name = "${var.name}-grafana"
	hostname = var.name
	ports {
		internal = var.port
		external = var.port
	}
	env = [
		"GF_AUTH_ANONYMOUS_ORG_ROLE=Admin",
		"GF_AUTH_ANONYMOUS_ENABLED=true",
		"GF_SERVER_HTTP_PORT=${var.port}",
		"GF_SECURITY_ALLOW_EMBEDDING=true"
	]
	volumes {
		container_path = "/var/lib/grafana"
		volume_name = docker_volume.data.name
	}
	networks_advanced {
		name = var.network_id
	}
	log_opts = {
		"tag" = "{{.Name}}"
	}
}

resource "docker_volume" "data" {
	name = "${var.name}-data"
}
