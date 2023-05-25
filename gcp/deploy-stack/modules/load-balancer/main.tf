variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "GCP region for resources"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet for the load balancer"
  type        = string
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = "10.0.0.0/24"
}

resource "google_compute_health_check" "health_check" {
  name               = "http-health-check"
  check_interval_sec = 10
  timeout_sec        = 5
  tcp_health_check {
    port = 80
  }
}

resource "google_compute_instance_group_manager" "group_manager" {
  name             = "vm-instance-group-manager"
  base_instance_name = "vm-instance"
  template         = google_compute_instance_template.template.self_link
  target_size      = 2
}

resource "google_compute_backend_service" "backend_service" {
  name                  = "backend-service"
  protocol              = "HTTP"
  health_checks         = [google_compute_health_check.health_check.self_link]
  timeout_sec           = 10
  port_name             = "http"
  backends {
    group = google_compute_instance_group_manager.group_manager.self_link
  }
}

resource "google_compute_url_map" "url_map" {
  name            = "url-map"
  default_service = google_compute_backend_service.backend_service.self_link
}

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name       = "forwarding-rule"
  target     = google_compute_url_map.url_map.self_link
  port_range = "80"
}
