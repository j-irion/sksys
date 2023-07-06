terraform {
	required_providers {
		docker = {
			source = "kreuzwerker/docker"
			version = "3.0.2"
		}
		random = {
			source = "hashicorp/random"
			version = "3.5.1"
		}
		grafana = {
			source = "grafana/grafana"
			version = "2.0.0"
		}
	}
}

provider "random" {}

provider "docker" {}

provider "grafana" {
	url = "http://localhost:3000"
	auth = "anonymous"
}

resource "random_password" "postgres" {
	length = 32
	special = false
}

resource "random_password" "influxdb_passwd" {
	length = 32
	special = false
}

resource "random_password" "influxdb_token" {
	length = 32
	special = false
}

resource "docker_network" "default" {
	name = "sksys"
}
