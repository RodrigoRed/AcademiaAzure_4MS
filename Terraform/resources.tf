variable "prefix" {
  default = "acadaz-prd-4ms"
}


# Definição do Resource Group
resource "azurerm_resource_group" "rg" {
    name = "rg-${var.prefix}"
    location = "eastus2"
   
    tags = {
    environment = "Producao"
    departamento = "Consultoria"
    aula = "aula01"
  }
}


# Definição da rede
resource "azurerm_virtual_network" "vnet" {
  name                = "VNET-10.133.0.0-${var.prefix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.133.0.0/16"]

 tags = {
    environment = "Producao"
    departamento = "Consultoria"
    aula = "aula01"
  } 
}


#Definição da sub-rede
resource "azurerm_subnet" "subnet" {
  name                 = "SNET-10.133.1.0-${var.prefix}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.133.1.0/24"]
  

}


#Definição do NSG
resource "azurerm_network_security_group" "nsg" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Port_3389"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "177.18.215.97"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Producao"
    departamento = "Consultoria"
    aula = "aula01"
  }
}


#Definição do IP Publico
resource "azurerm_public_ip" "pip" {
  name                = "pip-vm1-${var.prefix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku = "basic"
  allocation_method = "Dynamic"
  
  tags = {
    environment = "Producao"
    departamento = "Consultoria"
    aula = "aula01"
  }
}


#Definicao da Network Interface
resource "azurerm_network_interface" "nic01" {
  name                = "nic-nic01-vm1-${var.prefix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

    tags = {
    environment = "Producao"
    departamento = "Consultoria"
    aula = "aula01"
  }
  
}

# Definicao da Virtual Machine
resource "azurerm_windows_virtual_machine" "vm" {
  name                            = "vm-vm01-${var.prefix}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_B4ms"
  admin_username                  = "adminrodrigo"
  admin_password                  = "AcessoHome1971"
  network_interface_ids = [
    azurerm_network_interface.nic01.id,
  ]

    tags = {
    environment = "Producao"
    departamento = "Consultoria"
    aula = "aula01"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}
