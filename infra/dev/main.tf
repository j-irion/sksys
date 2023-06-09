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
	}
}

provider "docker" {}
provider "random" {}

variable "co2signal_token" {
	description = "API token from https://www.co2signal.com/"
	sensitive = true
}

resource "random_password" "auth_db_password" {
	length = 24
}
resource "random_password" "timeseries_password" {
	length = 24
}
resource "random_password" "timeseries_token" {
	length = 32
	special = false
}

resource "docker_network" "main" {
	name = "app-main"
}

module "auth_db" {
	source = "../modules/postgres"

	network_id = docker_network.main.id
	name = "auth"
	db = "auth"
	user = "auth"
	password = random_password.auth_db_password.result
}

module "timeseries" {
	source = "../modules/influxdb"

	network_id = docker_network.main.id
	name = "timeseries"
	user = "root"
	password = random_password.timeseries_password.result
	token = random_password.timeseries_token.result
}

module "dashboard" {
	source = "../modules/grafana"

	network_id = docker_network.main.id
	name = "dashboard"
}

output "auth_postgres_password" {
	value = random_password.auth_db_password.result
	sensitive = true
}
output "timeseries_token" {
	value = random_password.timeseries_token.result
	sensitive = true
}
output "timeseries_password" {
	value = random_password.timeseries_password.result
	sensitive = true
}
