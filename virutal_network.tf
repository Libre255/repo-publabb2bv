resource "azurerm_virtual_network" "vn-publabb2" {
  name                = "vn-publabb2-bv"
  location            = local.rg-location
  resource_group_name = local.rg-name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "db-subnet" {
  name                 = "db-subnet-bv"
  resource_group_name  = local.rg-name
  virtual_network_name = azurerm_virtual_network.vn-publabb2.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage"]
  enforce_private_link_endpoint_network_policies = true
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet" "api-subnet" {
  name                 = "api-subnet-bv"
  resource_group_name  = local.rg-name
  virtual_network_name = azurerm_virtual_network.vn-publabb2.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "delagation-bv"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_network_security_group" "security-group" {
  name                = "securitygroup-publabb2-bv"
  location            = local.rg-location
  resource_group_name = local.rg-name

  security_rule {
    name                       = "securitygroup-rule-publabb2-bv"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "subnet-and-security-connection" {
  subnet_id                 = azurerm_subnet.api-subnet.id
  network_security_group_id = azurerm_network_security_group.security-group.id
}