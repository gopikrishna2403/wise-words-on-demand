# Networking Module Outputs

output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "subnets" {
  description = "Subnet information"
  value = {
    for k, v in azurerm_subnet.subnets : k => {
      id               = v.id
      name             = v.name
      address_prefixes = v.address_prefixes
    }
  }
}

output "aks_subnet_id" {
  description = "ID of the AKS subnet"
  value       = azurerm_subnet.subnets["aks-subnet"].id
}

output "pod_subnet_id" {
  description = "ID of the pod subnet"
  value       = azurerm_subnet.subnets["pod-subnet"].id
}

output "bastion_subnet_id" {
  description = "ID of the bastion subnet"
  value       = azurerm_subnet.subnets["bastion-subnet"].id
}

output "sql_subnet_id" {
  description = "ID of the SQL subnet"
  value       = azurerm_subnet.subnets["sql-subnet"].id
}

output "private_dns_zone_id" {
  description = "ID of the private DNS zone for SQL"
  value       = azurerm_private_dns_zone.sql.id
}

output "custom_dns_zone_id" {
  description = "ID of the custom private DNS zone"
  value       = var.dns_zone_name != "" ? azurerm_private_dns_zone.custom[0].id : null
}

output "network_security_groups" {
  description = "Network security group information"
  value = {
    for k, v in azurerm_network_security_group.subnets : k => {
      id   = v.id
      name = v.name
    }
  }
}
