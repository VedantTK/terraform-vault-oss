variable "project" {}
variable "region" {}
variable "zone" {}
variable "gcp_credentials" {
  description = "Base64-encoded GCP service account key"
  type        = string
  sensitive   = true
}
variable "name" { default = "gcp-vault" }
variable "machine_type" { default = "e2-micro" }
variable "image" { default = "debian-cloud/debian-11" }
