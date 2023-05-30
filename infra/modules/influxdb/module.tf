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
	description = "Name of the postgres service. Will deploy container with name '{name}-influxdb'."
}

variable "image_version" {
	type = string
	default = "2.7.1-apline"
	description = "Label of the used postgres docker image."
}

variable "user" {
	type = string
	description = "Name of influx user. Will set DOCKER_INFLUXDB_INIT_USERNAME environment."
}

variable "password" {
	type = string
	sensitive = true
	description = "Password for influxdb. Will set DOCKER_INFLUXDB_INIT_PASSWORD environment."
}

variable "org" {
	type = string
	description = "Influxdb's initial organization. Will set DOCKER_INFLUXDB_INIT_ORG environment."
}

variable "bucket" {
	type = string
	description = "Influxdb's initial bucket. Will set DOCKER_INFLUXDB_INIT_BUCKET environment."
}

variable "config_path" {
	type = string
	description = "Path to config directory."
}

variable "data_path" {
	type = string
	description = "Path to data directory."
}

variable "port" {
	type = number
	default = 8086
	description = "Port used to access InfluxDB container."
}

resource "docker_image" "influxdb" {
	name = "influxdb:${var.image_version}"
}

resource "docker_container" "influxdb" {
	name = "${var.name}-influxdb"
	image = docker_image.influxdb.image_id
	env = [
		"DOCKER_INFLUXDB_INIT_MODE=setup",
		"DOCKER_INFLUXDB_INIT_USERNAME=${var.user}",
		"DOCKER_INFLUXDB_INIT_PASSWORD=${var.password}",
		"DOCKER_INFLUXDB_INIT_ORG=${var.org}",
		"DOCKER_INFLUXDB_INIT_BUCKET=${var.bucket}",
	]
	volumes {
		container_path = "/var/lib/influxdb2"
		host_path = var.data_path
	}
	volumes {
		container_path = "/etc/influxdb2"
		host_path = var.config_path
	}
	ports {
		internal = 8086
		external = var.port
	}
}

output "network_name" {
	value = docker_container.influxdb.network_data.0.network_name
}
