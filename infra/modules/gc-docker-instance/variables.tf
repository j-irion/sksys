variable "name" {
	type = string
	description = "Name of the google cloud instance"
}

variable "machine_type" {
	type = string
	description = "Machine type to use (e.g. e2-micro)"
}

variable "zone" {
	type = string
	description = "Zone to deploy in (e.g. europe-west3-a)"
}

variable "boot_disk_size" {
	type = number
	description = "Number of GiB used for boot disk"
}

variable "ports" {
	type = list(number)
	description = "Ports to open"
	default = []
}
