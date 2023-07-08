variable "name" {
	type = string
	description = "Container and host name used for this container"
}

variable "token" {
	type = string
	description = "Admin token for InfluxDB access"
	sensitive = true
}

variable "user" {
	type = string
	description = "Root user name"
}

variable "passwd" {
	type = string
	description = "Root password name"
	sensitive = true
}

variable "bucket" {
	type = string
	description = "Name of the root bucket"
}

variable "port" {
	type = number
	default = 8086
	description = "Port used by this database"
}

variable "network_id" {
	type = string
	default = "default"
}
