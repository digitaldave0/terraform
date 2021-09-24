resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}


output "tls_private_key" { value = tls_private_key.example_ssh.private_key_pem }

resource "azurerm_resource_group" "rg" {
  name     = "dah-azure-test"
  location = var.location
}
resource "azurerm_availability_set" "terra_aset" {
  name                = "terraform-aset"
  platform_fault_domain_count = "2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_virtual_network" "vnet" {
  name                = "vNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example" {
  name                = "vnic-${(count.index)}"
  location            = azurerm_resource_group.rg.location
  count               = 2
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_linux_virtual_machine" "example" {
  name                = "linsrv${count.index}"
  count               = 2
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1ls"
  admin_username      = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
        username       = "azureuser"
        public_key     = tls_private_key.example_ssh.public_key_openssh

    }

  availability_set_id = azurerm_availability_set.terra_aset.id
  network_interface_ids = [
    azurerm_network_interface.example.*.id[count.index]
  ]

  os_disk {
    name                 = "server-${count.index}-os"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
tags = {
   environment = "terraform-dev-${count.index}"
 }
}
