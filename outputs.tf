output "server_name" {
  value = google_compute_instance.vm_instance.name
}

output "ip" {
  value = google_compute_address.static.address
}