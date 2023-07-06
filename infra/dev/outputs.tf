output "postgres_password" {
	value = random_password.postgres.result
	sensitive = true
}

output "influxdb_password" {
	value = random_password.influxdb_passwd.result
	sensitive = true
}

output "influxdb_token" {
	value = random_password.influxdb_token.result
	sensitive = true
}
