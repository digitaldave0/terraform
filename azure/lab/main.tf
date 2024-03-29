terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.91.0"

    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "dah-rg" {
  name     = "dah-resources"
  location = "ukwest"
  tags = {
    environment = "dev"
  }
}