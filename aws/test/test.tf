provider "aws" {  
  region = "eu-west-2"
}
resource "aws_instance" "ubuntus" {  
  ami           = "ami-006a0174c6c25ac06"
  instance_type = "t2.micro"
  tags = {
    Name = "ubuntu-server" 
  }
}
