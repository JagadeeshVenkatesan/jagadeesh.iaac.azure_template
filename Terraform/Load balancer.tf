resource "azurerm_public_ip" "main" {
  name                = "PublicIPForLB"
  location            = "West US 2"
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "main" {
  name                = "VMLoadBalancer"
  location            = "West US 2"
  resource_group_name = azurerm_resource_group.main.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.main.id
  }
}