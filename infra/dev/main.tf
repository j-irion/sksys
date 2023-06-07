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
	mount_path = abspath("../../.dev/auth")
}

module "timeseries_db" {
	source = "../modules/prometheus"

	network_id = docker_network.main.id
	name = "timeseries"
	scrape_configs = [
		{
			job_name = "${docker_container.aggregator.name}"
			scrape_interval = "5s"
			static_configs = [
				{
					targets = [
						"${docker_container.aggregator.hostname}:8000"
					]
				}
			]
		}
	]
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
