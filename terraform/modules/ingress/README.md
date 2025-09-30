# ingress

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.0.2 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.38.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.nginx_ingress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_ingress_class.nginx](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_class) | resource |
| [kubernetes_ingress_v1.sample](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_manifest.letsencrypt_cluster_issuer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.cert_manager](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_service.ingress_controller](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_client_certificate"></a> [aks\_client\_certificate](#input\_aks\_client\_certificate) | Base64 encoded client certificate for AKS | `string` | n/a | yes |
| <a name="input_aks_client_key"></a> [aks\_client\_key](#input\_aks\_client\_key) | Base64 encoded client key for AKS | `string` | n/a | yes |
| <a name="input_aks_cluster_ca_certificate"></a> [aks\_cluster\_ca\_certificate](#input\_aks\_cluster\_ca\_certificate) | Base64 encoded cluster CA certificate for AKS | `string` | n/a | yes |
| <a name="input_aks_cluster_fqdn"></a> [aks\_cluster\_fqdn](#input\_aks\_cluster\_fqdn) | FQDN of the AKS cluster | `string` | n/a | yes |
| <a name="input_aks_cluster_id"></a> [aks\_cluster\_id](#input\_aks\_cluster\_id) | ID of the AKS cluster | `string` | n/a | yes |
| <a name="input_aks_cluster_name"></a> [aks\_cluster\_name](#input\_aks\_cluster\_name) | Name of the AKS cluster | `string` | n/a | yes |
| <a name="input_aks_oidc_issuer_url"></a> [aks\_oidc\_issuer\_url](#input\_aks\_oidc\_issuer\_url) | OIDC issuer URL for the AKS cluster | `string` | n/a | yes |
| <a name="input_aks_resource_group_name"></a> [aks\_resource\_group\_name](#input\_aks\_resource\_group\_name) | Resource group name of the AKS cluster | `string` | n/a | yes |
| <a name="input_aks_subnet_id"></a> [aks\_subnet\_id](#input\_aks\_subnet\_id) | ID of the AKS subnet for internal load balancer | `string` | n/a | yes |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | Azure subscription ID | `string` | n/a | yes |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | Azure tenant ID | `string` | n/a | yes |
| <a name="input_cert_manager_email"></a> [cert\_manager\_email](#input\_cert\_manager\_email) | Email address for cert-manager | `string` | `"admin@example.com"` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tags to apply to resources | `map(string)` | n/a | yes |
| <a name="input_create_sample_ingress"></a> [create\_sample\_ingress](#input\_create\_sample\_ingress) | Create a sample ingress for testing | `bool` | `false` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Enable cert-manager | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | n/a | yes |
| <a name="input_ingress_dns_label"></a> [ingress\_dns\_label](#input\_ingress\_dns\_label) | DNS label for the ingress controller | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for resource names | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_sample_domain"></a> [sample\_domain](#input\_sample\_domain) | Domain name for the sample ingress | `string` | `"sample.example.com"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_ready"></a> [cert\_manager\_ready](#output\_cert\_manager\_ready) | Whether cert-manager is ready |
| <a name="output_ingress_class_name"></a> [ingress\_class\_name](#output\_ingress\_class\_name) | Name of the ingress class |
| <a name="output_ingress_controller_fqdn"></a> [ingress\_controller\_fqdn](#output\_ingress\_controller\_fqdn) | FQDN of the ingress controller |
| <a name="output_ingress_controller_ip"></a> [ingress\_controller\_ip](#output\_ingress\_controller\_ip) | IP address of the ingress controller |
| <a name="output_ingress_controller_status"></a> [ingress\_controller\_status](#output\_ingress\_controller\_status) | Status of the ingress controller |
| <a name="output_letsencrypt_cluster_issuer_ready"></a> [letsencrypt\_cluster\_issuer\_ready](#output\_letsencrypt\_cluster\_issuer\_ready) | Whether the Let's Encrypt ClusterIssuer is ready |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
