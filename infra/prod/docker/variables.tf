variable "gce_instance_host" {
	type = string
	description = "IP Address/Hostname used to deploy docker in"
}

variable "gce_priv_key_file" {
	type = string
	description = "Path to private SSH key used by gcloud"
	sensitive = true
}
