resource "aws_internet_gateway" "my-vpc-internet-gateway" {
  vpc_id = "${aws_vpc.my-vpc.id}"

  tags {
    Name = "my-vpc-internet-gateway"
  }
}
