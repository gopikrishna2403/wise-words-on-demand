# Ingress Module Variables

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

variable "aks_cluster_id" {
  description = "ID of the AKS cluster"
  type        = string
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "aks_resource_group_name" {
  description = "Resource group name of the AKS cluster"
  type        = string
}

variable "aks_cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  type        = string
}

variable "aks_subnet_id" {
  description = "ID of the AKS subnet for internal load balancer"
  type        = string
}

variable "aks_client_certificate" {
  description = "Base64 encoded client certificate for AKS"
  type        = string
  sensitive   = true
}

variable "aks_client_key" {
  description = "Base64 encoded client key for AKS"
  type        = string
  sensitive   = true
}

variable "aks_cluster_ca_certificate" {
  description = "Base64 encoded cluster CA certificate for AKS"
  type        = string
  sensitive   = true
}

variable "cert_manager_email" {
  description = "Email address for cert-manager"
  type        = string
  default     = "admin@example.com"
}

variable "enable_cert_manager" {
  description = "Enable cert-manager"
  type        = bool
  default     = true
}

variable "ingress_dns_label" {
  description = "DNS label for the ingress controller"
  type        = string
  default     = ""
}

variable "azure_tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "aks_oidc_issuer_url" {
  description = "OIDC issuer URL for the AKS cluster"
  type        = string
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
