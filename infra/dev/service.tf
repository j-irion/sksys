resource "docker_image" "aggergator" {
	name = "aggregator"

	build {
		context = "${path.module}/../.."
		dockerfile = "${path.module}/../../backend/aggregator/Dockerfile"
	}
}

resource "docker_container" "aggregator" {
	name = "aggregator"
	hostname = "aggregator"
	image = docker_image.aggergator.image_id
	networks_advanced {
		name = docker_network.main.id
	}
	
	env = [
		"API_TOKEN=${var.co2signal_token}",
		"RUST_LOG=debug"
	]

	ports {
		internal = 8000
		external = 8000
	}
}
