# terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.117.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aks"></a> [aks](#module\_aks) | ./modules/aks | n/a |
| <a name="module_database"></a> [database](#module\_database) | ./modules/database | n/a |
| <a name="module_ingress"></a> [ingress](#module\_ingress) | ./modules/ingress | n/a |
| <a name="module_networking"></a> [networking](#module\_networking) | ./modules/networking | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.ingress](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.networking](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.security](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_group_object_ids"></a> [admin\_group\_object\_ids](#input\_admin\_group\_object\_ids) | Object IDs of admin groups | `list(string)` | `[]` | no |
| <a name="input_api_server_authorized_ip_ranges"></a> [api\_server\_authorized\_ip\_ranges](#input\_api\_server\_authorized\_ip\_ranges) | Authorized IP ranges for API server | `list(string)` | `[]` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Availability zones for the cluster | `list(string)` | <pre>[<br>  "1",<br>  "2",<br>  "3"<br>]</pre> | no |
| <a name="input_azure_ad_admin_login"></a> [azure\_ad\_admin\_login](#input\_azure\_ad\_admin\_login) | Azure AD administrator login | `string` | `null` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | Azure subscription ID | `string` | `""` | no |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | Azure tenant ID | `string` | `""` | no |
| <a name="input_cert_manager_email"></a> [cert\_manager\_email](#input\_cert\_manager\_email) | Email address for cert-manager | `string` | `"admin@example.com"` | no |
| <a name="input_create_sample_ingress"></a> [create\_sample\_ingress](#input\_create\_sample\_ingress) | Create a sample ingress for testing | `bool` | `false` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | Custom DNS servers | `list(string)` | `[]` | no |
| <a name="input_enable_acr"></a> [enable\_acr](#input\_enable\_acr) | Enable Azure Container Registry | `bool` | `true` | no |
| <a name="input_enable_bastion"></a> [enable\_bastion](#input\_enable\_bastion) | Enable Azure Bastion | `bool` | `true` | no |
| <a name="input_enable_csi_secret_store"></a> [enable\_csi\_secret\_store](#input\_enable\_csi\_secret\_store) | Enable CSI Secret Store add-on | `bool` | `true` | no |
| <a name="input_enable_front_door"></a> [enable\_front\_door](#input\_enable\_front\_door) | Enable Azure Front Door | `bool` | `false` | no |
| <a name="input_enable_key_vault"></a> [enable\_key\_vault](#input\_enable\_key\_vault) | Enable Azure Key Vault | `bool` | `true` | no |
| <a name="input_enable_vulnerability_assessment"></a> [enable\_vulnerability\_assessment](#input\_enable\_vulnerability\_assessment) | Enable SQL Server vulnerability assessment | `bool` | `false` | no |
| <a name="input_enable_workload_identity"></a> [enable\_workload\_identity](#input\_enable\_workload\_identity) | Enable workload identity add-on | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev, staging, prod) | `string` | `"dev"` | no |
| <a name="input_front_door_domain"></a> [front\_door\_domain](#input\_front\_door\_domain) | Domain name for Front Door | `string` | `""` | no |
| <a name="input_ingress_dns_label"></a> [ingress\_dns\_label](#input\_ingress\_dns\_label) | DNS label for the ingress controller | `string` | `""` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version for AKS | `string` | `"1.30.14"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region | `string` | `"West US 2"` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Owner of the resources | `string` | `"DevOps Team"` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | Enable private cluster | `bool` | `false` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | `"wise-words"` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Enable public network access for SQL Server | `bool` | `false` | no |
| <a name="input_sample_domain"></a> [sample\_domain](#input\_sample\_domain) | Domain name for the sample ingress | `string` | `"sample.example.com"` | no |
| <a name="input_sql_admin_password"></a> [sql\_admin\_password](#input\_sql\_admin\_password) | SQL Server administrator password | `string` | `null` | no |
| <a name="input_sql_admin_username"></a> [sql\_admin\_username](#input\_sql\_admin\_username) | SQL Server administrator username | `string` | `"sqladmin"` | no |
| <a name="input_sql_databases"></a> [sql\_databases](#input\_sql\_databases) | SQL databases to create | <pre>map(object({<br>    collation   = string<br>    max_size_gb = number<br>    sku_name    = string<br>  }))</pre> | <pre>{<br>  "wise-words-db": {<br>    "collation": "SQL_Latin1_General_CP1_CI_AS",<br>    "max_size_gb": 2,<br>    "sku_name": "Basic"<br>  }<br>}</pre> | no |
| <a name="input_subnet_configs"></a> [subnet\_configs](#input\_subnet\_configs) | Configuration for subnets | <pre>map(object({<br>    address_prefixes  = list(string)<br>    service_endpoints = list(string)<br>  }))</pre> | <pre>{<br>  "aks-subnet": {<br>    "address_prefixes": [<br>      "10.0.1.0/24"<br>    ],<br>    "service_endpoints": [<br>      "Microsoft.Storage",<br>      "Microsoft.KeyVault"<br>    ]<br>  },<br>  "bastion-subnet": {<br>    "address_prefixes": [<br>      "10.0.3.0/24"<br>    ],<br>    "service_endpoints": []<br>  },<br>  "pod-subnet": {<br>    "address_prefixes": [<br>      "10.0.2.0/24"<br>    ],<br>    "service_endpoints": []<br>  },<br>  "sql-subnet": {<br>    "address_prefixes": [<br>      "10.0.4.0/24"<br>    ],<br>    "service_endpoints": [<br>      "Microsoft.Sql"<br>    ]<br>  }<br>}</pre> | no |
| <a name="input_system_node_pool"></a> [system\_node\_pool](#input\_system\_node\_pool) | System node pool configuration | <pre>object({<br>    name                = string<br>    vm_size             = string<br>    node_count          = number<br>    min_count           = number<br>    max_count           = number<br>    enable_auto_scaling = bool<br>    os_disk_size_gb     = number<br>    os_disk_type        = string<br>  })</pre> | <pre>{<br>  "enable_auto_scaling": true,<br>  "max_count": 3,<br>  "min_count": 1,<br>  "name": "system",<br>  "node_count": 2,<br>  "os_disk_size_gb": 30,<br>  "os_disk_type": "Managed",<br>  "vm_size": "Standard_D2s_v3"<br>}</pre> | no |
| <a name="input_user_node_pools"></a> [user\_node\_pools](#input\_user\_node\_pools) | User node pools configuration | <pre>map(object({<br>    vm_size             = string<br>    node_count          = number<br>    min_count           = number<br>    max_count           = number<br>    enable_auto_scaling = bool<br>    os_disk_size_gb     = number<br>    os_disk_type        = string<br>    node_taints         = list(string)<br>    node_labels         = map(string)<br>  }))</pre> | <pre>{<br>  "user-pool": {<br>    "enable_auto_scaling": true,<br>    "max_count": 5,<br>    "min_count": 1,<br>    "node_count": 1,<br>    "node_labels": {<br>      "workload": "application"<br>    },<br>    "node_taints": [],<br>    "os_disk_size_gb": 50,<br>    "os_disk_type": "Managed",<br>    "vm_size": "Standard_D4s_v3"<br>  }<br>}</pre> | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | Address space for the VNet | `list(string)` | <pre>[<br>  "10.0.0.0/16"<br>]</pre> | no |
| <a name="input_workload_identity_namespace"></a> [workload\_identity\_namespace](#input\_workload\_identity\_namespace) | Namespace for workload identity service account | `string` | `"default"` | no |
| <a name="input_workload_identity_service_account"></a> [workload\_identity\_service\_account](#input\_workload\_identity\_service\_account) | Service account name for workload identity | `string` | `"workload-identity-sa"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks"></a> [aks](#output\_aks) | AKS cluster information |
| <a name="output_database"></a> [database](#output\_database) | Database information |
| <a name="output_ingress"></a> [ingress](#output\_ingress) | Ingress resources |
| <a name="output_networking"></a> [networking](#output\_networking) | Networking resources |
| <a name="output_resource_groups"></a> [resource\_groups](#output\_resource\_groups) | Resource group information |
| <a name="output_security"></a> [security](#output\_security) | Security resources |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
