output "url" {
	value = "http://${docker_container.main.hostname}:${var.port}"
}
