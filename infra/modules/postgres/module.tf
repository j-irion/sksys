terraform {
	required_providers {
		docker = {
			source = "kreuzwerker/docker"
			version = "3.0.2"
		}
	}
}

variable "name" {
	type = string
	description = "Name of the postgres service. Will deploy container with name '{name}-postgres'."
}

variable "image_version" {
	type = string
	default = "15.3-alpine3.18"
	description = "Label of the used postgres docker image."
}

variable "db" {
	type = string
	description = "Name of postgres db. Will set POSTGRES_DB environment."
}

variable "user" {
	type = string
	description = "Name of postgres user. Will set POSTGRES_USER environment."
}

variable "password" {
	type = string
	sensitive = true
	description = "Password for postgres. Will set POSTGRES_PASSWORD environment."
}

variable "port" {
	type = number
	default = 5432
	description = "Port used to access PostgresSQL container."
}

variable "network_id" {
	type = string
	description = "Docker network to attach container to."
}

resource "docker_image" "postgres" {
	name = "postgres:${var.image_version}"
} 

resource "docker_volume" "postgres_data" {
	name = "${var.name}-postgres"
}

resource "docker_container" "postgres" {
	name  = "${var.name}-postgres"
	hostname = var.name
	image = docker_image.postgres.image_id
	env = [
		"POSTGRES_DB=${var.db}",
		"POSTGRES_USER=${var.user}",
		"POSTGRES_PASSWORD=${var.password}"
	]
	networks_advanced {
		name = var.network_id
	}
	volumes {
		container_path = "/var/lib/postgresql/data"
		volume_name = docker_volume.postgres_data.name
		// host_path = var.mount_path
	}
	ports {
		internal = 5432
		external = var.port
	}
}

output "hostname" {
	value = docker_container.postgres.hostname
}
