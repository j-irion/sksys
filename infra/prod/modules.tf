module "instance" {
	source = "../modules/gc-docker-instance"

	name = "sksys-runtime"
	machine_type = "e2-micro"
	zone = "europe-west3-a"

	boot_disk_size = 10
}

module "postgres" {
	source = "../modules/docker-postgres"

	name = "postgres"
	db_name = "postgres"
	db_user = "root"
	db_passwd = random_password.postgres.result
}
