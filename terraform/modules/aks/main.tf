# AKS Module - Wise Words on Demand

# AKS Cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.aks_name
  kubernetes_version  = var.kubernetes_version
  tags                = var.common_tags

  # Default node pool
  default_node_pool {
    name                = var.system_node_pool.name
    vm_size             = var.system_node_pool.vm_size
    node_count          = var.system_node_pool.node_count
    min_count           = var.system_node_pool.min_count
    max_count           = var.system_node_pool.max_count
    enable_auto_scaling = var.system_node_pool.enable_auto_scaling
    os_disk_size_gb     = var.system_node_pool.os_disk_size_gb
    os_disk_type        = var.system_node_pool.os_disk_type
    vnet_subnet_id      = var.vnet_subnet_id
    max_pods            = 30
    type                = "VirtualMachineScaleSets"
    zones               = var.availability_zones

    # Node labels
    node_labels = {
      "node-type" = "system"
    }
  }

  # Identity - Use user-assigned identity for private DNS zone support
  identity {
    type         = "UserAssigned"
    identity_ids = [var.workload_identity_client_id]
  }

  # Workload Identity (if enabled)
  oidc_issuer_enabled = var.enable_workload_identity

  # Network Profile
  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "azure"
    service_cidr        = var.service_cidr
    dns_service_ip      = var.dns_service_ip
    pod_cidr            = var.pod_cidr
    load_balancer_sku   = "standard"
    outbound_type       = "loadBalancer"

    # Load balancer profile
    load_balancer_profile {
      managed_outbound_ip_count = 2
    }
  }

  # Azure Policy
  azure_policy_enabled = true

  # Key Vault Secrets Provider
  key_vault_secrets_provider {
    secret_rotation_enabled = var.enable_csi_secret_store
  }


  # RBAC
  role_based_access_control_enabled = true

  # Auto Scaler Profile
  auto_scaler_profile {
    balance_similar_node_groups      = true
    expander                         = "priority"
    max_graceful_termination_sec     = 600
    max_node_provisioning_time       = "15m"
    max_unready_nodes                = 3
    max_unready_percentage           = 45
    new_pod_scale_up_delay           = "10s"
    scale_down_delay_after_add       = "10m"
    scale_down_delay_after_delete    = "10s"
    scale_down_delay_after_failure   = "3m"
    scan_interval                    = "10s"
    scale_down_utilization_threshold = "0.5"
    skip_nodes_with_local_storage    = true
    skip_nodes_with_system_pods      = true
  }

  # Maintenance Window
  maintenance_window {
    allowed {
      day   = "Sunday"
      hours = [2, 3, 4, 5]
    }
  }

  # Private Cluster (if enabled)
  private_cluster_enabled = var.private_cluster_enabled
  private_dns_zone_id     = var.private_cluster_enabled ? var.private_dns_zone_id : null

  # Local Account Disabled (requires Azure AD integration for K8s 1.25+)
  local_account_disabled = false

  # Disk Encryption
  disk_encryption_set_id = var.disk_encryption_set_id

  # Remove circular dependency - AKS cluster should not depend on node pools
}

# User Node Pools
resource "azurerm_kubernetes_cluster_node_pool" "user_pools" {
  for_each = { for k, v in var.user_node_pools : k => v if k != "user-pool" }

  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  enable_auto_scaling   = each.value.enable_auto_scaling
  os_disk_size_gb       = each.value.os_disk_size_gb
  os_disk_type          = each.value.os_disk_type
  vnet_subnet_id        = var.vnet_subnet_id
  max_pods              = 30
  zones                 = var.availability_zones


  # Node labels
  node_labels = merge(each.value.node_labels, {
    "kubernetes.azure.com/agentpool" = each.key
    "node-type"                      = "user"
  })

  # Node taints
  node_taints = each.value.node_taints

  # Mode
  mode = "User"

  # Upgrade settings
  upgrade_settings {
    max_surge = "33%"
  }
}

# Workload Identity (if enabled)
resource "azurerm_federated_identity_credential" "aks_workload_identity" {
  count               = var.enable_workload_identity ? 1 : 0
  name                = "${var.aks_name}-workload-identity"
  resource_group_name = "wise-words-dev-security" # Identity is in security resource group
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.main.oidc_issuer_url
  subject             = "system:serviceaccount:${var.workload_identity_namespace}:${var.workload_identity_service_account}"
  parent_id           = var.workload_identity_client_id
}

# Azure Policy for AKS
# Azure Policy Assignment - Commented out due to provider limitations
# resource "azurerm_policy_assignment" "aks_policy" {
#   count                = var.enable_azure_policy ? 1 : 0
#   name                 = "${var.aks_name}-policy"
#   scope                = azurerm_kubernetes_cluster.main.id
#   policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/47a1ee2f-2a3a-40a0-b7e7-15440607ca3d"
#   description          = "Policy to ensure AKS cluster uses managed identity"
#   display_name         = "AKS Managed Identity Policy"
# }
