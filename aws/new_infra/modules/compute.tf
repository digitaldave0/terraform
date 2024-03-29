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
