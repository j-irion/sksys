module "instance" {
	source = "../../modules/gc-docker-instance"

	name = "sksys-runtime"
	machine_type = "e2-micro"
	zone = "europe-west3-a"

	boot_disk_size = 20

	ports = [ 80, 3000 ]
}
