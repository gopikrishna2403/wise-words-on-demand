# Database Module - Wise Words on Demand

# Random password for SQL Server
resource "random_password" "sql_admin_password" {
  length  = 16
  special = true
  upper   = true
  lower   = true
  numeric = true
}

# Azure SQL Server
resource "azurerm_mssql_server" "main" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = random_password.sql_admin_password.result
  minimum_tls_version          = "1.2"
  tags                         = var.common_tags

  # Azure AD authentication
  azuread_administrator {
    login_username = var.azure_ad_admin_login
    object_id      = var.azure_ad_admin_object_id
    tenant_id      = var.azure_ad_tenant_id
  }

  # Public network access
  public_network_access_enabled = var.public_network_access_enabled

  # Identity
  identity {
    type = "SystemAssigned"
  }
}

# SQL Server Firewall Rules
resource "azurerm_mssql_firewall_rule" "azure_services" {
  count            = var.public_network_access_enabled ? 1 : 0
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_firewall_rule" "client_ips" {
  for_each = var.public_network_access_enabled ? var.client_ip_ranges : {}

  name             = each.key
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = each.value.start_ip
  end_ip_address   = each.value.end_ip
}

# SQL Databases
resource "azurerm_mssql_database" "databases" {
  for_each = var.sql_databases

  name        = each.key
  server_id   = azurerm_mssql_server.main.id
  collation   = each.value.collation
  max_size_gb = each.value.max_size_gb
  sku_name    = each.value.sku_name
  tags        = var.common_tags

  # Backup
  short_term_retention_policy {
    retention_days = 7
  }

  # Long term retention policy
  long_term_retention_policy {
    weekly_retention  = "P1W"
    monthly_retention = "P1M"
    yearly_retention  = "P1Y"
    week_of_year      = 1
  }
}

# Private Endpoint for SQL Server
resource "azurerm_private_endpoint" "sql" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "${var.name_prefix}-sql-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.common_tags

  private_service_connection {
    name                           = "${var.name_prefix}-sql-psc"
    private_connection_resource_id = azurerm_mssql_server.main.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${var.name_prefix}-sql-dns"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}

# Private DNS Zone for SQL Server
resource "azurerm_private_dns_a_record" "sql" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = azurerm_mssql_server.main.name
  zone_name           = var.private_dns_zone_name
  resource_group_name = var.private_dns_zone_resource_group
  ttl                 = 300
  records             = [azurerm_private_endpoint.sql[0].private_service_connection[0].private_ip_address]
}

# Key Vault Secret for SQL Admin Password
resource "azurerm_key_vault_secret" "sql_admin_password" {
  count        = var.key_vault_id != null ? 1 : 0
  name         = "sql-admin-password"
  value        = random_password.sql_admin_password.result
  key_vault_id = var.key_vault_id
  tags         = var.common_tags

  depends_on = [azurerm_mssql_server.main]
}

# SQL Server Audit Policy
resource "azurerm_mssql_server_extended_auditing_policy" "main" {
  count                      = var.enable_auditing ? 1 : 0
  server_id                  = azurerm_mssql_server.main.id
  log_monitoring_enabled     = true
  storage_endpoint           = var.audit_storage_endpoint
  storage_account_access_key = var.audit_storage_key
  retention_in_days          = var.audit_retention_days
}

# SQL Server Security Alert Policy
resource "azurerm_mssql_server_security_alert_policy" "main" {
  count                = var.enable_security_alert_policy ? 1 : 0
  resource_group_name  = var.resource_group_name
  server_name          = azurerm_mssql_server.main.name
  state                = "Enabled"
  email_addresses      = var.security_alert_email_addresses
  email_account_admins = true
  disabled_alerts      = var.disabled_alerts
  retention_days       = var.security_alert_retention_days
}

# SQL Server Vulnerability Assessment
resource "azurerm_mssql_server_vulnerability_assessment" "main" {
  count                           = var.enable_vulnerability_assessment ? 1 : 0
  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.main[0].id
  storage_container_path          = var.vulnerability_assessment_storage_account != "" ? "https://${var.vulnerability_assessment_storage_account}.blob.core.windows.net/${var.vulnerability_assessment_storage_container}/" : null
  storage_account_access_key      = var.vulnerability_assessment_storage_key
  recurring_scans {
    enabled                   = true
    email_subscription_admins = true
    emails                    = var.vulnerability_assessment_emails
  }
}
