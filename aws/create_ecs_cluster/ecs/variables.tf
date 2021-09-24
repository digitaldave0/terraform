variable "ecs-target-group-arn" {}

variable "ecs-cluster-name" {
    default = "my-ecs-cluster"
}

variable "ecs-service-role-arn" {
    default = "my-ecs-cluster"
}

variable "ecs-service-name" {
    default = "my-ecs-service"
}

variable "ecs-load-balancer-name" {
    default = "my-ecs-load-balancer"
}