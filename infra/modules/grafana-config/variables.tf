variable "influxdb_url" {
	type = string
	description = "URL to InfluxDB"
}

variable "influxdb_bucket" {
	type = string
	description = "Default InfluxDB Bucket to use"
}

variable "influxdb_token" {
	type = string
	description = "InfluxDB admin token"
	sensitive = true
}
