resource "azurerm_service_plan" "seviceplan" {
  name                = "serviceplan-bv"
  resource_group_name = local.rg-name
  location            = local.rg-location
  sku_name            = "P1v3"
  os_type             = "Windows"
  depends_on = [ azurerm_resource_group.rg-publabb2 ]
}

resource "azurerm_windows_web_app" "api-app" {
  name                = "api-app-bv"
  resource_group_name = local.rg-name
  location            = local.rg-location
  service_plan_id     = azurerm_service_plan.seviceplan.id

  site_config {
    application_stack {
      current_stack = "dotnet"
      dotnet_version = "v7.0"
    }
  }
  /*
  logs { # we add this after we fix the sotrage account sas token url
    detailed_error_messages = true
        http_logs {
            azure_blob_storage {
              retention_in_days = 5
              sas_url = "https://${azurerm_storage_account.WebappLoggs.name}.blob.core.windows.net/${azurerm_storage_container.Webappcontainer.name}${data.azurerm_storage_account_blob_container_sas.accountsas.sas}"
            }
      
    }
    
  }
  */
  depends_on = [ azurerm_service_plan.seviceplan ]
}

resource "azurerm_app_service_virtual_network_swift_connection" "ApptoSnet" {
  app_service_id = azurerm_windows_web_app.api-app.id
  subnet_id      = azurerm_subnet.api-subnet.id
  depends_on = [ azurerm_windows_web_app.api-app, azurerm_subnet.api-subnet ]
}

resource "azurerm_storage_account" "storageaccountlogs" {
  name                     = "storageaccountlogsbv"
  resource_group_name      = local.rg-name
  location                 = local.rg-location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on = [ azurerm_resource_group.rg-publabb2 ]
}

resource "azurerm_monitor_diagnostic_setting" "api-app-diag" {
  name               = "api-app-diag-bv"
  target_resource_id = azurerm_windows_web_app.api-app.id
  storage_account_id = azurerm_storage_account.storageaccountlogs.id
  
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
    }
  }

  depends_on = [ azurerm_resource_group.rg-publabb2 ]
}