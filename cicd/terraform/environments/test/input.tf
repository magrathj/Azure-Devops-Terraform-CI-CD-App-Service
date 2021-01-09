# Azure GUIDS
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

# Resource Group/Location
variable "location" {}
variable "resource_group" {}
variable "application_type" {}

# Tags
variable tier {}
variable deployment {}

# Storage 
variable "storage_account_name" {}
variable "container_name" {}
variable "key" {}
variable "access_key" {}