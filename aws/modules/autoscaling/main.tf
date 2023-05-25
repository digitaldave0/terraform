variable "name" {
  description = "Name of the Auto Scaling group"
  type        = string
}

variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling group"
  type        = number
}

variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling group"
  type        = number
}

variable "desired_capacity" {
  description = "Desired capacity of the Auto Scaling group"
  type        = number
}

variable "launch_configuration" {
  description = "Name of the launch configuration to use"
  type        = string
}

variable "load_balancers" {
  description = "List of load balancers to associate with the Auto Scaling group"
  type        = list(string)
}

resource "aws_autoscaling_group" "web-asg" {
  name                 = var.name
  max_size             = var.max_size
  min_size             = var.min_size
  desired_capacity     = var.desired_capacity
  force_delete         = true
  launch_configuration = var.launch_configuration
  load_balancers       = var.load_balancers

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }
}

