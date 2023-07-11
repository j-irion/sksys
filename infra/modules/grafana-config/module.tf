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
		title = "Client Carbon Footprint"
		editable = false
		refresh = "30s"
		panels = [
			{
				id = 1
				title = "gCO2eq/kWh Länder"
				type = "timeseries"
				gridPos = { x = 0, y = 0, w = 8, h = 14 }
				datasource = {
					type = grafana_data_source.data.type
					uid = grafana_data_source.data.uid
				}
				fieldConfig = {
					defaults = {
						unit = "gCO2eq/kWh"
					}
					overrides = []
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
						|>range(start: v.timeRangeStart, stop: v.timeRangeStop)
						|>filter(fn: (r) => r["_measurement"] == "carbon_intensity")
						|>filter(fn: (r) => r["location"] > "0")
						|>aggregateWindow(every: 15s, fn: mean)
						|>fill(usePrevious: true)
						|>drop(columns: ["_field"])
						EOQ
					}
				]
			},
			{
				id = 3
				title = "Client Carbon Footprint"
				type = "timeseries"
				gridPos = { x = 8, y = 0, w = 16, h = 14 }
				datasource = {
					type = grafana_data_source.data.type
					uid = grafana_data_source.data.uid
				}
				fieldConfig = {
					defaults = {
						unit = "gCO2eq/h"
					}
					overrides = []
				}
				options = {
					legend = {
						displayMode = "table",
						placement = "bottom",
						showLegend = true,
						calcs = ["lastNotNull"],
						values = ["last"]
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
						import "join"

						locations = from(bucket: "${var.influxdb_bucket}")
							|>range(start: v.timeRangeStart, stop: v.timeRangeStop)
							|>filter(fn: (r) => r["_measurement"] == "carbon_intensity")
							|>aggregateWindow(every: 15s, fn: mean)
							|>fill(usePrevious: true)
							|>group(columns: ["location"])
						clients = from(bucket: "${var.influxdb_bucket}")
							|>range(start: v.timeRangeStart, stop: v.timeRangeStop)
							|>filter(fn: (r) => r["_measurement"] == "power_usage")
							|>aggregateWindow(every: 15s, fn: mean)
							|>group(columns: ["location"])

						join.left(
							left: clients,
							right: locations,
							on: (l, r) => l.location == r.location and l._time == r._time,
							as: (l, r) => ({l with _value: l._value * r._value / 1000.0})
						)
						|>group(columns:["machine_id", "location"])
						|>fill(value: 0.0)
						|>drop(columns: ["_start", "_stop"])
						EOQ
					}
				]
			},
			{
				id = 2
				title = "Aktuelles gCO2eq/kWh der Länder"
				type = "piechart"
				gridPos = { x = 0, y = 8, w = 12, h = 8 }
				datasource = {
					type = grafana_data_source.data.type
					uid = grafana_data_source.data.uid
				}
				fieldConfig = {
					defaults = {
						unit = "gCO2eq/kWh"
					}
					overrides = []
				}
				options = {
					legend = {
						placement = "right",
						showLegend = true,
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
						|>range(start: v.timeRangeStart, stop: v.timeRangeStop)
						|>filter(fn: (r) => r["_measurement"] == "carbon_intensity")
						|>filter(fn: (r) => exists r["location"])
						|>last()
						EOQ
					}
				]
			},
			{
				id = 4
				title = "Client Power Consumption"
				type = "piechart"
				gridPos = { x = 12, y = 8, w = 12, h = 8 }
				datasource = {
					type = grafana_data_source.data.type
					uid = grafana_data_source.data.uid
				}
				fieldConfig = {
					defaults = {
						unit = "W"
					}
					overrides = []
				}
				options = {
					legend = {
						placement = "right",
						showLegend = true,
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
						|>filter(fn: (r) => r["_measurement"] == "power_usage")
						|>filter(fn: (r) => exists r["machine_id"])
						|>last()
						EOQ
					}
				]
			}
		]
	})
}
