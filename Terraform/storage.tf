variable "storage" {
  default = "acadaz4ms"
}

# Definicao do Storage Account
resource "azurerm_storage_account" "storageacc" {
  name                     = "stg${var.storage}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "Producao"
    departamento = "Consultoria"
    aula = "aula01"
  }
}


#Definicao de Container
resource "azurerm_storage_container" "container" {
  name                  = "stgcont${var.storage}"
  storage_account_name  = azurerm_storage_account.storageacc.name
  container_access_type = "private"

}


#definicao do Blolb Storage 1
resource "azurerm_storage_blob" "stgblob1" {
  name                   = "blolbvideosprd"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "some-local-file.zip"

}


#definicao do Blolb Storage 2
resource "azurerm_storage_blob" "stgblob2" {
  name                   = "blolbimagensprd"
  storage_account_name   = azurerm_storage_account.storageacc.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "some-local-file.zip"

}