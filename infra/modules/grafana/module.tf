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
	default = "9.5.2"
	description = "Label of the used postgres docker image."
}
variable "port" {
	type = number
	default = 3000
	description = "Port used to access Grafana."
}
variable "network_id" {
	type = string
	description = "Docker network to attach container to."
}

resource "docker_image" "grafana" {
	name = "grafana/grafana:${var.image_version}"
}

resource "docker_container" "grafana" {
	name = "${var.name}-grafana"
	hostname = var.name
	image = docker_image.grafana.image_id
	networks_advanced {
		name = var.network_id
	}
	ports {
		internal = 3000
		external = var.port
	}
}

output "network_name" {
	value = docker_container.grafana.network_data.0.network_name
}
