terraform {
	required_providers {
		grafana = {
			source = "grafana/grafana"
			version = "2.0.0"
		}
	}
}

resource "grafana_data_source" "data" {
	name = "InfluxDB"
	type = "influxdb"
	access_mode = "proxy"
	url = var.influxdb_url
	json_data_encoded = jsonencode({
		version = "Flux"
		organization = "sksys"
		defaultBucket = var.influxdb_bucket
		tlsSkipVerify = true
	})
	secure_json_data_encoded = jsonencode({
		token = var.influxdb_token
	})
}

resource "grafana_dashboard" "main" {
	config_json = jsonencode({
		title = "TODO"
		editable = false
		refresh = "1h"
		panels = [
			{
				id = 1
				title = "gCO2eq/kWh Länder"
				type = "timeseries"
				gridPos = {
					x = 0
					y = 0
					w = 12
					h = 8
				}
				datasource = {
					type = grafana_data_source.data.type
					uid = grafana_data_source.data.uid
				}
				fieldConfig = {
					defaults = {
						unit = "gCO2eq/kWh"
					}
				}
				targets = [
					{
						refId = "A"
						datasource = {
							type = grafana_data_source.data.type
							uid = grafana_data_source.data.uid
						}
						query = <<EOQ
						from(bucket: "${var.influxdb_bucket}")
						|>range(start: -1d)
						|>filter(fn: (r) => r["_measurement"] == "carbon_intensity")
						|>filter(fn: (r) => r["location"] > "0")
						|>drop(columns: ["_field"])
						EOQ
					}
				]
			},
			{
				id = 3
				title = "gCO2eq/kWh Clients"
				type = "timeseries"
				gridPos = {
					x = 12
					y = 0
					w = 12
					h = 8
				}
				datasource = {
					type = grafana_data_source.data.type
					uid = grafana_data_source.data.uid
				}
				fieldConfig = {
					defaults = {
						unit = "gCO2eq/kWh"
					}
				}
				targets = [
					{
						refId = "A"
						datasource = {
							type = grafana_data_source.data.type
							uid = grafana_data_source.data.uid
						}
						query = <<EOQ
						from(bucket: "${var.influxdb_bucket}")
						|>range(start: -1d)
						|>filter(fn: (r) => r["_measurement"] == "carbon_intensity")
						|>filter(fn: (r) => r["id"] > "0")
						|>drop(columns: ["_field"])
						EOQ
					}
				]
			},
			{
				id = 2
				title = "gCO2eq/kWh Clients"
				type = "timeseries"
				gridPos = {
					x = 0
					y = 8
					w = 12
					h = 8
				}
				datasource = {
					type = grafana_data_source.data.type
					uid = grafana_data_source.data.uid
				}
				fieldConfig = {
					defaults = {
						unit = "gCO2eq/kWh"
					}
				}
				targets = [
					{
						refId = "A"
						datasource = {
							type = grafana_data_source.data.type
							uid = grafana_data_source.data.uid
						}
						query = <<EOQ
						from(bucket: "${var.influxdb_bucket}")
						|>range(start: -1d)
						|>filter(fn: (r) => r["_measurement"] == "carbon_intensity")
						|>filter(fn: (r) => r["location"] > "0")
						|>drop(columns: ["_field"])
						EOQ
					}
				]
			},
			{
				id = 4
				title = "Client"
				type = "piechart"
				gridPos = {
					x = 12
					y = 8
					w = 12
					h = 8
				}
				datasource = {
					type = grafana_data_source.data.type
					uid = grafana_data_source.data.uid
				}
				fieldConfig = {
					defaults = {
						unit = "gCO2eq/kWh"
					}
				}
				targets = [
					{
						refId = "A"
						datasource = {
							type = grafana_data_source.data.type
							uid = grafana_data_source.data.uid
						}
						query = <<EOQ
						from(bucket: "${var.influxdb_bucket}")
						|>range(start: -1d)
						|>filter(fn: (r) => r["_measurement"] == "carbon_intensity")
						|>filter(fn: (r) => r["id"] > "0")
						|>drop(columns: ["_field"])
						EOQ
					}
				]
			}
		]
	})
}
