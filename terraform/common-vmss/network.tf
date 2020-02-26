module "network" {
  source  = "Azure/network/azurerm"
  version = "2.0.0"
  
  location = var.location
  address_space = var.vnet_cidr
  resource_group_name = var.resource_group_name
  vnet_name = var.vnet_name
  subnet_names = var.names
  subnet_prefixes = var.vmss_subnet_prefixes
}

