output "ip_addr" {
	value = var.gce_instance_host
}

output "postgres_password" {
	value = random_password.postgres.result
	sensitive = true
}
