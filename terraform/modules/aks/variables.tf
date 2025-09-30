# AKS Module Variables

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

variable "aks_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "vnet_subnet_id" {
  description = "Subnet ID for AKS nodes"
  type        = string
}

variable "pod_subnet_id" {
  description = "Subnet ID for AKS pods"
  type        = string
  default     = null
}

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
  default = {}
}

variable "service_cidr" {
  description = "CIDR for Kubernetes services"
  type        = string
  default     = "10.1.0.0/16"
}

variable "dns_service_ip" {
  description = "IP address for Kubernetes DNS service"
  type        = string
  default     = "10.1.0.10"
}

variable "pod_cidr" {
  description = "CIDR for Kubernetes pods"
  type        = string
  default     = "10.2.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones for the cluster"
  type        = list(string)
  default     = ["1", "2", "3"]
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

variable "private_dns_zone_id" {
  description = "Private DNS zone ID for private cluster"
  type        = string
  default     = null
}

variable "disk_encryption_set_id" {
  description = "Disk encryption set ID"
  type        = string
  default     = null
}


variable "enable_workload_identity" {
  description = "Enable workload identity"
  type        = bool
  default     = true
}

variable "enable_csi_secret_store" {
  description = "Enable CSI Secret Store"
  type        = bool
  default     = true
}

variable "enable_azure_policy" {
  description = "Enable Azure Policy"
  type        = bool
  default     = true
}

variable "workload_identity_client_id" {
  description = "Client ID for workload identity"
  type        = string
  default     = null
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
