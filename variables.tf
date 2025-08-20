# AWS
variable "aws_region" { default = "us-west-2" }
variable "aws_ami" {}
variable "aws_instance_type" { default = "t2.micro" }

# GCP
variable "gcp_project" {}
variable "gcp_region" { default = "us-central1" }
variable "gcp_credentials" {
  description = "Base64-encoded GCP service account key"
  type        = string
  sensitive   = true
}
variable "gcp_zone" { default = "us-central1-a" }
variable "gcp_machine_type" { default = "e2-micro" }
variable "gcp_image" { default = "ubuntu-os-cloud/ubuntu-2204-lts" } #debian-cloud/debian-11
