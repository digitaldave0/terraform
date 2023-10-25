provider "aws" {
  region = "us-east-1"  # Change to your desired region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"  # Change to your desired availability zone
  map_public_ip_on_launch = true
}

resource "aws_ecs_cluster" "my_ecs_cluster" {
  name = "MyECSCluster"
}

resource "aws_lb_target_group" "my_target_group" {
  name     = "MyTargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
}

resource "aws_launch_configuration" "my_launch_configuration" {
  name_prefix = "MyLaunchConfig"
  image_id    = "ami-12345678"  # Replace with your desired AMI
  instance_type = "t2.micro"    # Replace with your desired instance type
  security_groups = [aws_security_group.my_security_group.id]
  key_name        = "your-key-pair-name"
  user_data       = file("userdata.sh")  # If you have custom user data

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "my_security_group" {
  name_prefix = "MySG"
  # Define your security group rules here
}

resource "aws_autoscaling_group" "my_auto_scaling_group" {
  availability_zones = ["us-east-1a"]
  launch_configuration = aws_launch_configuration.my_launch_configuration.name
  min_size = 2
  max_size = 4
  desired_capacity = 2
  target_group_arns = [aws_lb_target_group.my_target_group.arn]
}
