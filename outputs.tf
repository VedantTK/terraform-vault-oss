# output "aws_vault_public_ip" {
#   value = module.aws_vault.vault_instance_public_ip
# }

output "gcp_vault_external_ip" {
  value = module.gcp_vault.vault_instance_external_ip
}

output "gcp_vault_internal_ip" {
  value = module.gcp_vault.vault_instance_internal_ip
}

# output "aws_vault_private_ip" {
#   value = module.aws_vault.vault_instance_private_ip
# }