provider "azurerm" {
  
    subscription_id = var.subscription_id
    client_id = var.serviceprinciple_id
    client_secret = var.serviceprinciple_key
    tenant_id = var.tenant_id

    features {}
}

module "create_vm_lb" {
    source = "../modules/create_vm_lb"
    serviceprinciple_id = var.serviceprinciple_id
    serviceprinciple_key = var.serviceprinciple_key
    location = var.location
	}

