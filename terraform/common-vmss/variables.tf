variable "resource_group_name" {default = "Terraform"}
variable "location" {default = ""}
variable "vnet_name" {default = ""}
variable "vnet_cidr" {default = ""}
variable "vmss_count" {default = 1}
variable "names" {default = []}
variable "vmss_subnet_prefixes" {default = []}
variable "instance_count" {default = 1}
variable "application_ports" {default = []}

variable "vmss_sku" {default = []}
variable "os_sku" {default = []}

variable "password" {default = ""}
variable "admin_user" {default = "azuser"}

