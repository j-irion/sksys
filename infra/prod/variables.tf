variable "gce_project_id" {
	type = string
	description = "Project ID used to deploy google compute instance in"
}

variable "gce_priv_key_file" {
	type = string
	description = "Path to private SSH key used by gcloud"
	sensitive = true
}

variable "gce_pub_key_file" {
	type = string
	description = "Path to public SSH key used by gcloud"
	sensitive = true
}
