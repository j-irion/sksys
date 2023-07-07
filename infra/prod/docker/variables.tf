variable "gce_instance_host" {
	type = string
	description = "IP Address/Hostname used to deploy docker in"
}

variable "gce_priv_key_file" {
	type = string
	description = "Path to private SSH key used by gcloud"
	sensitive = true
}

variable "co2_token" {
	type = string
	description = "Token for CO2 Signal API"
	sensitive = true
}

variable "registry_username" {
	type = string
	description = "Username of GitLab registry"
	sensitive = true
}

variable "registry_password" {
	type = string
	description = "Password of GitLab registry"
	sensitive = true
}
