resource "azurerm_mssql_server" "mssql-server" {
  name                         = "mssql-server-bv"
  resource_group_name          = local.rg-name
  location                     = local.rg-location
  version                      = "12.0"
  administrator_login          = var.sql-servername
  administrator_login_password = var.sql-password
  minimum_tls_version          = "1.2"
  identity {
    type = "SystemAssigned"
  }
    depends_on = [ azurerm_resource_group.rg-publabb2 ]
}

resource "azurerm_mssql_database" "mssql-db" {
  name           = "mssql-db-bv"
  server_id      = azurerm_mssql_server.mssql-server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  read_scale     = true
  sku_name       = "P2" 
  
  depends_on = [ azurerm_mssql_server.mssql-server ]

}

resource "azurerm_mssql_firewall_rule" "firewall-ip" {
  name             = "firewall-ip-bv"
  server_id        = azurerm_mssql_server.mssql-server.id
  start_ip_address = var.sql-ip-adress
  end_ip_address   = var.sql-ip-endadress
  depends_on = [ azurerm_mssql_server.mssql-server]
}

data "azurerm_subscription" "primary" {
}

data "azurerm_client_config" "example" {
}

resource "azurerm_role_assignment" "role-assig" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_mssql_server.mssql-server.identity.0.principal_id
  depends_on = [ azurerm_mssql_server.mssql-server ]
}

resource "azurerm_sql_virtual_network_rule" "sql-vn-rule" {
  name                = "sql-vn-rule-bv"
  resource_group_name = local.rg-name
  server_name         = azurerm_mssql_server.mssql-server.name
  subnet_id           = azurerm_subnet.db-subnet.id

}

resource "azurerm_sql_firewall_rule" "sql-firewall-opentrafic" {
  name                = "sql-firewall-opentrafic-bv"
  resource_group_name = local.rg-name
  server_name         = azurerm_mssql_server.mssql-server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_storage_account" "sqlserverlogs" {
  name                = "sqlserverlogsbv"
  resource_group_name = local.rg-name

  location                 = local.rg-location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  allow_nested_items_to_be_public = false

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["127.0.0.1"]
    virtual_network_subnet_ids = [azurerm_subnet.db-subnet.id]
    bypass                     = ["AzureServices"]
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_mssql_server_extended_auditing_policy" "sql-audi-policy" {
  storage_endpoint       = azurerm_storage_account.sqlserverlogs.primary_blob_endpoint
  server_id              = azurerm_mssql_server.mssql-server.id
  retention_in_days      = 6
  log_monitoring_enabled = true

  storage_account_subscription_id = data.azurerm_subscription.primary.subscription_id

  depends_on = [
    azurerm_role_assignment.role-assig,
    azurerm_storage_account.sqlserverlogs,
  ]
}

