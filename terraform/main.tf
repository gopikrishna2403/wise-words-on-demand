# Wise Words on Demand - Azure Infrastructure
# Main Terraform configuration

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "wise-words-tfstate"
    storage_account_name = "wisewordstfstate20250928"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# Configure the Azure Provider
provider "azurerm" {
  # Use default subscription (no subscription_id specified)
  # This will use the subscription from Azure CLI or environment variables

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
    # Enable additional features
    virtual_machine {
      delete_os_disk_on_deletion = true
    }
    template_deployment {
      delete_nested_items_during_deletion = true
    }
  }
}

# Configure the Kubernetes Provider
provider "kubernetes" {
  host                   = module.aks.kube_config_host
  client_certificate     = base64decode(module.aks.kube_config_client_certificate)
  client_key             = base64decode(module.aks.kube_config_client_key)
  cluster_ca_certificate = base64decode(module.aks.kube_config_cluster_ca_certificate)
}

# Configure the Helm Provider
provider "helm" {
  kubernetes {
    host                   = module.aks.kube_config_host
    client_certificate     = base64decode(module.aks.kube_config_client_certificate)
    client_key             = base64decode(module.aks.kube_config_client_key)
    cluster_ca_certificate = base64decode(module.aks.kube_config_cluster_ca_certificate)
  }
}

# Data sources
data "azurerm_client_config" "current" {}

# Local values
locals {
  common_tags = {
    Project     = "Wise Words on Demand"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner
  }

  # Naming convention
  name_prefix = "${var.project_name}-${var.environment}"

  # Resource group names
  rg_networking = "${local.name_prefix}-networking"
  rg_security   = "${local.name_prefix}-security"
  rg_aks        = "${local.name_prefix}-aks"
  rg_database   = "${local.name_prefix}-database"
  rg_ingress    = "${local.name_prefix}-ingress"
}

# Resource Groups
resource "azurerm_resource_group" "networking" {
  name     = local.rg_networking
  location = var.location
  tags     = local.common_tags
}

# Resource Groups - Security Group Now Active
resource "azurerm_resource_group" "security" {
  name     = local.rg_security
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_resource_group" "aks" {
  name     = local.rg_aks
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_resource_group" "database" {
  name     = local.rg_database
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_resource_group" "ingress" {
  name     = local.rg_ingress
  location = var.location
  tags     = local.common_tags
}

# Networking Module
module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.networking.name
  location            = var.location
  environment         = var.environment
  project_name        = var.project_name
  name_prefix         = local.name_prefix
  common_tags         = local.common_tags

  # VNet configuration
  vnet_address_space = var.vnet_address_space
  subnet_configs     = var.subnet_configs

  # DNS configuration
  dns_servers = var.dns_servers
}

# Security Module - Now Active for Step 2
module "security" {
  source = "./modules/security"

  resource_group_name = azurerm_resource_group.security.name
  location            = var.location
  environment         = var.environment
  project_name        = var.project_name
  name_prefix         = local.name_prefix
  common_tags         = local.common_tags

  # Key Vault configuration
  key_vault_name = "${local.name_prefix}-kv"

  # ACR configuration
  acr_name = "${replace(local.name_prefix, "-", "")}acr"

  # Bastion configuration
  bastion_subnet_id = module.networking.bastion_subnet_id

  # Additional configuration
  enable_key_vault           = var.enable_key_vault
  enable_acr                 = var.enable_acr
  enable_bastion             = var.enable_bastion
  enable_workload_identity   = var.enable_workload_identity
  enable_private_endpoints   = true
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  current_user_object_id     = data.azurerm_client_config.current.object_id
  key_vault_subnet_ids       = [module.networking.aks_subnet_id]
  private_endpoint_subnet_id = module.networking.aks_subnet_id
  private_dns_zone_ids       = [module.networking.private_dns_zone_id]
  acr_private_dns_zone_ids   = []
  # SQL admin password from database module
  sql_admin_password = module.database.sql_server_administrator_password
  sql_server_id      = module.database.sql_server_id
}

