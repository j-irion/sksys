terraform {
	required_providers {
		docker = {
			source = "kreuzwerker/docker"
			version = "3.0.2"
		}
		local = {
			source = "hashicorp/local"
			version = "2.4.0"
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

variable "scrape_configs" {
	type = list(any)
	default = []
	description = "Custom Prometheus scrape config"
}

locals {
	config_file = "${path.module}/prometheus.yaml"
}

resource "local_file" "prometheus_config" {
	filename = local.config_file
	content = yamlencode({
		global = {
			scrape_interval = "15s"
			evaluation_interval = "15s"
		}
		scrape_configs = var.scrape_configs
	})
}

resource "docker_image" "prometheus" {
	name = "prom/prometheus:${var.image_version}"
}

resource "docker_container" "prometheus" {
	name = "${var.name}-prometheus"
	image = docker_image.prometheus.image_id
	ports {
		internal = 9090
		external = var.port
	}
	volumes {
		container_path = "/etc/prometheus/prometheus.yml"
		host_path = abspath(local_file.prometheus_config.filename)
		read_only = true
	}

	depends_on = [ local_file.prometheus_config ]
}

output "network_name" {
	value = docker_container.prometheus.network_data.0.network_name
}
