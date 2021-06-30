variable"name" { 
  default = "terraform" 
  description = "Name of resource group and virtual machine"
}

variable "vmss_name" {default = ""}
variable "location" { default = "eastus" }
variable "count" {default = 1}
variable "vmss_sku" {default = "Standard_B1s"}
variable "os_sku" {default = "2016-Datacenter-Server-Core"}
variable "os_version" {default = "latest"}
variable "admin_user" {default = "azuser"}
variable "password" {default = ""}
variable "subnet_id" {}

### vmss for windows
resource "azurerm_windows_virtual_machine_scale_set" "vmss" {
  name = var.vmss_name
  resource_group_name = var.name
  location = var.location
  sku = var.vmss_sku 
  instances = var.count
  admin_password = var.password
  admin_username = var.admin_user
  
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.os_sku 
    version   = var.os_version 
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = azurerm_network_interface.mytfvmss-nic[count.index].name  
    primary = true

    ip_configuration {
      name      = "vmss-ipConfig"
      primary   = true
      subnet_id = var.subnet_id 
      ### mapping with load balancer
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.mytflb-be[count.index].id]
    }
  }

}

resource "azurerm_network_interface" "mytfvmss-nic" {
  count = length(var.vmss_name)

  name = "${var.vmss_name[count.index]}-nic"
  location = azurerm_resource_group.mytfgroup.location
  resource_group_name = azurerm_resource_group.mytfgroup.name

  ip_configuration {
    name = "IpConfiguration-nic"
    subnet_id = azurerm_subnet.mytfsubnet[count.index].id
    private_ip_address_allocation = "Dynamic"  
  }
}

### load balancer
resource "azurerm_public_ip" "mytflb-publicip" {
  count = length(var.lb_list)
  name                = "publicip"
  location            = azurerm_resource_group.mytfgroup.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
}

resource "azurerm_lb" "mytflb" {
  count = length(var.vmss_name) 

  name                = "${var.lb_list[count.index]}-public" 
  location            = azurerm_resource_group.mytfgroup.location
  resource_group_name = azurerm_resource_group.mytfgroup.name
  sku = "Basic" 

  frontend_ip_configuration {
    name = "frontip-web-lb"
    # subnet_id = azurerm_subnet.mytfsubnet[count.index].id
    public_ip_address_id = azurerm_public_ip.mytflb-publicip[count.index].id
  }
}

resource "azurerm_lb_backend_address_pool" "mytflb-be" {
  count = length(var.lb_list)

  resource_group_name = azurerm_resource_group.mytfgroup.name
  loadbalancer_id = azurerm_lb.mytflb[count.index].id
  name = "be-${azurerm_lb.mytflb[count.index].name}"
}

resource "azurerm_network_interface_backend_address_pool_association" "mytflb-public-nic-be" {
  count = length(var.lb_list)
  
  network_interface_id    = azurerm_network_interface.mytfvmss-nic[count.index].id
  ip_configuration_name   = "IpConfiguration-nic"
  backend_address_pool_id = azurerm_lb_backend_address_pool.mytflb-be[count.index].id
}


### internal load balancer
# #### subnet
# resource "azurerm_subnet" "mytfsubnet-lb" {
#   count = length(var.lb_subnet_list)
# 
#   name                 = var.lb_subnet_list[count.index]
#   resource_group_name  = var.rg_name
#   virtual_network_name = var.vnet_name
#   address_prefix       = element(var.lb_subnet_cidr_list, count.index)
# }
 
# 
# resource "azurerm_lb_backend_address_pool" "mytflb-be" {
#   count = length(var.lb_list)
#   
#   resource_group_name = azurerm_resource_group.mytfgroup.name
#   loadbalancer_id = azurerm_lb.mytflb[count.index].id
#   name = "be-${var.lb_list[count.index]}"
# }
# 
# resource "azurerm_network_interface_backend_address_pool_association" "lb-be-pooling" {
# }
# 
# 
# ### public ip
# resource "azurerm_public_ip" "mytflbpip" {
#   count = length(var.lb_list)
# 
#   name                = "${var.lb_list[count.index]}-pubip"
#   location            = azurerm_resource_group.mytfgroup.location
#   resource_group_name = var.rg_name
#   allocation_method   = "Static"
# }
# 
# ### nsg
# resource "azurerm_network_security_group" "mytfnsg" {
# 
#   name = "tfnsg"
#   location            = azurerm_resource_group.mytfgroup.location
#   resource_group_name = var.rgname
#   
#   security_rule {
#       name                       = var.ssh_rulename
#       priority                   = 1001
#       direction                  = "Inbound"
#       access                     = "Allow"
#       protocol                   = "Tcp"
#       source_port_range          = "*"
#       destination_port_range     = var.ssh_port
#       source_address_prefix      = var.jumpbox_ip
#       destination_address_prefix = "*"
#   }
# }
#  
# ### network interface
# resource "azurerm_network_interface" "mytfnic-sub0" {
#   # count = length(var.vms_publicsubnet)
#   count = var.vmcount0 
# 
#   name                = "myNIC-${count.index}"
#   location            = azurerm_resource_group.mytfgroup.location
#   resource_group_name       = var.rgname
#   network_security_group_id = azurerm_network_security_group.mytfnsg.id
# 
#   ip_configuration {
#       name                          = "myNicConfiguration-${count.index}"
#       subnet_id                     = azurerm_subnet.mytfsubnet-public.0.id
#       private_ip_address_allocation = "Dynamic"
#       public_ip_address_id          = azurerm_public_ip.mytfpublicip[count.index].id
#   }
# 
# }
# 
