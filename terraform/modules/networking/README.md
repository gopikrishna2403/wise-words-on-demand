# networking

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
| [azurerm_network_security_group.subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.aks_subnet_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.bastion_subnet_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.pod_subnet_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.sql_subnet_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_private_dns_zone.custom](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.sql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.custom](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.sql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_subnet.subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tags to apply to resources | `map(string)` | n/a | yes |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | Custom DNS servers | `list(string)` | `[]` | no |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | Custom DNS zone name | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for resource names | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_subnet_configs"></a> [subnet\_configs](#input\_subnet\_configs) | Configuration for subnets | <pre>map(object({<br>    address_prefixes  = list(string)<br>    service_endpoints = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | Address space for the VNet | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_subnet_id"></a> [aks\_subnet\_id](#output\_aks\_subnet\_id) | ID of the AKS subnet |
| <a name="output_bastion_subnet_id"></a> [bastion\_subnet\_id](#output\_bastion\_subnet\_id) | ID of the bastion subnet |
| <a name="output_custom_dns_zone_id"></a> [custom\_dns\_zone\_id](#output\_custom\_dns\_zone\_id) | ID of the custom private DNS zone |
| <a name="output_network_security_groups"></a> [network\_security\_groups](#output\_network\_security\_groups) | Network security group information |
| <a name="output_pod_subnet_id"></a> [pod\_subnet\_id](#output\_pod\_subnet\_id) | ID of the pod subnet |
| <a name="output_private_dns_zone_id"></a> [private\_dns\_zone\_id](#output\_private\_dns\_zone\_id) | ID of the private DNS zone for SQL |
| <a name="output_sql_subnet_id"></a> [sql\_subnet\_id](#output\_sql\_subnet\_id) | ID of the SQL subnet |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Subnet information |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | ID of the virtual network |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | Name of the virtual network |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
