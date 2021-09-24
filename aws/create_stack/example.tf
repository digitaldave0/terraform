provider "aws" {
  region = "${var.region}"
}

locals {
  ip        = ["86.6.204.7/32"]
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.network_address_space}"
  enable_dns_hostnames = "true"

}

resource "aws_internet_gateway" "igw" {
  vpc_id =  "${aws_vpc.vpc.id}"
}

resource "aws_subnet" "subnet1" {
  cidr_block              = "${var.subnet1_address_space}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

}

# ROUTING #
resource "aws_route_table" "rtb" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}

resource "aws_route_table_association" "rta-subnet1" {
  subnet_id      = "${aws_subnet.subnet1.id}"
  route_table_id = "${aws_route_table.rtb.id}"
}

# SECURITY GROUPS #
# Nginx security group 
resource "aws_security_group" "nginx-sg" {
  name   = "nginx_sg"
  vpc_id = "${aws_vpc.vpc.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${local.ip}"
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ubuntu-server" {
  count = 1
  ami           = "${var.ami}"
  instance_type = "${var.my_instance_type}"
  subnet_id     = "${aws_subnet.subnet1.id}"
  key_name    = "${var.my_keyname}"
  vpc_security_group_ids = ["${aws_security_group.nginx-sg.id}"]

                            
  tags = {
    Name = "${var.server_name}-${count.index}"
    Type = "Install ngnix test"
}

  connection {
    type        = "ssh"
    host        = "${self.public_ip}"
    user        = "ubuntu"
    private_key = "${(file(var.my_private_key_path))}"
    agent       = "false"
    }
   provisioner "remote-exec" {
    inline = [
      "sudo apt update --fix-missing -y",
      "sudo apt install nginx -y",
      "sudo systemctl start nginx"
    ]
  }
}