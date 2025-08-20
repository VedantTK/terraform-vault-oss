terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "google" {
  credentials = base64decode(var.gcp_credentials)
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}

# module "aws_vault" {
#   source         = "./modules/aws-vault"
#   region         = var.aws_region
#   ami_id         = var.aws_ami
#   instance_type  = var.aws_instance_type
# }

module "gcp_vault" {
  source         = "./modules/gcp-vault"
  project        = var.gcp_project
  region         = var.gcp_region
  zone           = var.gcp_zone
  gcp_credentials = var.gcp_credentials
  machine_type   = var.gcp_machine_type
  image          = var.gcp_image
}

