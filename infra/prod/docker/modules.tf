module "postgres" {
	source = "../../modules/docker-postgres"

	name = "postgres"
	db_name = "postgres"
	db_user = "root"
	db_passwd = random_password.postgres.result
}

module "influxdb" {
	source = "../../modules/docker-influxdb"

	name = "influxdb"
	user = "root"
	passwd = random_password.influxdb_passwd.result
	token = random_password.influxdb_token.result
	bucket = "data"
}
