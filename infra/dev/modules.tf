module "postgres" {
	source = "../modules/docker-postgres"

	name = "postgres"
	db_name = "postgres"
	db_user = "root"
	db_passwd = random_password.postgres.result
}

module "influxdb" {
	source = "../modules/docker-influxdb"

	name = "influxdb"
	user = "root"
	passwd = random_password.influxdb_passwd.result
	token = random_password.influxdb_token.result
	bucket = "data"
}

module "grafana" {
	source = "../modules/docker-grafana"

	name = "grafana"
}

module "grafana-config" {
	source = "../modules/grafana-config"

	influxdb_url = "http://${module.influxdb.host}:8086"
	influxdb_bucket = "data"
	influxdb_token = random_password.influxdb_token.result

	depends_on = [
		module.grafana,
		module.influxdb
	]
}
