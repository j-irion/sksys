terraform {
	required_providers {
		docker = {
			source = "kreuzwerker/docker"
			version = "3.0.2"
		}
	}
}

resource "docker_image" "postgres" {
	name = "postgres:15.3-alpine"
}

resource "docker_container" "main" {
	image = docker_image.postgres.image_id
	name = var.name
	hostname = var.name
	env = [
		"POSTGRES_DB=${var.db_name}",
		"POSTGRES_USER=${var.db_user}",
		"POSTGRES_PASSWORD=${var.db_passwd}"
	]
	volumes {
		container_path = "/var/lib/postgresql/data"
		volume_name = docker_volume.pgdata.name
	}
	ports {
		internal = 5432
		external = var.port
	}
	networks_advanced {
		name = var.network_id
	}
	log_opts = {
		"tag" = "{{.Name}}"
	}
}

resource "docker_volume" "pgdata" {
	name = "${var.name}-pgdata"
}
