# Wise Words on Demand - Terraform Variables

# General Configuration
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "wise-words"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "West US 2"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "DevOps Team"
}

# Networking Configuration
variable "vnet_address_space" {
  description = "Address space for the VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_configs" {
  description = "Configuration for subnets"
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = list(string)
  }))
  default = {
    "aks-subnet" = {
      address_prefixes  = ["10.0.1.0/24"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    }
    "pod-subnet" = {
      address_prefixes  = ["10.0.2.0/24"]
      service_endpoints = []
    }
    "bastion-subnet" = {
      address_prefixes  = ["10.0.3.0/24"]
      service_endpoints = []
    }
    "sql-subnet" = {
      address_prefixes  = ["10.0.4.0/24"]
      service_endpoints = ["Microsoft.Sql"]
    }
  }
}

variable "dns_servers" {
  description = "Custom DNS servers"
  type        = list(string)
  default     = []
}

# AKS Configuration
variable "system_node_pool" {
  description = "System node pool configuration"
  type = object({
    name                = string
    vm_size             = string
    node_count          = number
    min_count           = number
    max_count           = number
    enable_auto_scaling = bool
    os_disk_size_gb     = number
    os_disk_type        = string
  })
  default = {
    name                = "system"
    vm_size             = "Standard_D2s_v3"
    node_count          = 2
    min_count           = 1
    max_count           = 3
    enable_auto_scaling = true
    os_disk_size_gb     = 30
    os_disk_type        = "Managed"
  }
}

variable "user_node_pools" {
  description = "User node pools configuration"
  type = map(object({
    vm_size             = string
    node_count          = number
    min_count           = number
    max_count           = number
    enable_auto_scaling = bool
    os_disk_size_gb     = number
    os_disk_type        = string
    node_taints         = list(string)
    node_labels         = map(string)
  }))
  default = {
    "user-pool" = {
      vm_size             = "Standard_D4s_v3"
      node_count          = 1
      min_count           = 1
      max_count           = 5
      enable_auto_scaling = true
      os_disk_size_gb     = 50
      os_disk_type        = "Managed"
      node_taints         = []
      node_labels = {
        "workload" = "application"
      }
    }
  }
}

variable "enable_workload_identity" {
  description = "Enable workload identity add-on"
  type        = bool
  default     = true
}

variable "enable_csi_secret_store" {
  description = "Enable CSI Secret Store add-on"
  type        = bool
  default     = true
}

# Database Configuration
variable "sql_databases" {
  description = "SQL databases to create"
  type = map(object({
    collation   = string
    max_size_gb = number
    sku_name    = string
  }))
  default = {
    "wise-words-db" = {
      collation   = "SQL_Latin1_General_CP1_CI_AS"
      max_size_gb = 2
      sku_name    = "Basic"
    }
  }
}


variable "azure_tenant_id" {
  description = "Azure tenant ID"
  type        = string
  default     = ""
}

variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = ""
}

# Certificate Configuration
variable "cert_manager_email" {
  description = "Email address for cert-manager"
  type        = string
  default     = "admin@example.com"
}


# Security Configuration
variable "enable_bastion" {
  description = "Enable Azure Bastion"
  type        = bool
  default     = true
}

variable "enable_acr" {
  description = "Enable Azure Container Registry"
  type        = bool
  default     = true
}

variable "enable_key_vault" {
  description = "Enable Azure Key Vault"
  type        = bool
  default     = true
}

# Front Door Configuration (Optional)
variable "enable_front_door" {
  description = "Enable Azure Front Door"
  type        = bool
  default     = false
}

variable "front_door_domain" {
  description = "Domain name for Front Door"
  type        = string
  default     = ""
}

# Additional Variables
variable "kubernetes_version" {
  description = "Kubernetes version for AKS"
  type        = string
  default     = "1.30.14"
}

variable "admin_group_object_ids" {
  description = "Object IDs of admin groups"
  type        = list(string)
  default     = []
}

variable "api_server_authorized_ip_ranges" {
  description = "Authorized IP ranges for API server"
  type        = list(string)
  default     = []
}

variable "private_cluster_enabled" {
  description = "Enable private cluster"
  type        = bool
  default     = false
}

variable "sql_admin_username" {
  description = "SQL Server administrator username"
  type        = string
  default     = "sqladmin"
}

variable "sql_admin_password" {
  description = "SQL Server administrator password"
  type        = string
  sensitive   = true
  default     = null
}

variable "azure_ad_admin_login" {
  description = "Azure AD administrator login"
  type        = string
  default     = null
}

variable "availability_zones" {
  description = "Availability zones for the cluster"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "public_network_access_enabled" {
  description = "Enable public network access for SQL Server"
  type        = bool
  default     = false
}


variable "workload_identity_namespace" {
  description = "Namespace for workload identity service account"
  type        = string
  default     = "default"
}

variable "workload_identity_service_account" {
  description = "Service account name for workload identity"
  type        = string
  default     = "workload-identity-sa"
}


variable "ingress_dns_label" {
  description = "DNS label for the ingress controller"
  type        = string
  default     = ""
}

variable "create_sample_ingress" {
  description = "Create a sample ingress for testing"
  type        = bool
  default     = false
}

variable "sample_domain" {
  description = "Domain name for the sample ingress"
  type        = string
  default     = "sample.example.com"
}

# Vulnerability Assessment
variable "enable_vulnerability_assessment" {
  description = "Enable SQL Server vulnerability assessment"
  type        = bool
  default     = false
}
