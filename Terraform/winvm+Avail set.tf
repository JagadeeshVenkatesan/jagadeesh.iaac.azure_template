provider "azurerm" {
  subscription_id ="de7365e2-8329-48fc-8273-4ab1574e6b4b"
  client_id       ="53b4a79e-e1eb-4415-aa11-7a3fee9e09fc"
  client_secret   ="LxW..Ur3yvn0YFc4Gb~H69l1yeJkYADoKL"
  tenant_id       ="687f51c3-0c5d-4905-84f8-97c683a5b9d1"
  features {}
}
resource "azurerm_resource_group" "main" {
  name     = "Jagadeesh"
  location = "West US 2"
}

resource "azurerm_virtual_network" "main" {
  name                = "myvnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_availability_set" "main" {
  name                = "availability_set"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  managed             = "true"
}

resource "azurerm_network_interface" "main" {
  name                = "win_vm_nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "main" {
  name                = "WindowsServer"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_F2"
  admin_username      = "sysadmin"
  admin_password      = "Oneindia$123"
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}