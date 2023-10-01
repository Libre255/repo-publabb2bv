resource "azurerm_application_insights" "app-insights" {
  name                = "app-insights-bv"
  location            = local.rg-location
  resource_group_name = local.rg-name
  application_type    = "web"
}

resource "azurerm_monitor_action_group" "api-app-actiong" {
  name                = "api-app-actiong-bv"
  resource_group_name = local.rg-name
  short_name          = "Action"
}

resource "azurerm_monitor_smart_detector_alert_rule" "smart-detector-rule" {
  name                = "smart-detector-rule-bv"
  resource_group_name = local.rg-name
  severity            = "Sev0"
  scope_resource_ids  = [azurerm_application_insights.app-insights.id]
  frequency           = "PT1M"
  detector_type       = "FailureAnomaliesDetector"

  action_group {
    ids = [azurerm_monitor_action_group.api-app-actiong.id]
  }
}