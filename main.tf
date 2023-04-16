terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.52.0"
    }
  }
}


provider "azurerm" {
  features {}

  subscription_id = "7ce19ec8-a6d2-4e78-bd7d-eddbc3806b77"
  client_id = "6863a95e-5a76-4495-9567-161c046229e9"
  client_secret = "yv~8Q~F4ST4HY000YyxSYSSPVeRwhJNGwbjAAbFg"
  tenant_id = "d026a7a2-da4b-40ed-a2dc-629755b8f7d3"
  
}


resource "azurerm_resource_group" "mayur" {
  name     = "mayur"
  location = "Central India"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.mayur.location
  resource_group_name = azurerm_resource_group.mayur.name
}

resource "azurerm_subnet" "pol" {
  name                 = "pol"
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.mayur.name
}

resource "azurerm_network_interface" "web-ip" {
  name                = "web-ip"
  location            = azurerm_resource_group.mayur.location
  resource_group_name = azurerm_resource_group.mayur.name

  ip_configuration {
    name                          = "ip-configuration"
    subnet_id                     = azurerm_subnet.pol.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "linux-vm" {
  name                  = "linux-vm"
  location              = azurerm_resource_group.mayur.location
  resource_group_name   = azurerm_resource_group.mayur.name
  size                  = "Standard_A1_v2"
  admin_username        = "sysadmin"
  network_interface_ids = [azurerm_network_interface.web-ip.id]
  admin_password        = "Sysadmin@123"
  disable_password_authentication = false



  


  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "linux-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

 
}

data "azurerm_virtual_machine" "linux-vm" {
  name                = "linux-vm"
  resource_group_name = "mayur"
}




output "vm_metadata" {
   
  value = {
    name = azurerm_linux_virtual_machine.linux-vm.name
    size = azurerm_linux_virtual_machine.linux-vm.size
    offer = azurerm_linux_virtual_machine.linux-vm.source_image_reference[0].offer


  }

  
}















