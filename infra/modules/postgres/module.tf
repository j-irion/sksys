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

variable "mount_path" {
	type = string
	description = "Path to mount postgres data to."
}

variable "port" {
	type = number
	default = 5432
	description = "Port used to access PostgresSQL container."
}

resource "docker_image" "postgres" {
	name = "postgres:${var.image_version}"
} 

resource "docker_container" "postgres" {
	name  = "${var.name}-postgres"
	image = docker_image.postgres.image_id
	env = [
		"POSTGRES_DB=${var.db}",
		"POSTGRES_USER=${var.user}",
		"POSTGRES_PASSWORD=${var.password}"
	]
	mounts {
		target = "/var/lib/postgresql/data"
		source = var.mount_path
	}
	ports {
		internal = 5432
		external = var.port
	}
}

output "network_name" {
	value = docker_container.postgres.network_data.network_name
}
