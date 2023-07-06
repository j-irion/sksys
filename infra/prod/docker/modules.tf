module "postgres" {
	source = "../../modules/docker-postgres"

	name = "postgres"
	db_name = "postgres"
	db_user = "root"
	db_passwd = random_password.postgres.result
}
