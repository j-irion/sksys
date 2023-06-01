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
	default = "v2.44.0"
	description = "Label of the used postgres docker image."
}

variable "port" {
	type = number
	default = 9090
	description = "Port used to access Prometheus container."
}

resource "docker_image" "prometheus" {
	name = "prom/prometheus:${var.image_version}"
}

resource "docker_container" "influxdb" {
	name = "${var.name}-prometheus"
	image = docker_image.prometheus.image_id
	ports {
		internal = 9090
		external = var.port
	}
}

output "network_name" {
	value = docker_container.influxdb.network_data.0.network_name
}
