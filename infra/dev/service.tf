resource "docker_image" "aggregator" {
	name = "aggregator"

	build {
		context = "${path.module}/../.."
		dockerfile = "${path.module}/../../backend/aggregator/Dockerfile"
	}
}

resource "docker_container" "aggregator" {
	name = "aggregator"
	hostname = "aggregator"
	image = docker_image.aggregator.image_id
	networks_advanced {
		name = docker_network.main.id
	}
	
	env = [
		"API_TOKEN=${var.co2signal_token}",
		"INFLUXDB_URL=http://${module.timeseries.hostname}:8086",
		"INFLUXDB_TOKEN=${random_password.timeseries_token.result}",
		"RUST_LOG=debug",
	]
}

resource "docker_image" "ingester" {
	name = "ingester"

	build {
		context = "${path.module}/../.."
		dockerfile = "${path.module}/../../backend/ingester/Dockerfile"
	}
}

resource "docker_container" "ingester" {
	name = "ingester"
	hostname = "ingester"
	image = docker_image.ingester.image_id
	networks_advanced {
		name = docker_network.main.id
	}
	
	env = [
		"INFLUXDB_URL=http://${module.timeseries.hostname}:8086",
		"INFLUXDB_TOKEN=${random_password.timeseries_token.result}",
		"DATABASE_URL=postgres://auth:${random_password.auth_db_password.result}@${module.auth_db.hostname}/auth",
		"BIND_ADDR=0.0.0.0:8000",
		"RUST_LOG=debug",
	]

	ports {
		internal = 8000
		external = 8000
	}
}
