resource "random_string" "fqdn_win" {
 length  = 6
 special = false
 upper   = false
 number  = false
}

resource "azurerm_public_ip" "wmonitoring" {
  name = "${var.vm_name}-w-pip"
  resource_group_name = var.resource_group_name
  location = var.location
  allocation_method = "Static"
  domain_name_label = random_string.fqdn_win.result
}

resource "azurerm_network_interface" "wmonitoring" {
  name                = "${var.vm_name}-w-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.vm_name}-w-nic-config"
    subnet_id                     = module.network.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.wmonitoring.id
    #primary = true
  }
}

resource "azurerm_windows_virtual_machine" "wmonitoring" {
  name                = "${var.vm_name}-w"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_sku 

  admin_username      = var.admin_user
  admin_password      = var.password
  network_interface_ids = [
    azurerm_network_interface.wmonitoring.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.w_os_sku[0] 
    offer     = var.w_os_sku[1]
    sku       = var.w_os_sku[2]
    version   = var.w_os_sku[3]
  }
}

resource "azurerm_network_interface_security_group_association" "wmonitoring" {
  network_interface_id = azurerm_network_interface.wmonitoring.id
  network_security_group_id = azurerm_network_security_group.wmonitoring.id
}

resource "azurerm_network_security_group" "wmonitoring" {
  name = "${var.vm_name}-w-nsg"
  resource_group_name = var.resource_group_name
  location = var.location
}

resource "azurerm_network_security_rule" "wmonitoring" {
    name = var.rule_name
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*" 
    source_address_prefixes = [var.client_ip]
    destination_port_range = var.rdp_port
    destination_address_prefix = "*"
    resource_group_name = var.resource_group_name
    network_security_group_name = azurerm_network_security_group.wmonitoring.name
}

 resource "azurerm_network_security_rule" "wgrafana" {
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
    network_security_group_name = azurerm_network_security_group.wmonitoring.name
}

