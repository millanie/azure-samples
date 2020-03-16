resource "random_string" "fqdn_win" {
 length  = 6
 special = false
 upper   = false
 number  = false
}

resource "azurerm_public_ip" "terraform" {
  name = "${var.vm_name}-pip"
  resource_group_name = var.resource_group_name
  location = var.location
  allocation_method = "Static"
  domain_name_label = random_string.fqdn_win.result
}

resource "azurerm_network_interface" "terraform" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.vm_name}-nic-config"
    subnet_id                     = module.network.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.terraform.id
  }
}

resource "azurerm_windows_virtual_machine" "terraform" {
  name                = var.vm_name 
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_sku 

  admin_username      = var.admin_user
  admin_password      = var.password
  network_interface_ids = [
    azurerm_network_interface.terraform.id,
  ]

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

resource "azurerm_network_security_group" "terraform" {
  name = "${var.vm_name}-nsg"
  resource_group_name = var.resource_group_name
  location = var.location
}

resource "azurerm_network_security_rule" "terraform" {
    name = var.rule_name
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*" 
    destination_port_range = var.rdp_port
    source_address_prefix = var.client_ip
    destination_address_prefix = "*"
    resource_group_name = var.resource_group_name
    network_security_group_name = azurerm_network_security_group.terraform.name
}

