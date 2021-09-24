resource "aws_ecs_cluster" "my-ecs-cluster" {
    name = "${var.ecs-cluster-name}"
}
