provider "aws" {
  region = "us-east-1"  # Change to your desired region
}

module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws"
  # Specify module input variables as needed
}

module "autoscaling" {
  source = "terraform-aws-modules/autoscaling/aws"
  launch_configuration_name = aws_launch_configuration.my_launch_configuration.name
  # Specify other module input variables
}

resource "null_resource" "ansible_provisioner" {
  triggers = {
    # You can use triggers to re-run the provisioner when variables change
    instance_ids = aws_instance.example.*.id
  }

  connection {
    type        = "ssh"
    host        = aws_instance.example.*.public_ip
    user        = "ec2-user"  # Change to your instance's SSH user
    private_key = file("path/to/your/private/key.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",  # Update packages
      "sudo yum install ansible -y",  # Install Ansible
      "ansible-playbook -i localhost, -c local /path/to/installing_ruby_v1.yml",  # Run Ansible playbook
    ]
  }
}
