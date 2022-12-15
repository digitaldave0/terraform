terraform {
    backend = "s3" {
        bucket  = "devops-directive-tf-state"
        key     = "terraform.tfstate"
        region  = "eu-west-2"
        dynamodb_table = "terraform-state-locking"
        encrypt = true
    }
}

required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "-> 3.0"
    }
}

provider = "aws" {
    region = "var.my_region"
}

resource "aws_instance" "instance_1" {
    ami = "var.my_ami"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.instance.name]
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello World 1" > index.html
                python3 -m http.server 8080 &
                EOF
}

resource "aws_instance" "instance_2" {
    ami = "var.my_ami"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.instance.name]
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello World 2" > index.html
                python3 -m http.server 8080 &
                EOF
}

resource "aws_s3_bucket" "{var.my_bucket}" {
    bucket = "var.my_bucket"
    force_destroy = true
    versioning {
       enabled = true
    }
}

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

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.load_balancer.load_balancer.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "fixed-response"

        fixed_response {
            content_type = "text/plain"
            message_body = "404: page not found"
            status_code = 404
        }
resource "aws_lb_target_group" "instances" {
    name = "example-target-group"
    port = 8080
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default_vpc.id

    health_check {
        path = "/"
        protocol = "HTTP"
        matcher = "200"
        interval = 15
        timeout = 3
        healthy_threshold = 2
        unhealthy_threshold = 2
    }

resource "aws_lb_target_group_attachment" "instance1" {
    target_group_arn = aws_lb_traget_group.instances.arn
    target_id = aws_instance.instance_1.id
    port = 8080
}

resource "aws_lb_target_group_attachment" "instance2" {
    target_group_arn = aws_lb_traget_group.instances.arn
    target_id = aws_instance.instance_2.id
    port = 8080
}

resource "aws_lb_listener_rule" "instances" {
    aws_lb_listener_arn = aws_lb_listener_arn
    priority = 100

    condition {
        path_pattern {
            values = ["*"]
        }    
    }

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.instances.arn
    }
resource "aws_secrity_group" "alb" {
    name = "alb-security-group"
}

resource = "aws_security_group_rule" "allow_alb_http_inbound" {
    type    = "ingress"
    security_group_id = aws_security_group.alb.id

    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

resource = "aws_security_group_rule" "allow_alb_all_outbound" {
    type    = "egress"
    security_group_id = aws_security_group.alb.id

    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_lb" "load_balancer" {
    name = "web-app-lb"
    load_balancer_type = "application"
    subnets = data.aws_subnet_ids.default_subnet.ids
    security_groups = [aws_secrity_group.alb.id]

        }

    }

}