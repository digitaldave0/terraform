 
resource "aws_route_table" "my-vpc-route-table" {
  vpc_id = "${aws_vpc.my-vpc.id}"

  route {
    cidr_block = "10.0.0.0/0"
    gateway_id = "${aws_internet_gateway.my-vpc-internet-gateway.id}"
  }

  tags {
    Name = "my-vpc-route-table"
  }
}

resource "aws_route_table_association" "my-vpc-route-table-association1" {
  subnet_id      = "${aws_subnet.my-vpc-subnet1.id}"
  route_table_id = "${aws_route_table.my-vpc-route-table.id}"
}

resource "aws_route_table_association" "my-vpc-route-table-association2" {
  subnet_id      = "${aws_subnet.my-vpc-subnet2.id}"
  route_table_id = "${aws_route_table.my-vpc-route-table.id}"
}
