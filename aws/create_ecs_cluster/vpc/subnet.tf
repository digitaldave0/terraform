 
resource "aws_subnet" "my-vpc-subnet1" {
    vpc_id     = "${aws_vpc.my-vpc.id}"
    cidr_block = "10.0.0.0/24"
    availability_zone = "eu-west-2a"

    tags {
        Name = "mesh-vpc-subnet"
    }
}

resource "aws_subnet" "my-vpc-subnet2" {
    vpc_id     = "${aws_vpc.my-vpc.id}"
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-2b"

    tags {
        Name = "my-vpc-subnet"
    }
}

output "subnet1-id" {
  value = "${aws_subnet.my-vpc-subnet1.id}"
}

output "subnet2-id" {
  value = "${aws_subnet.my-vpc-subnet2.id}"
}
