provider "aws" {
  region = "eu-west-1"
}

# create vpc

resource "aws_vpc" "prod-vpc" {
    cidr_block = "10.0.0./16"
    tags = {
        Name = "production"
    }
}


# create igw

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.prod-vpc.id
  
}

# custom route table

resource "aws_route_table" "prod-route" {
    vpc_id = aws_vpc.prod-vpc

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
    route {
        ipv6_cidr_block = "::/0" 
        egress_only_gateway_id = aws_internet_gateway.gw.id
    }

    tags = {
        Name = "production"
    }

}

# create subnet

resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-1"
}
tags = {
    Name = "prod-subnet"
}

resource "aws_route_table_association" "name" {
    subnet_id = aws_subnet.subnet-1.id
    route_table_id = aws_route_table.prod-route.id
}

# create sg

resource "aws_security_group" "allow_web_traffic" {
  name = "allow_web_traffic"
  description = "Allow Web Traffic"
  vpc_id = aws_vpc.prod-vpc.id

  ingress {
      decscription = "Allow from VPC"
      from_port = 443
      to_port = 443
      protocol =  "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
      decscription = "Allow from VPC"
      from_port = 80
      to_port = 80
      protocol =  "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
      decscription = "Allow from VPC"
      from_port = 22
      to_port = 22
      protocol =  "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
egress {
      decscription = "Allow from VPC"
      from_port = 0
      to_port = 0
      protocol =  "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
      Name = "allow web sg"
  }
}

# create eni 

resource "aws_network_interface" "test" {
    subnet_id =  aws_subnet.subnet-1.id
    private_ips = ["10.0.1.50"]
    security_groups = aws_security_group.allow_web_traffic.id

}

# create elastic ip

resource aws_eip "" {
    vpc = true
    network_interface = aws_network_interface.test.id
    associate_with_private_ip = "10.0.1.50"
    depends_on = aws_internet_gateway.gw
}

# create ami
resource " aws_instance" "my_instance" {
    ami = ""
    instance_type = "t2.micro"
    availability_zone = "eu-west-1"
    key_name = "joe"
    aws_network_interface  {
        device_index = 0
        network_interface_id = aws_network_interface.test.id
    }
user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install apache2 -y
    sudo systemctl start apache2
    sudo bash -c 'echo webserver > /var/www/html/index.html'
    EOF
    tags = {
        Name = "web-server"
    }
}