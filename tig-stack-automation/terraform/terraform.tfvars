resource_group_name = "terraform-tig"
location = "eastus"

### virtual network
vnet_name = "monitoring"
vnet_cidr = "10.8.0.0/16"
subnet_prefixes = ["10.8.0.0/24"]

vm_name = "monitoring-tig"
vm_sku = "Standard_DS2_v2"
admin_user = "azuser"
password = "azure123!@#"

os_sku = ["OpenLogic","CentOS","7.6","latest"]

jumpbox_ip = "52.141.29.70"
jumpbox_port = 22
rule_name = "workspace"

