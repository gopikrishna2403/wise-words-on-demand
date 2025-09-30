# database

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.46.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.sql_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_mssql_database.databases](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [azurerm_mssql_firewall_rule.azure_services](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule) | resource |
| [azurerm_mssql_firewall_rule.client_ips](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule) | resource |
| [azurerm_mssql_server.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) | resource |
| [azurerm_mssql_server_extended_auditing_policy.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_extended_auditing_policy) | resource |
| [azurerm_mssql_server_security_alert_policy.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_security_alert_policy) | resource |
| [azurerm_mssql_server_vulnerability_assessment.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_vulnerability_assessment) | resource |
| [azurerm_private_dns_a_record.sql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_endpoint.sql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [random_password.sql_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_audit_retention_days"></a> [audit\_retention\_days](#input\_audit\_retention\_days) | Audit log retention days | `number` | `90` | no |
| <a name="input_audit_storage_endpoint"></a> [audit\_storage\_endpoint](#input\_audit\_storage\_endpoint) | Storage endpoint for audit logs | `string` | `null` | no |
| <a name="input_audit_storage_key"></a> [audit\_storage\_key](#input\_audit\_storage\_key) | Storage key for audit logs | `string` | `null` | no |
| <a name="input_azure_ad_admin_login"></a> [azure\_ad\_admin\_login](#input\_azure\_ad\_admin\_login) | Azure AD administrator login | `string` | `null` | no |
| <a name="input_azure_ad_admin_object_id"></a> [azure\_ad\_admin\_object\_id](#input\_azure\_ad\_admin\_object\_id) | Azure AD administrator object ID | `string` | `null` | no |
| <a name="input_azure_ad_tenant_id"></a> [azure\_ad\_tenant\_id](#input\_azure\_ad\_tenant\_id) | Azure AD tenant ID | `string` | `null` | no |
| <a name="input_client_ip_ranges"></a> [client\_ip\_ranges](#input\_client\_ip\_ranges) | Client IP ranges for firewall rules | <pre>map(object({<br>    start_ip = string<br>    end_ip   = string<br>  }))</pre> | `{}` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tags to apply to resources | `map(string)` | n/a | yes |
| <a name="input_disabled_alerts"></a> [disabled\_alerts](#input\_disabled\_alerts) | Disabled security alerts | `list(string)` | `[]` | no |
| <a name="input_enable_auditing"></a> [enable\_auditing](#input\_enable\_auditing) | Enable SQL Server auditing | `bool` | `true` | no |
| <a name="input_enable_private_endpoint"></a> [enable\_private\_endpoint](#input\_enable\_private\_endpoint) | Enable private endpoint | `bool` | `true` | no |
| <a name="input_enable_security_alert_policy"></a> [enable\_security\_alert\_policy](#input\_enable\_security\_alert\_policy) | Enable security alert policy | `bool` | `true` | no |
| <a name="input_enable_vulnerability_assessment"></a> [enable\_vulnerability\_assessment](#input\_enable\_vulnerability\_assessment) | Enable vulnerability assessment | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | n/a | yes |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | Key Vault ID for storing secrets | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for resource names | `string` | n/a | yes |
| <a name="input_outbound_network_access_restriction_enabled"></a> [outbound\_network\_access\_restriction\_enabled](#input\_outbound\_network\_access\_restriction\_enabled) | Enable outbound network access restriction | `bool` | `false` | no |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | Private DNS zone ID for SQL Server | `string` | `null` | no |
| <a name="input_private_dns_zone_name"></a> [private\_dns\_zone\_name](#input\_private\_dns\_zone\_name) | Private DNS zone name for SQL Server | `string` | `"privatelink.database.windows.net"` | no |
| <a name="input_private_dns_zone_resource_group"></a> [private\_dns\_zone\_resource\_group](#input\_private\_dns\_zone\_resource\_group) | Resource group name for private DNS zone | `string` | `null` | no |
| <a name="input_private_endpoint_subnet_id"></a> [private\_endpoint\_subnet\_id](#input\_private\_endpoint\_subnet\_id) | Subnet ID for private endpoint | `string` | `null` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | n/a | yes |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Enable public network access | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_security_alert_email_addresses"></a> [security\_alert\_email\_addresses](#input\_security\_alert\_email\_addresses) | Email addresses for security alerts | `list(string)` | `[]` | no |
| <a name="input_security_alert_retention_days"></a> [security\_alert\_retention\_days](#input\_security\_alert\_retention\_days) | Security alert retention days | `number` | `30` | no |
| <a name="input_sql_admin_username"></a> [sql\_admin\_username](#input\_sql\_admin\_username) | SQL Server administrator username | `string` | `"sqladmin"` | no |
| <a name="input_sql_databases"></a> [sql\_databases](#input\_sql\_databases) | SQL databases to create | <pre>map(object({<br>    collation   = string<br>    max_size_gb = number<br>    sku_name    = string<br>  }))</pre> | n/a | yes |
| <a name="input_sql_server_name"></a> [sql\_server\_name](#input\_sql\_server\_name) | Name of the SQL Server | `string` | n/a | yes |
| <a name="input_vulnerability_assessment_emails"></a> [vulnerability\_assessment\_emails](#input\_vulnerability\_assessment\_emails) | Email addresses for vulnerability assessment | `list(string)` | `[]` | no |
| <a name="input_vulnerability_assessment_storage_account"></a> [vulnerability\_assessment\_storage\_account](#input\_vulnerability\_assessment\_storage\_account) | Storage account name for vulnerability assessment | `string` | `""` | no |
| <a name="input_vulnerability_assessment_storage_container"></a> [vulnerability\_assessment\_storage\_container](#input\_vulnerability\_assessment\_storage\_container) | Storage container name for vulnerability assessment | `string` | `"vulnerability-assessment"` | no |
| <a name="input_vulnerability_assessment_storage_key"></a> [vulnerability\_assessment\_storage\_key](#input\_vulnerability\_assessment\_storage\_key) | Storage key for vulnerability assessment | `string` | `null` | no |
| <a name="input_vulnerability_assessment_storage_path"></a> [vulnerability\_assessment\_storage\_path](#input\_vulnerability\_assessment\_storage\_path) | Storage path for vulnerability assessment | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_strings"></a> [connection\_strings](#output\_connection\_strings) | Connection strings for the databases |
| <a name="output_databases"></a> [databases](#output\_databases) | Information about SQL databases |
| <a name="output_key_vault_secret_id"></a> [key\_vault\_secret\_id](#output\_key\_vault\_secret\_id) | ID of the Key Vault secret for SQL admin password |
| <a name="output_private_dns_a_record"></a> [private\_dns\_a\_record](#output\_private\_dns\_a\_record) | Private DNS A record for SQL Server |
| <a name="output_private_endpoint_id"></a> [private\_endpoint\_id](#output\_private\_endpoint\_id) | ID of the private endpoint |
| <a name="output_private_endpoint_ip"></a> [private\_endpoint\_ip](#output\_private\_endpoint\_ip) | Private IP address of the private endpoint |
| <a name="output_sql_server_administrator_login"></a> [sql\_server\_administrator\_login](#output\_sql\_server\_administrator\_login) | Administrator login of the SQL Server |
| <a name="output_sql_server_administrator_password"></a> [sql\_server\_administrator\_password](#output\_sql\_server\_administrator\_password) | Administrator password of the SQL Server |
| <a name="output_sql_server_fqdn"></a> [sql\_server\_fqdn](#output\_sql\_server\_fqdn) | FQDN of the SQL Server |
| <a name="output_sql_server_id"></a> [sql\_server\_id](#output\_sql\_server\_id) | ID of the SQL Server |
| <a name="output_sql_server_name"></a> [sql\_server\_name](#output\_sql\_server\_name) | Name of the SQL Server |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
