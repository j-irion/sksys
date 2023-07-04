terraform {
	required_providers {
		docker = {
			source = "kreuzwerker/docker"
			version = "3.0.2"
		}
		grafana = {
			source = "grafana/grafana"
			version = "1.42.0"
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
	default = 3001
	description = "Port used to access Grafana."
}
variable "network_id" {
	type = string
	description = "Docker network to attach container to."
}
variable "dashboard_file" {
	type = string
	description = "Path to Grafan Dashboard configuration."
}
variable "datasource" {
	type = object({
		name: string
		type: string
		url: string
		jsonData: any
		secureJsonDataToken: string
		uid: string
	})
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
		internal = 3001
		external = var.port
	}
	env= [
		"GF_AUTH_ANONYMOUS_ORG_ROLE=Admin",
		"GF_AUTH_ANONYMOUS_ENABLED=true",
		"GF_SERVER_HTTP_PORT=3001",
		"GF_SECURITY_ALLOW_EMBEDDING=true"
	]
	volumes {
		host_path = var.dashboard_file
		container_path = "/etc/grafana/provisioning/dashboards/default.json"
		read_only = true
	}
}

provider "grafana" {
	url = "http://localhost:${var.port}"
	auth = "anonymous"
}

resource "grafana_dashboard" "metrics" {
	config_json = file("../../frontend/Dashboard/Dashboards.json")
	depends_on = [ docker_container.grafana ]
}

resource "grafana_data_source" "metrics" {
	name = var.datasource.name
	type = var.datasource.type
	access_mode = "proxy"
	uid = var.datasource.uid
	url = var.datasource.url
	json_data_encoded = jsonencode(var.datasource.jsonData)
	secure_json_data_encoded = jsonencode({
		token = var.datasource.secureJsonDataToken
	})
	depends_on = [ docker_container.grafana ]
}

output "network_name" {
	value = docker_container.grafana.network_data.0.network_name
}
