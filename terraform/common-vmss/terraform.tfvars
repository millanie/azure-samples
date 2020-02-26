resource_group_name = "Terraform"
location = "eastus"

### virtual network
vnet_name = "vnet"
vnet_cidr = "10.7.0.0/16"

vmss_count = 3
names = ["web","app","data"]
vmss_subnet_prefixes = ["10.7.0.0/24","10.7.10.0/24","10.7.20.0/24"]
instance_count = 1

application_ports = [80, 81, 82] 

vmss_sku = ["Standard_B1s","Standard_B1s","Standard_B1s"]
os_sku = ["2016-Datacenter-Server-Core","2016-Datacenter-Server-Core","2016-Datacenter-Server-Core"]

admin_user = "azuser"
password = "azure123!@#"
