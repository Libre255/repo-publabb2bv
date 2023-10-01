resource "azurerm_resource_group" "rg-publabb2" {
    name = "rg-publabb2-bv"
    location = "West Europe"
}
locals {
  rg-name= azurerm_resource_group.rg-publabb2.name
  rg-location = azurerm_resource_group.rg-publabb2.location
}