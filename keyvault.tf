data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault-resource" {
  name                        = "keyvault-bv"
  location                    = local.rg-location
  resource_group_name         = local.rg-name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
  depends_on = [ azurerm_resource_group.rg-publabb2 ]
}

resource "azurerm_key_vault_secret" "keyvault-sqlserver" {
  name         = "keyvault-sqlserver-bv"
  value        = var.sql-password
  key_vault_id = azurerm_key_vault.keyvault-resource.id
  depends_on = [ azurerm_key_vault.keyvault-resource ]
}

resource "azurerm_storage_account" "storageacc" {
  name                     = "storageaccbv"
  resource_group_name      = local.rg-name
  location                 = local.rg-location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_monitor_diagnostic_setting" "monitor-diag" {
  name               = "monitor-diag"
  target_resource_id = azurerm_key_vault.keyvault-resource.id
  storage_account_id = azurerm_storage_account.storageacc.id

  enabled_log {
    category = "AuditEvent"

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}