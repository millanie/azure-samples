output "linux_vm_private_ips" {
  value = azurerm_linux_virtual_machine.lterraform.private_ip_address 
}

output "linux_vm_public_ip" {
  value = azurerm_linux_virtual_machine.lterraform.public_ip_address 
}

output "windows_vm_public_ip" {
  value = azurerm_windows_virtual_machine.wterraform.public_ip_address 
}

output "windows_vm_private_ips" {
  value = azurerm_windows_virtual_machine.wterraform.private_ip_address 
}

