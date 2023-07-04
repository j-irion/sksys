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
	length = 32
	special = false
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
	dashboard_file = abspath("../../frontend/Dashboard/Dashboards.json")
	
	datasource = {
		name = "InfluxDB"
		type = "influxdb"
		url = "http://${module.timeseries.hostname}:8086"
		uid = "d61a11c3-4997-441b-b4b5-c756e3c58f6a"
		jsonData = {
			version = "Flux"
			organization = "sksys"
			defaultBucket = "data"
			tlsSkipVerify = true
		}
		secureJsonDataToken = "yaTDKIjLugM0pRbjcdQO4JbW2FVJ5p8J"
	}
}
