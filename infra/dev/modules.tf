module "postgres" {
	source = "../modules/docker-postgres"

	name = "postgres"
	db_name = "postgres"
	db_user = "root"
	db_passwd = random_password.postgres.result

	network_id = docker_network.default.id
}

module "influxdb" {
	source = "../modules/docker-influxdb"

	name = "influxdb"
	user = "root"
	passwd = random_password.influxdb_passwd.result
	token = random_password.influxdb_token.result
	bucket = "data"

	network_id = docker_network.default.id
}

module "grafana" {
	source = "../modules/docker-grafana"

	name = "grafana"

	network_id = docker_network.default.id
}

module "grafana-config" {
	source = "../modules/grafana-config"

	influxdb_url = module.influxdb.url
	influxdb_bucket = "data"
	influxdb_token = random_password.influxdb_token.result

	depends_on = [
		module.grafana,
		module.influxdb
	]
}

module "aggregator" {
	source = "../modules/docker-aggregator"

	name = "aggregator"
	co2_token = var.co2_token
	influxdb_url = module.influxdb.url
	influxdb_token = random_password.influxdb_token.result
	ingester_url = module.ingester.url

	network_id = docker_network.default.id

	dev = true
}

module "ingester" {
	source = "../modules/docker-ingester"

	name = "ingester"
	influxdb_url = module.influxdb.url
	influxdb_token = random_password.influxdb_token.result
	postgres_url = module.postgres.url
	grafana_base_url = "http://localhost:3000/d-solo/${module.grafana-config.path}?orgId=1&refresh=30s"
	port = 80

	network_id = docker_network.default.id

	dev = true
}
