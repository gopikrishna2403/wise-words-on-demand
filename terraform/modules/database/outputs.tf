# Database Module Outputs

output "sql_server_id" {
  description = "ID of the SQL Server"
  value       = azurerm_mssql_server.main.id
}

output "sql_server_name" {
  description = "Name of the SQL Server"
  value       = azurerm_mssql_server.main.name
}

output "sql_server_fqdn" {
  description = "FQDN of the SQL Server"
  value       = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "sql_server_administrator_login" {
  description = "Administrator login of the SQL Server"
  value       = azurerm_mssql_server.main.administrator_login
}

output "sql_server_administrator_password" {
  description = "Administrator password of the SQL Server"
  value       = random_password.sql_admin_password.result
  sensitive   = true
}

output "databases" {
  description = "Information about SQL databases"
  value = {
    for k, v in azurerm_mssql_database.databases : k => {
      id          = v.id
      name        = v.name
      collation   = v.collation
      max_size_gb = v.max_size_gb
      sku_name    = v.sku_name
    }
  }
}

output "private_endpoint_id" {
  description = "ID of the private endpoint"
  value       = var.enable_private_endpoint ? azurerm_private_endpoint.sql[0].id : null
}

output "private_endpoint_ip" {
  description = "Private IP address of the private endpoint"
  value       = var.enable_private_endpoint ? azurerm_private_endpoint.sql[0].private_service_connection[0].private_ip_address : null
}

output "private_dns_a_record" {
  description = "Private DNS A record for SQL Server"
  value       = var.enable_private_endpoint ? azurerm_private_dns_a_record.sql[0].fqdn : null
}

output "connection_strings" {
  description = "Connection strings for the databases"
  value = {
    for k, v in azurerm_mssql_database.databases : k => {
      server            = azurerm_mssql_server.main.fully_qualified_domain_name
      database          = v.name
      username          = azurerm_mssql_server.main.administrator_login
      password          = random_password.sql_admin_password.result
      connection_string = "Server=${azurerm_mssql_server.main.fully_qualified_domain_name};Database=${v.name};User Id=${azurerm_mssql_server.main.administrator_login};Password=${random_password.sql_admin_password.result};Encrypt=true;TrustServerCertificate=false;Connection Timeout=30;"
    }
  }
  sensitive = true
}

output "key_vault_secret_id" {
  description = "ID of the Key Vault secret for SQL admin password"
  value       = var.key_vault_id != null ? azurerm_key_vault_secret.sql_admin_password[0].id : null
}
