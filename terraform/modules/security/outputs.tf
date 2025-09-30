# Security Module Outputs

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = var.enable_key_vault ? azurerm_key_vault.main[0].id : null
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = var.enable_key_vault ? azurerm_key_vault.main[0].vault_uri : null
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = var.enable_key_vault ? azurerm_key_vault.main[0].name : null
}

output "acr_id" {
  description = "ID of the Azure Container Registry"
  value       = var.enable_acr ? azurerm_container_registry.main[0].id : null
}

output "acr_login_server" {
  description = "Login server of the Azure Container Registry"
  value       = var.enable_acr ? azurerm_container_registry.main[0].login_server : null
}

output "acr_name" {
  description = "Name of the Azure Container Registry"
  value       = var.enable_acr ? azurerm_container_registry.main[0].name : null
}

output "bastion_id" {
  description = "ID of the Azure Bastion"
  value       = var.enable_bastion ? azurerm_bastion_host.main[0].id : null
}

output "bastion_public_ip" {
  description = "Public IP of the Azure Bastion"
  value       = var.enable_bastion ? azurerm_public_ip.bastion[0].ip_address : null
}

output "aks_managed_identity_id" {
  description = "ID of the AKS managed identity"
  value       = var.enable_workload_identity ? azurerm_user_assigned_identity.aks[0].id : null
}

output "aks_managed_identity_principal_id" {
  description = "Principal ID of the AKS managed identity"
  value       = var.enable_workload_identity ? azurerm_user_assigned_identity.aks[0].principal_id : null
}

output "aks_managed_identity_client_id" {
  description = "Client ID of the AKS managed identity"
  value       = var.enable_workload_identity ? azurerm_user_assigned_identity.aks[0].client_id : null
}

output "webapp_managed_identity_id" {
  description = "ID of the webapp managed identity"
  value       = azurerm_user_assigned_identity.webapp.id
}

output "webapp_managed_identity_principal_id" {
  description = "Principal ID of the webapp managed identity"
  value       = azurerm_user_assigned_identity.webapp.principal_id
}

output "webapp_managed_identity_client_id" {
  description = "Client ID of the webapp managed identity"
  value       = azurerm_user_assigned_identity.webapp.client_id
}

output "key_vault_private_endpoint_id" {
  description = "ID of the Key Vault private endpoint"
  value       = var.enable_key_vault && var.enable_private_endpoints ? azurerm_private_endpoint.key_vault[0].id : null
}

# output "acr_private_endpoint_id" {
#   description = "ID of the ACR private endpoint"
#   value       = var.enable_acr && var.enable_private_endpoints ? azurerm_private_endpoint.acr[0].id : null
# }
