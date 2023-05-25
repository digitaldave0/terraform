variable "name" {
  description = "Name of the Elastic Load Balancer"
  type        = string
}

variable "instance_port" {
  description = "Port on the instances to forward traffic to"
  type        = number
}

variable "instance_protocol" {
  description = "Protocol to use for routing traffic to instances"
  type        = string
}

variable "lb_port" {
  description = "Port on the load balancer to listen on"
  type        = number
}

variable "lb_protocol" {
  description = "Protocol to use for listening on the load balancer"
  type        = string
}

variable "healthy_threshold" {
  description = "Number of consecutive health checks successes required before considering the instance healthy"
  type        = number
}

variable "unhealthy_threshold" {
  description = "Number of consecutive health check failures required before considering the instance unhealthy"
  type        = number
}

variable "timeout" {
  description = "Number of seconds after which a health check is considered timed out"
  type        = number
}

variable "target" {
  description = "Target for the health check (e.g., HTTP:80/)"
  type        = string
}

variable "interval" {
  description = "Interval between health checks in seconds"
  type        = number
}

resource "aws_elb" "web-elb" {
  name = var.name

  listener {
    instance_port     = var.instance_port
    instance_protocol = var.instance_protocol
    lb_port           = var.lb_port
    lb_protocol       = var.lb_protocol
  }

  health_check {
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.timeout
    target              = var.target
    interval            = var.interval
  }
}

