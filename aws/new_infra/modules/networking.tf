server_side_encryption_configuration {
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }

data "aws_vpc" "default_vpc" {
    default = "true"
}

data "aws_subnet_ids" "default_subnet" {
    vpc_id = "data.aws_vpc.default_vpc.id"
}

resource "aws_security_group" "instances" {
    name = "instance-security-group" 
}

resource = "aws_security_group_rule" "allow_http_inbound" {
    type    = "ingress"
    security_group_id = aws_security_group.instances.id

from_port = 8080
to_port = 8080
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}