variable "my_region" {
  type = string
  default = "eu-west-2"
}
variable "my_ami" {
  description = "my default image"
  type = string 
  default = "ami-006a0174c6c25ac06"
}

variable "my_bucket" {
  default = "dah-potato-bucket"
}

