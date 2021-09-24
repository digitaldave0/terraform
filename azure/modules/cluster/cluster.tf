resource "azurerm_resource_group" "dah_aks_rg" {
    name = "dah_aks_rg"
    location = var.location
    }