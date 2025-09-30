# Wise Words on Demand - Terraform Outputs

# Resource Groups
output "resource_groups" {
  description = "Resource group information"
  value = {
    networking = {
      name     = azurerm_resource_group.networking.name
      location = azurerm_resource_group.networking.location
    }
    security = {
      name     = azurerm_resource_group.security.name
      location = azurerm_resource_group.security.location
    }
    # aks = {
    #   name     = azurerm_resource_group.aks.name
    #   location = azurerm_resource_group.aks.location
    # }
    database = {
      name     = azurerm_resource_group.database.name
      location = azurerm_resource_group.database.location
    }
    # ingress = {
    #   name     = azurerm_resource_group.ingress.name
    #   location = azurerm_resource_group.ingress.location
    # }
  }
}

# Networking Outputs
output "networking" {
  description = "Networking resources"
  value = {
    vnet_id             = module.networking.vnet_id
    vnet_name           = module.networking.vnet_name
    subnets             = module.networking.subnets
    private_dns_zone_id = module.networking.private_dns_zone_id
  }
}

# AKS Outputs
output "aks" {
  description = "AKS cluster information"
  value = {
    cluster_id           = module.aks.aks_cluster_id
    cluster_name         = module.aks.aks_cluster_name
    cluster_fqdn         = module.aks.aks_cluster_fqdn
    cluster_private_fqdn = module.aks.aks_cluster_private_fqdn
    kube_config          = module.aks.kube_config
    node_resource_group  = module.aks.node_resource_group
  }
  sensitive = true
}

# Database Outputs - Now Active for Step 3
output "database" {
  description = "Database information"
  value = {
    sql_server_id       = module.database.sql_server_id
    sql_server_name     = module.database.sql_server_name
    sql_server_fqdn     = module.database.sql_server_fqdn
    databases           = module.database.databases
    private_endpoint_ip = module.database.private_endpoint_ip
  }
}

# Security Outputs - Now Active for Step 2
output "security" {
  description = "Security resources"
  value = {
    key_vault_id                         = module.security.key_vault_id
    key_vault_uri                        = module.security.key_vault_uri
    acr_id                               = module.security.acr_id
    acr_login_server                     = module.security.acr_login_server
    bastion_id                           = module.security.bastion_id
    bastion_public_ip                    = module.security.bastion_public_ip
    webapp_managed_identity_id           = module.security.webapp_managed_identity_id
    webapp_managed_identity_client_id    = module.security.webapp_managed_identity_client_id
    webapp_managed_identity_principal_id = module.security.webapp_managed_identity_principal_id
  }
}


# Ingress Outputs - COMMENTED OUT FOR INCREMENTAL DEPLOYMENT
output "ingress" {
  description = "Ingress resources"
  value = {
    ingress_controller_ip   = module.ingress.ingress_controller_ip
    ingress_controller_fqdn = module.ingress.ingress_controller_fqdn
    cert_manager_ready      = module.ingress.cert_manager_ready
  }
}

# Connection Information - COMMENTED OUT FOR INCREMENTAL DEPLOYMENT
# output "connection_info" {
#   description = "Connection information for the application"
#   value = {
#     # AKS connection
#     kubectl_config = "az aks get-credentials --resource-group ${azurerm_resource_group.aks.name} --name ${module.aks.aks_cluster_name}"
#
#     # Database connection
#     database_connection = "Server=${module.database.sql_server_fqdn};Database=wise-words-db;Authentication=Active Directory Default;"
#
#     # Container Registry
#     acr_login = "az acr login --name ${module.security.acr_login_server}"
#
#     # Bastion connection (if enabled)
#     bastion_connection = var.enable_bastion ? "Connect via Azure Bastion: ${module.security.bastion_public_ip}" : "Bastion not enabled"
#   }
# }

# Deployment Commands - COMMENTED OUT FOR INCREMENTAL DEPLOYMENT
# output "deployment_commands" {
#   description = "Useful deployment commands"
#   value = {
#     # Get AKS credentials
#     get_aks_credentials = "az aks get-credentials --resource-group ${azurerm_resource_group.aks.name} --name ${module.aks.aks_cluster_name}"
#
#     # Deploy application
#     deploy_app = "kubectl apply -f k8s/"
#
#     # Check ingress
#     check_ingress = "kubectl get ingress -n wise-words"
#
#     # Check pods
#     check_pods = "kubectl get pods -n wise-words"
#
#     # View logs
#     view_logs = "kubectl logs -f deployment/wise-words-app -n wise-words"
#   }
# }
