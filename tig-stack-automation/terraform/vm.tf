resource "random_string" "fqdn" {
 length  = 6
 special = false
 upper   = false
 number  = false
}

resource "azurerm_public_ip" "monitoring" {
  name = "${var.vm_name}-pip"
  resource_group_name = var.resource_group_name
  location = var.location
  allocation_method = "Static"
  domain_name_label = random_string.fqdn.result
}

resource "azurerm_network_interface" "monitoring" {
  name                = "monitoring-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "monitoring-nic-config"
    subnet_id                     = module.network.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.monitoring.id
  }
}

resource "azurerm_linux_virtual_machine" "monitoring" {
  name                = var.vm_name 
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_sku 

  admin_username      = var.admin_user
  admin_password      = var.password
  disable_password_authentication = false 
  network_interface_ids = [
    azurerm_network_interface.monitoring.id,
  ]

  # admin_ssh_key {
  #   username   = "adminuser"
  #   public_key = file("~/.ssh/id_rsa.pub")
  # }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.os_sku[0] 
    offer     = var.os_sku[1]
    sku       = var.os_sku[2]
    version   = var.os_sku[3]
  }
}

resource "azurerm_network_security_group" "monitoring" {
  name = "${var.vm_name}-nsg"
  resource_group_name = var.resource_group_name
  location = var.location
}

resource "azurerm_network_security_rule" "monitoring" {
    name = var.rule_name
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*" 
    destination_port_range = var.jumpbox_port 
    source_address_prefix = var.jumpbox_ip
    destination_address_prefix = "*"
    resource_group_name = var.resource_group_name
    network_security_group_name = azurerm_network_security_group.monitoring.name
}

resource "azurerm_network_security_rule" "grafana" {
    name = "grafana"
    priority = 110
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*" 
    destination_port_range = var.grafana_port
    source_address_prefix = var.client_ip
    destination_address_prefix = "*"
    resource_group_name = var.resource_group_name
    network_security_group_name = azurerm_network_security_group.monitoring.name
}

