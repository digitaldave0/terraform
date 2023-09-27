# Specify the provider and access details
provider "aws" {
  region = var.aws_region
}

# Import modules
module "elb" {
  source              = "./modules/elb"
  name                = "create-example-elb"
  instance_port       = 80
  instance_protocol   = "http"
  lb_port             = 80
  lb_protocol         = "http"
  healthy_threshold   = 2
  unhealthy_threshold = 2
  timeout             = 3
  target              = "HTTP:80/"
  interval            = 30
}

module "autoscaling" {
  source              = "./modules/autoscaling"
  name                = "terraform-example-asg"
  max_size            = var.asg_max
  min_size            = var.asg_min
  desired_capacity    = var.asg_desired
  launch_configuration = aws_launch_configuration.web-lc.name
  load_balancers      = [module.elb.name]
}

# ... Additional resources and configurations

