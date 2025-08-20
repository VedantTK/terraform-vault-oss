output "vault_instance_public_ip" {
  value = aws_instance.vault_instance.public_ip
}

output "vault_instance_private_ip" {
  value = aws_instance.vault_instance.private_ip
}
