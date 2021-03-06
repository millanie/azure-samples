variable "resource_group_name" {default = "Terraform"}
variable "location" {default = ""}

variable "vnet_name" {default = ""}
variable "vnet_cidr" {default = ""}
variable "subnet_prefixes" {default = []}
variable "subnet_names" {default = []}

variable "password" {default = ""}
variable "admin_user" {default = "azuser"}

variable "vm_name" {default = []}
variable "vm_sku" {default = "Standard_DS1_V2"}

variable "l_os_sku" {default = []}
variable "w_os_sku" {default = []}

variable "jumpbox_ip" {default = ""}
variable "ssh_port" {default = ""}
variable "rdp_port" {default = ""}
variable "rule_name" {default = ""}

variable "client_ip" {default = ""}
variable "grafana_port" {default = "3000"}
