resource "azurerm_windows_virtual_machine_scale_set" "main" {
  name                = "vmss"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Standard_F2"
  instances           = 1
  admin_password      = "Oneindia$123"
  admin_username      = "sysadmin"

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "rs5-pro"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "vmss_NIC"
    primary = true

    ip_configuration {
      name      = "vmss_NIC_ip"
      primary   = true
      subnet_id = azurerm_subnet.main.id
    }
  }
}