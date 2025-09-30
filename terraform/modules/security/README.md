# security

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.46.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_bastion_host.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |
| [azurerm_container_registry.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [azurerm_key_vault.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.aks_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.current_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_private_endpoint.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_public_ip.bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_role_assignment.aks_acr_pull](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_key_vault_secrets_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.webapp_sql_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.webapp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_name"></a> [acr\_name](#input\_acr\_name) | Name of the Azure Container Registry | `string` | n/a | yes |
| <a name="input_acr_private_dns_zone_ids"></a> [acr\_private\_dns\_zone\_ids](#input\_acr\_private\_dns\_zone\_ids) | Private DNS zone IDs for ACR | `list(string)` | `[]` | no |
| <a name="input_bastion_subnet_id"></a> [bastion\_subnet\_id](#input\_bastion\_subnet\_id) | Subnet ID for Bastion | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tags to apply to resources | `map(string)` | n/a | yes |
| <a name="input_current_user_object_id"></a> [current\_user\_object\_id](#input\_current\_user\_object\_id) | Object ID of the current user | `string` | n/a | yes |
| <a name="input_enable_acr"></a> [enable\_acr](#input\_enable\_acr) | Enable Azure Container Registry | `bool` | `true` | no |
| <a name="input_enable_bastion"></a> [enable\_bastion](#input\_enable\_bastion) | Enable Azure Bastion | `bool` | `true` | no |
| <a name="input_enable_key_vault"></a> [enable\_key\_vault](#input\_enable\_key\_vault) | Enable Azure Key Vault | `bool` | `true` | no |
| <a name="input_enable_private_endpoints"></a> [enable\_private\_endpoints](#input\_enable\_private\_endpoints) | Enable private endpoints | `bool` | `true` | no |
| <a name="input_enable_workload_identity"></a> [enable\_workload\_identity](#input\_enable\_workload\_identity) | Enable workload identity | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | n/a | yes |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Name of the Key Vault | `string` | n/a | yes |
| <a name="input_key_vault_subnet_ids"></a> [key\_vault\_subnet\_ids](#input\_key\_vault\_subnet\_ids) | Subnet IDs for Key Vault network ACLs | `list(string)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for resource names | `string` | n/a | yes |
| <a name="input_private_dns_zone_ids"></a> [private\_dns\_zone\_ids](#input\_private\_dns\_zone\_ids) | Private DNS zone IDs for Key Vault | `list(string)` | `[]` | no |
| <a name="input_private_endpoint_subnet_id"></a> [private\_endpoint\_subnet\_id](#input\_private\_endpoint\_subnet\_id) | Subnet ID for private endpoints | `string` | `null` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_sql_admin_password"></a> [sql\_admin\_password](#input\_sql\_admin\_password) | SQL Server administrator password | `string` | `null` | no |
| <a name="input_sql_server_id"></a> [sql\_server\_id](#input\_sql\_server\_id) | ID of the SQL Server for role assignments | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acr_id"></a> [acr\_id](#output\_acr\_id) | ID of the Azure Container Registry |
| <a name="output_acr_login_server"></a> [acr\_login\_server](#output\_acr\_login\_server) | Login server of the Azure Container Registry |
| <a name="output_acr_name"></a> [acr\_name](#output\_acr\_name) | Name of the Azure Container Registry |
| <a name="output_aks_managed_identity_client_id"></a> [aks\_managed\_identity\_client\_id](#output\_aks\_managed\_identity\_client\_id) | Client ID of the AKS managed identity |
| <a name="output_aks_managed_identity_id"></a> [aks\_managed\_identity\_id](#output\_aks\_managed\_identity\_id) | ID of the AKS managed identity |
| <a name="output_aks_managed_identity_principal_id"></a> [aks\_managed\_identity\_principal\_id](#output\_aks\_managed\_identity\_principal\_id) | Principal ID of the AKS managed identity |
| <a name="output_bastion_id"></a> [bastion\_id](#output\_bastion\_id) | ID of the Azure Bastion |
| <a name="output_bastion_public_ip"></a> [bastion\_public\_ip](#output\_bastion\_public\_ip) | Public IP of the Azure Bastion |
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | ID of the Key Vault |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | Name of the Key Vault |
| <a name="output_key_vault_private_endpoint_id"></a> [key\_vault\_private\_endpoint\_id](#output\_key\_vault\_private\_endpoint\_id) | ID of the Key Vault private endpoint |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | URI of the Key Vault |
| <a name="output_webapp_managed_identity_client_id"></a> [webapp\_managed\_identity\_client\_id](#output\_webapp\_managed\_identity\_client\_id) | Client ID of the webapp managed identity |
| <a name="output_webapp_managed_identity_id"></a> [webapp\_managed\_identity\_id](#output\_webapp\_managed\_identity\_id) | ID of the webapp managed identity |
| <a name="output_webapp_managed_identity_principal_id"></a> [webapp\_managed\_identity\_principal\_id](#output\_webapp\_managed\_identity\_principal\_id) | Principal ID of the webapp managed identity |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
