module "network" {
  source  = "Azure/network/azurerm"
  version = "2.0.0"
  
  resource_group_name = var.resource_group_name
  location = var.location

  vnet_name = var.vnet_name
  address_space = var.vnet_cidr

#   subnet_names = var.name
  subnet_prefixes = var.subnet_prefixes
}

