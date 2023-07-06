variable "name" {
	type = string
	description = "Container and host name used for this container"
}

variable "port" {
	type = number
	default = 3000
	description = "Port used by this database"
}

variable "network_id" {
	type = string
	default = "default"
}
