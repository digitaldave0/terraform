terraform {
  required_version = "> 0.7.0"
}

provider "aws" {
  region = "eu-west-2"
}

module "iam" {
  source = "./iam"
}

module "vpc" {
  source = "./vpc"
}

module "ec2" {
  source = "./ec2"

  vpc-id                    = module.vpc.id
  security-group-id         = module.vpc.security-group-id
  subnet-id-1               = module.vpc.subnet1-id
  subnet-id-2               = module.vpc.subnet2-id
  ecs-instance-role-name    = module.iam.ecs-instance-role-name
  ecs-instance-profile-name = module.iam.ecs-instance-profile-name
}
