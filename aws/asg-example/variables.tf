variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "eu-west-2"
}

# ubuntu-18.04 (x64)
variable "aws_amis" {
  default = {
    "eu-west-2" = "ami-0b1912235a9e70540"
  }
}

variable "availability_zones" {
  default     = "eu-west-2a,eu-west-2b,eu-west-2c"
  description = "List of availability zones, use AWS CLI to find your "
}

variable "key_name" {
  description = "Name of AWS key pair"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

variable "asg_min" {
  description = "Min numbers of servers in ASG"
  default     = "1"
}

variable "asg_max" {
  description = "Max numbers of servers in ASG"
  default     = "2"
}

variable "asg_desired" {
  description = "Desired numbers of servers in ASG"
  default     = "1"
}
