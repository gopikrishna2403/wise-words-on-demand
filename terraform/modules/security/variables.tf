# Security Module Variables

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

variable "sql_server_id" {
  description = "ID of the SQL Server for role assignments"
  type        = string
}

variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
}

variable "enable_key_vault" {
  description = "Enable Azure Key Vault"
  type        = bool
  default     = true
}

variable "enable_acr" {
  description = "Enable Azure Container Registry"
  type        = bool
  default     = true
}

variable "enable_bastion" {
  description = "Enable Azure Bastion"
  type        = bool
  default     = true
}

variable "enable_workload_identity" {
  description = "Enable workload identity"
  type        = bool
  default     = true
}

variable "enable_private_endpoints" {
  description = "Enable private endpoints"
  type        = bool
  default     = true
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "current_user_object_id" {
  description = "Object ID of the current user"
  type        = string
}

variable "bastion_subnet_id" {
  description = "Subnet ID for Bastion"
  type        = string
}

variable "key_vault_subnet_ids" {
  description = "Subnet IDs for Key Vault network ACLs"
  type        = list(string)
  default     = []
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoints"
  type        = string
  default     = null
}

variable "private_dns_zone_ids" {
  description = "Private DNS zone IDs for Key Vault"
  type        = list(string)
  default     = []
}

variable "acr_private_dns_zone_ids" {
  description = "Private DNS zone IDs for ACR"
  type        = list(string)
  default     = []
}

variable "sql_admin_password" {
  description = "SQL Server administrator password"
  type        = string
  sensitive   = true
  default     = null
}
