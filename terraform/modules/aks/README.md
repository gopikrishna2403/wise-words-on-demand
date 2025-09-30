# aks

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
| [azurerm_federated_identity_credential.aks_workload_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_kubernetes_cluster.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.user_pools](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_group_object_ids"></a> [admin\_group\_object\_ids](#input\_admin\_group\_object\_ids) | Object IDs of admin groups | `list(string)` | `[]` | no |
| <a name="input_aks_name"></a> [aks\_name](#input\_aks\_name) | Name of the AKS cluster | `string` | n/a | yes |
| <a name="input_api_server_authorized_ip_ranges"></a> [api\_server\_authorized\_ip\_ranges](#input\_api\_server\_authorized\_ip\_ranges) | Authorized IP ranges for API server | `list(string)` | `[]` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Availability zones for the cluster | `list(string)` | <pre>[<br>  "1",<br>  "2",<br>  "3"<br>]</pre> | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tags to apply to resources | `map(string)` | n/a | yes |
| <a name="input_disk_encryption_set_id"></a> [disk\_encryption\_set\_id](#input\_disk\_encryption\_set\_id) | Disk encryption set ID | `string` | `null` | no |
| <a name="input_dns_service_ip"></a> [dns\_service\_ip](#input\_dns\_service\_ip) | IP address for Kubernetes DNS service | `string` | `"10.1.0.10"` | no |
| <a name="input_enable_azure_policy"></a> [enable\_azure\_policy](#input\_enable\_azure\_policy) | Enable Azure Policy | `bool` | `true` | no |
| <a name="input_enable_csi_secret_store"></a> [enable\_csi\_secret\_store](#input\_enable\_csi\_secret\_store) | Enable CSI Secret Store | `bool` | `true` | no |
| <a name="input_enable_workload_identity"></a> [enable\_workload\_identity](#input\_enable\_workload\_identity) | Enable workload identity | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version | `string` | `"1.28"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for resource names | `string` | n/a | yes |
| <a name="input_pod_cidr"></a> [pod\_cidr](#input\_pod\_cidr) | CIDR for Kubernetes pods | `string` | `"10.2.0.0/16"` | no |
| <a name="input_pod_subnet_id"></a> [pod\_subnet\_id](#input\_pod\_subnet\_id) | Subnet ID for AKS pods | `string` | `null` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | Enable private cluster | `bool` | `false` | no |
| <a name="input_private_dns_zone_id"></a> [private\_dns\_zone\_id](#input\_private\_dns\_zone\_id) | Private DNS zone ID for private cluster | `string` | `null` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_service_cidr"></a> [service\_cidr](#input\_service\_cidr) | CIDR for Kubernetes services | `string` | `"10.1.0.0/16"` | no |
| <a name="input_system_node_pool"></a> [system\_node\_pool](#input\_system\_node\_pool) | System node pool configuration | <pre>object({<br>    name                = string<br>    vm_size             = string<br>    node_count          = number<br>    min_count           = number<br>    max_count           = number<br>    enable_auto_scaling = bool<br>    os_disk_size_gb     = number<br>    os_disk_type        = string<br>  })</pre> | n/a | yes |
| <a name="input_user_node_pools"></a> [user\_node\_pools](#input\_user\_node\_pools) | User node pools configuration | <pre>map(object({<br>    vm_size             = string<br>    node_count          = number<br>    min_count           = number<br>    max_count           = number<br>    enable_auto_scaling = bool<br>    os_disk_size_gb     = number<br>    os_disk_type        = string<br>    node_taints         = list(string)<br>    node_labels         = map(string)<br>  }))</pre> | `{}` | no |
| <a name="input_vnet_subnet_id"></a> [vnet\_subnet\_id](#input\_vnet\_subnet\_id) | Subnet ID for AKS nodes | `string` | n/a | yes |
| <a name="input_workload_identity_client_id"></a> [workload\_identity\_client\_id](#input\_workload\_identity\_client\_id) | Client ID for workload identity | `string` | `null` | no |
| <a name="input_workload_identity_namespace"></a> [workload\_identity\_namespace](#input\_workload\_identity\_namespace) | Namespace for workload identity service account | `string` | `"default"` | no |
| <a name="input_workload_identity_service_account"></a> [workload\_identity\_service\_account](#input\_workload\_identity\_service\_account) | Service account name for workload identity | `string` | `"workload-identity-sa"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_cluster_fqdn"></a> [aks\_cluster\_fqdn](#output\_aks\_cluster\_fqdn) | FQDN of the AKS cluster |
| <a name="output_aks_cluster_id"></a> [aks\_cluster\_id](#output\_aks\_cluster\_id) | ID of the AKS cluster |
| <a name="output_aks_cluster_name"></a> [aks\_cluster\_name](#output\_aks\_cluster\_name) | Name of the AKS cluster |
| <a name="output_aks_cluster_portal_fqdn"></a> [aks\_cluster\_portal\_fqdn](#output\_aks\_cluster\_portal\_fqdn) | Portal FQDN of the AKS cluster |
| <a name="output_aks_cluster_private_fqdn"></a> [aks\_cluster\_private\_fqdn](#output\_aks\_cluster\_private\_fqdn) | Private FQDN of the AKS cluster |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | Kubernetes configuration |
| <a name="output_kube_config_client_certificate"></a> [kube\_config\_client\_certificate](#output\_kube\_config\_client\_certificate) | Kubernetes client certificate |
| <a name="output_kube_config_client_key"></a> [kube\_config\_client\_key](#output\_kube\_config\_client\_key) | Kubernetes client key |
| <a name="output_kube_config_cluster_ca_certificate"></a> [kube\_config\_cluster\_ca\_certificate](#output\_kube\_config\_cluster\_ca\_certificate) | Kubernetes cluster CA certificate |
| <a name="output_kube_config_host"></a> [kube\_config\_host](#output\_kube\_config\_host) | Kubernetes cluster host |
| <a name="output_kubelet_identity"></a> [kubelet\_identity](#output\_kubelet\_identity) | Kubelet identity of the AKS cluster |
| <a name="output_node_pools"></a> [node\_pools](#output\_node\_pools) | Information about node pools |
| <a name="output_node_resource_group"></a> [node\_resource\_group](#output\_node\_resource\_group) | Resource group of the AKS nodes |
| <a name="output_oidc_issuer_url"></a> [oidc\_issuer\_url](#output\_oidc\_issuer\_url) | OIDC issuer URL for workload identity |
| <a name="output_system_assigned_identity"></a> [system\_assigned\_identity](#output\_system\_assigned\_identity) | System assigned identity of the AKS cluster |
| <a name="output_workload_identity_credential_id"></a> [workload\_identity\_credential\_id](#output\_workload\_identity\_credential\_id) | ID of the workload identity credential |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
