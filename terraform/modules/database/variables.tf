# Database Module Variables

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

variable "sql_server_name" {
  description = "Name of the SQL Server"
  type        = string
}

variable "sql_databases" {
  description = "SQL databases to create"
  type = map(object({
    collation   = string
    max_size_gb = number
    sku_name    = string
  }))
}

variable "sql_admin_username" {
  description = "SQL Server administrator username"
  type        = string
  default     = "sqladmin"
}

variable "azure_ad_admin_login" {
  description = "Azure AD administrator login"
  type        = string
  default     = null
}

variable "azure_ad_admin_object_id" {
  description = "Azure AD administrator object ID"
  type        = string
  default     = null
}

variable "azure_ad_tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
  default     = null
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = false
}

variable "outbound_network_access_restriction_enabled" {
  description = "Enable outbound network access restriction"
  type        = bool
  default     = false
}

variable "client_ip_ranges" {
  description = "Client IP ranges for firewall rules"
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = {}
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint"
  type        = bool
  default     = true
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoint"
  type        = string
  default     = null
}

variable "private_dns_zone_id" {
  description = "Private DNS zone ID for SQL Server"
  type        = string
  default     = null
}

variable "private_dns_zone_name" {
  description = "Private DNS zone name for SQL Server"
  type        = string
  default     = "privatelink.database.windows.net"
}

variable "private_dns_zone_resource_group" {
  description = "Resource group name for private DNS zone"
  type        = string
  default     = null
}

variable "key_vault_id" {
  description = "Key Vault ID for storing secrets"
  type        = string
  default     = null
}


variable "enable_auditing" {
  description = "Enable SQL Server auditing"
  type        = bool
  default     = true
}

variable "audit_storage_endpoint" {
  description = "Storage endpoint for audit logs"
  type        = string
  default     = null
}

variable "audit_storage_key" {
  description = "Storage key for audit logs"
  type        = string
  sensitive   = true
  default     = null
}

variable "audit_retention_days" {
  description = "Audit log retention days"
  type        = number
  default     = 90
}

variable "enable_security_alert_policy" {
  description = "Enable security alert policy"
  type        = bool
  default     = true
}

variable "security_alert_email_addresses" {
  description = "Email addresses for security alerts"
  type        = list(string)
  default     = []
}

variable "disabled_alerts" {
  description = "Disabled security alerts"
  type        = list(string)
  default     = []
}

variable "security_alert_retention_days" {
  description = "Security alert retention days"
  type        = number
  default     = 30
}

variable "enable_vulnerability_assessment" {
  description = "Enable vulnerability assessment"
  type        = bool
  default     = true
}

variable "vulnerability_assessment_storage_path" {
  description = "Storage path for vulnerability assessment"
  type        = string
  default     = null
}

variable "vulnerability_assessment_storage_key" {
  description = "Storage key for vulnerability assessment"
  type        = string
  sensitive   = true
  default     = null
}

variable "vulnerability_assessment_emails" {
  description = "Email addresses for vulnerability assessment"
  type        = list(string)
  default     = []
}

variable "vulnerability_assessment_storage_account" {
  description = "Storage account name for vulnerability assessment"
  type        = string
  default     = ""
}

variable "vulnerability_assessment_storage_container" {
  description = "Storage container name for vulnerability assessment"
  type        = string
  default     = "vulnerability-assessment"
}
