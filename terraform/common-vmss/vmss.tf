resource "random_string" "fqdn" {
 length  = 6
 special = false
 upper   = false
 number  = false
}


resource "azurerm_public_ip" "vmss" {
 count = var.vmss_count 

 name  = "vmss-public-ip-${count.index}"
 location = var.location
 resource_group_name = var.resource_group_name 
 allocation_method = "Static"
 domain_name_label = "${random_string.fqdn.result}-${count.index}"
}

resource "azurerm_lb" "vmss" {
 count = var.vmss_count

 name                = "vmss-lb-${var.names[count.index]}"
 location            = var.location
 resource_group_name = var.resource_group_name 

 frontend_ip_configuration {
   name                 = "PublicIPAddress-${var.names[count.index]}"
   public_ip_address_id = azurerm_public_ip.vmss[count.index].id
 }

}

resource "azurerm_lb_backend_address_pool" "bpepool" {
 count = var.vmss_count

 resource_group_name = var.resource_group_name 
 loadbalancer_id     = azurerm_lb.vmss[count.index].id
 name                = "BackEndAddressPool-${var.names[count.index]}"
}
 
resource "azurerm_lb_probe" "vmss" {
 count = var.vmss_count

 resource_group_name = var.resource_group_name 
 loadbalancer_id     = azurerm_lb.vmss[count.index].id
 name                = "ssh-running-probe"
 port                = var.application_ports[count.index]
}

resource "azurerm_lb_rule" "lbnatrule" {
 count = var.vmss_count
 
 resource_group_name = var.resource_group_name 
 loadbalancer_id     = azurerm_lb.vmss[count.index].id
 name                           = "http"
 protocol                       = "Tcp"
 frontend_port                  = var.application_ports[count.index]
 backend_port                   = var.application_ports[count.index]
 backend_address_pool_id        = azurerm_lb_backend_address_pool.bpepool[count.index].id
 frontend_ip_configuration_name = "PublicIPAddress-${var.names[count.index]}"
 probe_id                       = azurerm_lb_probe.vmss[count.index].id
}

resource "azurerm_windows_virtual_machine_scale_set" "vmss" {
  count = var.vmss_count
 
  name  = "vmss-${var.names[count.index]}"
  location = var.location
  resource_group_name = var.resource_group_name 
  sku = var.vmss_sku[count.index]
  instances = var.instance_count
  upgrade_mode = "Manual"
  admin_username = var.admin_user
  admin_password = var.password

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.os_sku[count.index]
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite" 
  }

  network_interface { 
    name    = "vmss-${var.names[count.index]}-nic" 
    primary = true
 
    ip_configuration {
      name      = "vmss-ipConfig-${count.index}"
      primary   = true
      subnet_id = module.network.vnet_subnets[count.index]
      ### mapping with load balancer
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool[count.index].id]
    }
  }

}
