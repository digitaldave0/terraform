module "cluster" {
    source = "./modules/cluster/"
    serviceprinciple_id = var.erviceprinciple_id
    serviceprinciple_key = var.serviceprinciple_key
    location = var.location
}
    
