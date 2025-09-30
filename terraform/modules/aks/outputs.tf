# AKS Module Outputs

output "aks_cluster_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.id
}

output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.name
}

output "aks_cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.fqdn
}

output "aks_cluster_private_fqdn" {
  description = "Private FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.private_fqdn
}

output "aks_cluster_portal_fqdn" {
  description = "Portal FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.portal_fqdn
}

output "kube_config" {
  description = "Kubernetes configuration"
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
}

output "kube_config_host" {
  description = "Kubernetes cluster host"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].host
  sensitive   = true
}

output "kube_config_client_key" {
  description = "Kubernetes client key"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_key
  sensitive   = true
}

output "kube_config_client_certificate" {
  description = "Kubernetes client certificate"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_certificate
  sensitive   = true
}

output "kube_config_cluster_ca_certificate" {
  description = "Kubernetes cluster CA certificate"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate
  sensitive   = true
}

output "node_resource_group" {
  description = "Resource group of the AKS nodes"
  value       = azurerm_kubernetes_cluster.main.node_resource_group
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL for workload identity"
  value       = azurerm_kubernetes_cluster.main.oidc_issuer_url
}

output "kubelet_identity" {
  description = "Kubelet identity of the AKS cluster"
  value = {
    client_id   = azurerm_kubernetes_cluster.main.kubelet_identity[0].client_id
    object_id   = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
    resource_id = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  }
}

output "system_assigned_identity" {
  description = "System assigned identity of the AKS cluster"
  value = {
    client_id   = azurerm_kubernetes_cluster.main.identity[0].principal_id
    object_id   = azurerm_kubernetes_cluster.main.identity[0].principal_id
    resource_id = azurerm_kubernetes_cluster.main.identity[0].tenant_id
  }
}

output "node_pools" {
  description = "Information about node pools"
  value = {
    for k, v in azurerm_kubernetes_cluster_node_pool.user_pools : k => {
      id         = v.id
      name       = v.name
      node_count = v.node_count
      vm_size    = v.vm_size
    }
  }
}

output "workload_identity_credential_id" {
  description = "ID of the workload identity credential"
  value       = var.enable_workload_identity && var.workload_identity_client_id != null ? azurerm_federated_identity_credential.aks_workload_identity[0].id : null
}
