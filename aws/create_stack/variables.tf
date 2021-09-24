
variable "hostnames" {
  default = {
    "one" = {
      my_env = "ubuntu"
      ami = "ami-006a0174c6c25ac06"
      my_keyname = "UbuntuServerKeyPair"
      my_instance_type = "t2.micro"
      my_user = "ubuntu"
      server_name = "ubuntu-server"
      my_private_key_path = "../UbuntuServerKeyPair.pem"
    },
    "two" = {
      my_env = "amazon"
      ami = "ami-01a6e31ac994bbc09"
      my_keyname = "AmazonKey"
      my_instance_type = "t2.micro"
      my_user = "ec2-user"
      server_name = "amazon-server"
      my_private_key_path = "../AmazonKey.pem"
    }
  }
}

variable "region" {
  default = "eu-west-2"
}
variable "network_address_space" {
  default = "10.1.0.0/16"
}
variable "subnet1_address_space" {
  default = "10.1.0.0/24"
}