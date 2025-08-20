output "vault_instance_external_ip" {
  value = google_compute_instance.vault_instance.network_interface[0].access_config[0].nat_ip
}

output "vault_instance_internal_ip" {
  value = google_compute_instance.vault_instance.network_interface[0].network_ip
}
