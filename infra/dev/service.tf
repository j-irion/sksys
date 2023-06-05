resource "docker_image" "aggergator" {
	name = "aggregator"

	build {
		context = "${path.module}/../.."
		dockerfile = "${path.module}/../../backend/aggregator/Dockerfile"
	}
}

resource "docker_container" "aggregator" {
	name = "aggregator"
	image = docker_image.aggergator.image_id
	
	env = [
		"API_TOKEN=${var.co2signal_token}",
		"RUST_LOG=trace"
	]

	ports {
		internal = 8000
		external = 8000
	}
}
