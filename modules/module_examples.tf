# local

module "web-app" {
    source = "../webapp"
}

# repo

module "consul" {
    source = "hashicorp/consul/aws"
    version = "0.1.0"
}

# https

module "example" {
    source = "github.com/hashicorp/example?ref=1.2.0"
}

# ssh

module "example" {
    source = "git@hub.com/hashicorp/example.git"
}

# generic

module "example" {
    source = "git::ssh//me@me.com/storage.git"
}