# AKS Module
module "aks" {
  source = "./modules/aks"

  resource_group_name = azurerm_resource_group.aks.name
  location            = var.location
  environment         = var.environment
  project_name        = var.project_name
  name_prefix         = local.name_prefix
  common_tags         = local.common_tags

  # AKS configuration
  aks_name = "${local.name_prefix}-aks"

  # Networking
  vnet_subnet_id = module.networking.aks_subnet_id
  pod_subnet_id  = module.networking.pod_subnet_id

  # Node pools
  system_node_pool = var.system_node_pool
  user_node_pools  = var.user_node_pools

  # Add-ons
  enable_workload_identity = var.enable_workload_identity
  enable_csi_secret_store  = var.enable_csi_secret_store

  # Additional configuration
  kubernetes_version                = var.kubernetes_version
  admin_group_object_ids            = var.admin_group_object_ids
  api_server_authorized_ip_ranges   = var.api_server_authorized_ip_ranges
  private_cluster_enabled           = var.private_cluster_enabled
  private_dns_zone_id               = module.networking.private_dns_zone_id
  workload_identity_client_id       = module.security.aks_managed_identity_id
  workload_identity_namespace       = var.workload_identity_namespace
  workload_identity_service_account = var.workload_identity_service_account
  availability_zones                = var.availability_zones
}

# Database Module - Now Active for Step 3
module "database" {
  source = "./modules/database"

  resource_group_name = azurerm_resource_group.database.name
  location            = var.location
  environment         = var.environment
  project_name        = var.project_name
  name_prefix         = local.name_prefix
  common_tags         = local.common_tags

  # SQL Server configuration
  sql_server_name = "${local.name_prefix}-sql"

  # Networking
  private_dns_zone_id             = module.networking.private_dns_zone_id
  private_endpoint_subnet_id      = module.networking.sql_subnet_id
  private_dns_zone_name           = "privatelink.database.windows.net"
  private_dns_zone_resource_group = azurerm_resource_group.networking.name

  # Database configuration
  sql_databases                   = var.sql_databases
  sql_admin_username              = var.sql_admin_username
  azure_ad_admin_login            = var.azure_ad_admin_login
  azure_ad_admin_object_id        = data.azurerm_client_config.current.object_id
  azure_ad_tenant_id              = data.azurerm_client_config.current.tenant_id
  public_network_access_enabled   = var.public_network_access_enabled
  enable_private_endpoint         = true
  enable_vulnerability_assessment = var.enable_vulnerability_assessment
}

# Ingress Module
module "ingress" {
  source = "./modules/ingress"

  resource_group_name = azurerm_resource_group.ingress.name
  location            = var.location
  environment         = var.environment
  project_name        = var.project_name
  name_prefix         = local.name_prefix
  common_tags         = local.common_tags

  # AKS configuration
  aks_cluster_id             = module.aks.aks_cluster_id
  aks_cluster_name           = module.aks.aks_cluster_name
  aks_resource_group_name    = azurerm_resource_group.aks.name
  aks_cluster_fqdn           = module.aks.aks_cluster_fqdn
  aks_subnet_id              = module.networking.aks_subnet_id
  aks_client_certificate     = module.aks.kube_config_client_certificate
  aks_client_key             = module.aks.kube_config_client_key
  aks_cluster_ca_certificate = module.aks.kube_config_cluster_ca_certificate

  # Azure configuration
  azure_tenant_id       = var.azure_tenant_id
  azure_subscription_id = var.azure_subscription_id

  # Certificate configuration
  cert_manager_email = var.cert_manager_email

  # Additional configuration
  ingress_dns_label     = var.ingress_dns_label
  aks_oidc_issuer_url   = module.aks.oidc_issuer_url
  create_sample_ingress = var.create_sample_ingress
  sample_domain         = var.sample_domain
}
