# Networking Module - Wise Words on Demand

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.name_prefix}-vnet"
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.common_tags
}

# Subnets
resource "azurerm_subnet" "subnets" {
  for_each = var.subnet_configs

  name                 = each.key == "bastion-subnet" ? "AzureBastionSubnet" : "${var.name_prefix}-${each.key}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = each.value.address_prefixes

  # Service endpoints
  service_endpoints = each.value.service_endpoints

  # Delegate to AKS for pod subnet
  dynamic "delegation" {
    for_each = each.key == "pod-subnet" ? [1] : []
    content {
      name = "Microsoft.ContainerService/managedClusters"
      service_delegation {
        name    = "Microsoft.ContainerService/managedClusters"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    }
  }
}

# Network Security Groups
resource "azurerm_network_security_group" "subnets" {
  for_each = var.subnet_configs

  name                = "${var.name_prefix}-${each.key}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.common_tags
}

# Associate NSGs with subnets
resource "azurerm_subnet_network_security_group_association" "subnets" {
  for_each = var.subnet_configs

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.subnets[each.key].id
}

# NSG Rules for AKS subnet
resource "azurerm_network_security_rule" "aks_subnet_rules" {
  for_each = {
    "AllowVnetInbound" = {
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
    "AllowAzureLoadBalancerInbound" = {
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
    }
    "AllowInternetInbound" = {
      priority                   = 500
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80-443"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
    "DenyAllInbound" = {
      priority                   = 4000
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  name                        = each.key
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.subnets["aks-subnet"].name
}

# NSG Rules for Pod subnet
resource "azurerm_network_security_rule" "pod_subnet_rules" {
  for_each = {
    "AllowVnetInbound" = {
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
    "AllowAzureLoadBalancerInbound" = {
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
    }
    "DenyAllInbound" = {
      priority                   = 4000
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  name                        = each.key
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.subnets["pod-subnet"].name
}

# NSG Rules for Bastion subnet
resource "azurerm_network_security_rule" "bastion_subnet_rules" {
  for_each = {
    "AllowHttpsInbound" = {
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
    "AllowGatewayManagerInbound" = {
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
    }
    "AllowAzureLoadBalancerInbound" = {
      priority                   = 1002
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
    }
    "AllowBastionHostCommunication" = {
      priority                   = 1003
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_ranges    = ["8080", "5701"]
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
    "AllowSSHRdpOutbound" = {
      priority                   = 1000
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_ranges    = ["22", "3389"]
      source_address_prefix      = "*"
      destination_address_prefix = "VirtualNetwork"
    }
    "AllowAzureCloudOutbound" = {
      priority                   = 1001
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "AzureCloud"
    }
    "AllowBastionCommunication" = {
      priority                   = 1002
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_ranges    = ["8080", "5701"]
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
  }

  name                        = each.key
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = lookup(each.value, "destination_port_range", null)
  destination_port_ranges     = lookup(each.value, "destination_port_ranges", null)
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.subnets["bastion-subnet"].name
}

# NSG Rules for SQL subnet
resource "azurerm_network_security_rule" "sql_subnet_rules" {
  for_each = {
    "AllowVnetInbound" = {
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "1433"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
    "AllowAzureServicesInbound" = {
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "1433"
      source_address_prefix      = "Sql"
      destination_address_prefix = "VirtualNetwork"
    }
    "DenyAllInbound" = {
      priority                   = 4000
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }

  name                        = each.key
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.subnets["sql-subnet"].name
}

# Private DNS Zone for SQL
resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.common_tags
}

# Link Private DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "sql" {
  name                  = "${var.name_prefix}-sql-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled  = false
  tags                  = var.common_tags
}

# Custom DNS Zone (if provided)
resource "azurerm_private_dns_zone" "custom" {
  count               = var.dns_zone_name != "" ? 1 : 0
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
  tags                = var.common_tags
}

# Link Custom DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "custom" {
  count                 = var.dns_zone_name != "" ? 1 : 0
  name                  = "${var.name_prefix}-custom-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.custom[0].name
  virtual_network_id    = azurerm_virtual_network.main.id
  registration_enabled  = true
  tags                  = var.common_tags
}
