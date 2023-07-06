variable "name" {
	type = string
	description = "Container and host name"
}

variable "db_user" {
	type = string
	description = "Root user name"
}

variable "db_passwd" {
	type = string
	description = "Root user password"
	sensitive = true
}

variable "db_name" {
	type = string
	description = "Name of the database"
}

variable "port" {
	type = number
	default = 5432
	description = "Port used by this database. Defaults to 5432"
}

variable "network_id" {
	type = string
	default = "default"
}
