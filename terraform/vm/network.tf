module "network" {
  source  = "Azure/network/azurerm"
  version = "2.0.0"
  
  resource_group_name = var.resource_group_name
  location = var.location

  vnet_name = var.vnet_name
  address_space = var.vnet_cidr

  subnet_names = var.subnet_names
  subnet_prefixes = var.subnet_prefixes
}

### attach nsg on the subnet
# resource "azurerm_network_security_group" "example" {
#   name                = "example-nsg"
#   resource_group_name = var.resource_group_name
#   location = var.location
# 
#   security_rule {
#     name                       = ""
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }
# 
# 
# resource "azurerm_subnet_network_security_group_association" "example" {
#     count = length(var.subnet_prefixes)
# 
#    subnet_id                 = module.network.vnet_subnets[count.index]
#    network_security_group_id = azurerm_network_security_group.example.id
# }
