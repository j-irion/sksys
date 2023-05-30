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
	value = "2.7.1-apline"
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

variable "config_mount_path" {
	type = string
	description = "Directory used to mount config."
}

variable "data_mount_path" {
	type = string
	description = "Directory used to mount data."
}

variable "port" {
	type = number
	value = 8086
	description = "Port used to access InfluxDB container."
}

resource "docker_image" "influxdb" {
	name = "influxdb:${var.image_version}"
}

resource "docker_container" "influxdb" {
	name = "${var.name}-influxdb"
	image = docker_image.influxdb.image_id
	env = [
		"DOCKER_INFLUXDB_INIT_USERNAME=${var.user}",
		"DOCKER_INFLUXDB_INIT_PASSWORD=${var.password}",
		"DOCKER_INFLUXDB_INIT_ORG=${var.org}",
		"DOCKER_INFLUXDB_INIT_BUCKET=${var.bucket}",
	]
	mounts {
		target = "/var/lib/influxdb2"
		source = var.data_mount_path
	}
	mounts {
		target = "/etc/influxdb2"
		source = var.config_mount_path
	}
	ports {
		internal = 8086
		external = var.port
	}
}

output "network_name" {
	type = string
	value = docker_container.influxdb.network_data.network_name
}
