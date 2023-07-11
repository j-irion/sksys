variable "name" {
	type = string
	description = "Name of container and host"
}

variable "influxdb_url" {
	type = string
	description = "URL to InfluxDB"
}

variable "influxdb_token" {
	type = string
	description = "Token used to insert InfluxDB data"
}

variable "postgres_url" {
	type = string
	description = "Postgres URL contains login info"
	sensitive = true
}

variable "port" {
	type = number
	description = "Port to open database"
}

variable "network_id" {
	type = string
	default = "default"
}

variable "dev" {
	type = bool
	description = "Build custom docker image"
	default = false
}

variable "grafana_base_url" {
	type = string
}
