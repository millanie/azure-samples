output "linux_vm_private_ips" {
  value = azurerm_linux_virtual_machine.monitoring.private_ip_address 
}

output "linux_vm_public_ip" {
  value = azurerm_linux_virtual_machine.monitoring.public_ip_address 
}

# output "windows_vm_public_name"{
#   value = "${module.windowsservers.public_ip_dns_name}"
# }
# 
# output "windows_vm_public_ip" {
#   value = "${module.windowsservers.public_ip_address}"
# }
# 
# output "windows_vm_private_ips" {
#   value = "${module.windowsservers.network_interface_private_ip}"
# }
# 
