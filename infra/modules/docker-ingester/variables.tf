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
