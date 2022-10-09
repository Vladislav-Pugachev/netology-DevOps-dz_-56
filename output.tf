output "internal_ip_address_master1" {
  value = yandex_compute_instance.master1.network_interface.0.ip_address
}
output "external_ip_address_master1" {
  value = yandex_compute_instance.master1.network_interface.0.nat_ip_address
}
output "internal_ip_address_worker1" {
  value = yandex_compute_instance.worker1.network_interface.0.ip_address
}
output "external_ip_address_worker1" {
  value = yandex_compute_instance.worker1.network_interface.0.nat_ip_address
}
output "internal_ip_address_worker2" {
  value = yandex_compute_instance.worker2.network_interface.0.ip_address
}
output "external_ip_address_worker2" {
  value = yandex_compute_instance.worker2.network_interface.0.nat_ip_address
}
