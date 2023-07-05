output "ip_addr" {
	value = module.instance.ip_addr
}

output "postgres_password" {
	value = random_password.postgres.result
	sensitive = true
}
