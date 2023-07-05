output "url" {
	value = "postgres://${var.db_user}:${var.db_passwd}@${var.name}:${var.port}/${var.db_name}"
	description = "URL used to access this database"
	sensitive = true
}
