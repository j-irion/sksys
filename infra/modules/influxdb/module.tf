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
	description = "InfluxDB service name"
}
variable "user" {
	type = string
}
variable "password" {
	type = string
	sensitive = true
}
variable "network_id" {
	type = string
}
variable "port" {
	type = number
	default = 8086
}

resource "docker_image" "influxdb" {
	name = "influxdb:2.7.1-alpine"
}

resource "docker_volume" "influxdb_data" {
	name = "${var.name}-influxdb"
}

resource "docker_container" "influxdb" {
	image = docker_image.influxdb.image_id
	name = "${var.name}-influxdb"
	hostname = var.name
	ports {
		internal = 8086
		external = var.port 
	}
	networks_advanced {
		name = var.network_id
	}
	env = [
		"DOCKER_INFLUXDB_INIT_MODE=setup",
		"DOCKER_INFLUXDB_INIT_USERNAME=${var.user}",
		"DOCKER_INFLUXDB_INIT_PASSWORD=${var.password}",
		"DOCKER_INFLUXDB_INIT_ORG=sksys",
		"DOCKER_INFLUXDB_INIT_BUCKET=data",
	]
	volumes {
		container_path = "/var/lib/influxdb"
		volume_name = docker_volume.influxdb_data.name
	}
}

output "hostname" {
	value = docker_container.influxdb.hostname
}
