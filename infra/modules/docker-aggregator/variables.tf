variable "name" {
	type = string
	description = "Name of container and host"
}

variable "co2_token" {
	type = string
	description = "Token for CO2 Signal API"
	sensitive = true
}

variable "influxdb_url" {
	type = string
	description = "URL to InfluxDB"
}

variable "influxdb_token" {
	type = string
	description = "Token used to insert InfluxDB data"
	sensitive = true
}

variable "network_id" {
	type = string
	default = "default"
}
