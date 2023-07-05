output "auth_postgres_password" {
	value = random_password.auth_db_password.result
	sensitive = true
}
output "timeseries_token" {
	value = random_password.timeseries_token.result
	sensitive = true
}
output "timeseries_password" {
	value = random_password.timeseries_password.result
	sensitive = true
}
