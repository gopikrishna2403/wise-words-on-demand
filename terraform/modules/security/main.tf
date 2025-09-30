# Security Module - Wise Words on Demand

# Azure Container Registry
resource "azurerm_container_registry" "main" {
  count               = var.enable_acr ? 1 : 0
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = var.common_tags

  # Enable anonymous pull for public images
  anonymous_pull_enabled = false

  # Enable data encryption
  # encryption {
  #   key_vault_key_id = null
  #   identity_client_id = null
  # }

  # Enable quarantine policy (only for Premium SKU)
  # quarantine_policy_enabled = true
}

# Azure Key Vault
resource "azurerm_key_vault" "main" {
  count                      = var.enable_key_vault ? 1 : 0
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  tags                       = var.common_tags

  # Network ACLs
  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = var.key_vault_subnet_ids
  }

  # Enable RBAC
  enable_rbac_authorization = true
}

# Key Vault Access Policy for current user
resource "azurerm_key_vault_access_policy" "current_user" {
  count        = var.enable_key_vault ? 1 : 0
  key_vault_id = azurerm_key_vault.main[0].id
  tenant_id    = var.tenant_id
  object_id    = var.current_user_object_id

  key_permissions = [
    "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore"
  ]

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
  ]

  certificate_permissions = [
    "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers"
  ]
}

# Key Vault Secrets - COMMENTED OUT (RBAC propagation issue)
# resource "azurerm_key_vault_secret" "sql_admin_password" {
#   count        = var.enable_key_vault ? 1 : 0
#   name         = "sql-admin-password"
#   value        = var.sql_admin_password
#   key_vault_id = azurerm_key_vault.main[0].id
#   tags         = var.common_tags
# }


# Azure Bastion
resource "azurerm_public_ip" "bastion" {
  count               = var.enable_bastion ? 1 : 0
  name                = "${var.name_prefix}-bastion-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.common_tags
}

resource "azurerm_bastion_host" "main" {
  count               = var.enable_bastion ? 1 : 0
  name                = "${var.name_prefix}-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.common_tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion[0].id
  }
}

# Managed Identity for AKS
resource "azurerm_user_assigned_identity" "aks" {
  count               = var.enable_workload_identity ? 1 : 0
  name                = "${var.name_prefix}-aks-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.common_tags
}

# Managed Identity for Webapp
resource "azurerm_user_assigned_identity" "webapp" {
  name                = "${var.name_prefix}-webapp-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.common_tags
}

# Key Vault Access Policy for AKS Managed Identity
resource "azurerm_key_vault_access_policy" "aks_identity" {
  count        = var.enable_key_vault && var.enable_workload_identity ? 1 : 0
  key_vault_id = azurerm_key_vault.main[0].id
  tenant_id    = var.tenant_id
  object_id    = azurerm_user_assigned_identity.aks[0].principal_id

  secret_permissions = [
    "Get", "List"
  ]
}

# Role Assignment for AKS Identity to access Key Vault
resource "azurerm_role_assignment" "aks_key_vault_secrets_user" {
  count                = var.enable_key_vault && var.enable_workload_identity ? 1 : 0
  scope                = azurerm_key_vault.main[0].id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.aks[0].principal_id
}

# Role Assignment for AKS Identity to access ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  count                = var.enable_acr && var.enable_workload_identity ? 1 : 0
  scope                = azurerm_container_registry.main[0].id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.aks[0].principal_id
}

# Role Assignment for Webapp Identity to access SQL Database
resource "azurerm_role_assignment" "webapp_sql_contributor" {
  scope                = var.sql_server_id
  role_definition_name = "SQL DB Contributor"
  principal_id         = azurerm_user_assigned_identity.webapp.principal_id
}

# Private Endpoint for Key Vault
resource "azurerm_private_endpoint" "key_vault" {
  count               = var.enable_key_vault && var.enable_private_endpoints ? 1 : 0
  name                = "${var.name_prefix}-kv-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.common_tags

  private_service_connection {
    name                           = "${var.name_prefix}-kv-psc"
    private_connection_resource_id = azurerm_key_vault.main[0].id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${var.name_prefix}-kv-dns"
    private_dns_zone_ids = var.private_dns_zone_ids
  }
}

# Private Endpoint for ACR - COMMENTED OUT (Basic SKU doesn't support private endpoints)
# resource "azurerm_private_endpoint" "acr" {
#   count               = var.enable_acr && var.enable_private_endpoints ? 1 : 0
#   name                = "${var.name_prefix}-acr-pe"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   subnet_id           = var.private_endpoint_subnet_id
#   tags                = var.common_tags
#
#   private_service_connection {
#     name                           = "${var.name_prefix}-acr-psc"
#     private_connection_resource_id = azurerm_container_registry.main[0].id
#     subresource_names              = ["registry"]
#     is_manual_connection           = false
#   }
#
#   private_dns_zone_group {
#     name                 = "${var.name_prefix}-acr-dns"
#     private_dns_zone_ids = var.acr_private_dns_zone_ids
#   }
# }
