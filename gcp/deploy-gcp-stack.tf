# Define provider (adjust based on your cloud provider)
provider "aws" {
  region = "us-west-2"
}

# Create a security group allowing inbound HTTP traffic
resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Allow inbound HTTP traffic"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create two instances running Nginx
resource "aws_instance" "web_instance" {
  count         = 2
  ami           = "ami-12345678"  # Replace with the desired AMI ID
  instance_type = "t2.micro"      # Replace with the desired instance type
  key_name      = "my-key-pair"   # Replace with your key pair name

  # Provision Nginx on the instances
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              service nginx start
              EOF

  # Attach the security group to the instances
  vpc_security_group_ids = [aws_security_group.web.id]
}

# Create an external load balancer
resource "aws_lb" "external_lb" {
  name               = "external-lb"
  load_balancer_type = "application"
  subnets            = ["subnet-12345678", "subnet-87654321"]  # Replace with your subnet IDs
}

# Attach instances to the load balancer
resource "aws_lb_target_group_attachment" "external_lb_attachment" {
  count             = 2
  target_group_arn  = aws_lb.external_lb.arn
  target_id         = aws_instance.web_instance[count.index].id
  port              = 80
}
