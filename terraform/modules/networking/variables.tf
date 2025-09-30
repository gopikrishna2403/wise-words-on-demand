# Networking Module Variables

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
}

variable "vnet_address_space" {
  description = "Address space for the VNet"
  type        = list(string)
}

variable "subnet_configs" {
  description = "Configuration for subnets"
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = list(string)
  }))
}

variable "dns_servers" {
  description = "Custom DNS servers"
  type        = list(string)
  default     = []
}

variable "dns_zone_name" {
  description = "Custom DNS zone name"
  type        = string
  default     = ""
}
