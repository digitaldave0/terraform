##-------------------------------------------
##  Terraform: Deploy A LAMP Stack In AWS  ##
##-------------------------------------------


## downloads the relevante aws provider

provider "aws" {
  region     = "${var.region}"
}
## get AZ's details
data "aws_availability_zones" "availability_zones" {}

## create VPC
resource "aws_vpc" "myvpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags = {
    Name = "myvpc"
  }
}
## create public subnet
resource "aws_subnet" "myvpc_public_subnet" {
  vpc_id                  = "${aws_vpc.myvpc.id}"
  cidr_block              = "${var.subnet_one_cidr}"
  availability_zone       = "${data.aws_availability_zones.availability_zones.names[0]}"
  map_public_ip_on_launch = true
  tags = {
    Name = "myvpc_public_subnet"
  }
}


## create private subnet one
resource "aws_subnet" "myvpc_private_subnet_one" {
  vpc_id            = "${aws_vpc.myvpc.id}"
  cidr_block        = "${element(var.subnet_two_cidr, 0)}"
  availability_zone = "${data.aws_availability_zones.availability_zones.names[0]}"
  tags = {
    Name = "myvpc_private_subnet_one"
  }
}
# create private subnet two
resource "aws_subnet" "myvpc_private_subnet_two" {
  vpc_id            = "${aws_vpc.myvpc.id}"
  cidr_block        = "${element(var.subnet_two_cidr, 1)}"
  availability_zone = "${data.aws_availability_zones.availability_zones.names[1]}"
  tags = {
    Name = "myvpc_private_subnet_two"
  }
}
## create internet gateway
resource "aws_internet_gateway" "myvpc_internet_gateway" {
  vpc_id = "${aws_vpc.myvpc.id}"
  tags=  {
    Name = "myvpc_internet_gateway"
  }
}
## create public route table (assosiated with internet gateway)
resource "aws_route_table" "myvpc_public_subnet_route_table" {
  vpc_id = "${aws_vpc.myvpc.id}"
  route {
    cidr_block = "${var.route_table_cidr}"
    gateway_id = "${aws_internet_gateway.myvpc_internet_gateway.id}"
  }
  tags = {
    Name = "myvpc_public_subnet_route_table"
  }
}
## create private subnet route table
resource "aws_route_table" "myvpc_private_subnet_route_table" {
  vpc_id = "${aws_vpc.myvpc.id}"
  tags = {
    Name = "myvpc_private_subnet_route_table"
  }
}
## create default route table
resource "aws_default_route_table" "myvpc_main_route_table" {
  default_route_table_id = "${aws_vpc.myvpc.default_route_table_id}"
  tags = {
    Name = "myvpc_main_route_table"
  }
}
## associate public subnet with public route table
resource "aws_route_table_association" "myvpc_public_subnet_route_table" {
  subnet_id      = "${aws_subnet.myvpc_public_subnet.id}"
  route_table_id = "${aws_route_table.myvpc_public_subnet_route_table.id}"
}
## associate private subnets with private route table
resource "aws_route_table_association" "myvpc_private_subnet_one_route_table_assosiation" {
  subnet_id      = "${aws_subnet.myvpc_private_subnet_one.id}"
  route_table_id = "${aws_route_table.myvpc_private_subnet_route_table.id}"
}
resource "aws_route_table_association" "myvpc_private_subnet_two_route_table_assosiation" {
  subnet_id      = "${aws_subnet.myvpc_private_subnet_two.id}"
  route_table_id = "${aws_route_table.myvpc_private_subnet_route_table.id}"
}
## create security group for web
resource "aws_security_group" "web_security_group" {
  name        = "web_security_group"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.myvpc.id}"
  tags = {
    Name = "myvpc_web_security_group"
  }
}
## create security group ingress rule for web
resource "aws_security_group_rule" "web_ingress" {
  count             = "${length(var.web_ports)}"
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "${element(var.web_ports, count.index)}"
  to_port           = "${element(var.web_ports, count.index)}"
  security_group_id = "${aws_security_group.web_security_group.id}"
}
## create security group egress rule for web
resource "aws_security_group_rule" "web_egress" {
  count             = "${length(var.web_ports)}"
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "${element(var.web_ports, count.index)}"
  to_port           = "${element(var.web_ports, count.index)}"
  security_group_id = "${aws_security_group.web_security_group.id}"
}
## create security group for db
resource "aws_security_group" "db_security_group" {
  name        = "db_security_group"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.myvpc.id}"
  tags = {
    Name = "myvpc_db_security_group"
  }
}
## create security group ingress rule for db
resource "aws_security_group_rule" "db_ingress" {
  count             = "${length(var.db_ports)}"
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "${element(var.db_ports, count.index)}"
  to_port           = "${element(var.db_ports, count.index)}"
  security_group_id = "${aws_security_group.db_security_group.id}"
}
## create security group egress rule for db
resource "aws_security_group_rule" "db_egress" {
  count             = "${length(var.db_ports)}"
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "${element(var.db_ports, count.index)}"
  to_port           = "${element(var.db_ports, count.index)}"
  security_group_id = "${aws_security_group.db_security_group.id}"
}
## create EC2 instance
resource "aws_instance" "my_web_instance" {
  ami                    = "${lookup(var.images, var.region)}"
  instance_type          = "t2.large"
  key_name               = "myprivate"
  vpc_security_group_ids = ["${aws_security_group.web_security_group.id}"]
  subnet_id              = "${aws_subnet.myvpc_public_subnet.id}"
  tags = {
    Name = "my_web_instance"
  }
  volume_tags = {
    Name = "my_web_instance_volume"
  }
  provisioner "remote-exec" { #install apache, mysql client, php
    inline = [
      "sudo mkdir -p /var/www/html/",
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo service httpd start",
      "sudo usermod -a -G apache centos",
      "sudo chown -R centos:apache /var/www",
      "sudo yum install -y mysql php php-mysql",
	  ]
  }
  provisioner "file" { #copy the index file form local to remote
   source      = "d:\\terraform\\index.php"
    destination = "/tmp/index.php"
  }
  provisioner "remote-exec" {
	inline = [
	   "sudo mv /tmp/index.php /var/www/html/index.php"
	   ]
	}
 
  connection {
    type     = "ssh"
    user     = "centos"
    password = ""
    host     = self.public_ip 
    #copy <private.pem> to your local instance to the home directory
	#chmod 600 id_rsa.pem
    private_key = "${file("myprivate.pem")}"
}
  
}

## create aws rds subnet groups
resource "aws_db_subnet_group" "my_database_subnet_group" {
  name       = "mydbsg"
  subnet_ids = ["${aws_subnet.myvpc_private_subnet_one.id}", "${aws_subnet.myvpc_private_subnet_two.id}"]
  tags = {
    Name = "my_database_subnet_group"
  }
}
## create aws mysql rds instance
resource "aws_db_instance" "my_database_instance" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  port                   = 3306
  vpc_security_group_ids = ["${aws_security_group.db_security_group.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.my_database_subnet_group.name}"
  name                   = "mydb"
  identifier             = "mysqldb"
  username               = "myuser"
  password               = "mypassword"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  tags = {
    Name = "my_database_instance"
  }
}
## output webserver and dbserver address
output "db_server_address" {
  value = "${aws_db_instance.my_database_instance.address}"
}
output "web_server_address" {
  value = "${aws_instance.my_web_instance.public_dns}"
}