resource "azurerm_log_analytics_workspace" "log-analytics" {
  name                = "log-analytics-bv"
  location            = local.rg-location
  resource_group_name = local.rg-name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  depends_on = [ azurerm_resource_group.rg-publabb2 ]
}