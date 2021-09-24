resource "aws_ecs_task_definition" "my-sample-definition" {
    family                = "my-sample-definition"
    container_definitions = "${file("./ecs/task-definition.json")}"
}
