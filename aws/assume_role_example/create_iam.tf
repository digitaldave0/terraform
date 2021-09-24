provider "aws" {  
  region = "eu-west-2"
}
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "tag-value"
  }
}
resource "aws_iam_instance_profile" "my_ec2_profile" {
  name = "my_ec2_profile"
  role = "${aws_iam_role.ec2_role.name}"
}

resource "aws_iam_role_policy" "myc2_test_policy" {
  name = "my_ec2_test_policy"
  role = "${aws_iam_role.ec2_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
resource "aws_instance" "role-test" {
  ami = "ami-006a0174c6c25ac06"
  instance_type = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.my_ec2_profile.name}"
  key_name = "UbuntuServerKeyPair"
   tags = {
    Name = "ubuntu-server" 
  }
}