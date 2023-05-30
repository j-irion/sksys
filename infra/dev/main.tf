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

resource "random_password" "auth_db_password" {
	length = 24
}

resource "random_password" "timeseries_db_password" {
	length = 24
}

module "auth_db" {
	source = "../modules/postgres"

	name = "auth"
	db = "auth"
	user = "auth"
	password = random_password.auth_db_password.result
	mount_path = abspath("../../.dev/auth")
}

module "timeseries_db" {
	source = "../modules/influxdb"

	name = "timeseries"
	user = "time"
	password = random_password.timeseries_db_password.result

	org = "sksys"
	bucket = "sksys"

	config_path = abspath("../../.dev/influxdb/config")
	data_path = abspath("../../.dev/influxdb/data")
}

module "dashboard" {
	source = "../modules/grafana"

	name = "dashboard"
}

output "auth_postgres_password" {
	value = random_password.auth_db_password.result
	sensitive = true
}

output "timeseries_influxdb_password" {
	value = random_password.timeseries_db_password.result
	sensitive = true
}
