resource "azurerm_private_dns_zone" "dns-zone" {
  name                = "ithsapp22.azure.com"
  resource_group_name = local.rg-name
  depends_on = [ azurerm_resource_group.rg-publabb2 ]
}
resource "azurerm_private_dns_zone_virtual_network_link" "dns-vn-link" {
  name                  = "app.ithsapp22.azure.com"
  private_dns_zone_name = azurerm_private_dns_zone.dns-zone.name
  virtual_network_id    = azurerm_virtual_network.vn-publabb2.id
  resource_group_name   = local.rg-name
  depends_on = [ azurerm_private_dns_zone.dns-zone,
                azurerm_virtual_network.vn-publabb2]            
}