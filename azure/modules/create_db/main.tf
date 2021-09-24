resource "azurerm_resource_group" "rg" {
  name     = "terraform-test"
  location = var.location
}