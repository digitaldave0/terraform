# Load variables from separate file
variable "project_id" {}
variable "region" {}
variable "zone" {}
variable "instance_type" {}
variable "subnet_name" {}

# Configure the GCP provider
provider "google" {
  credentials = file("path/to/your/credentials.json")
  project     = var.project_id
  region      = var.region
}

# Create a network
resource "google_compute_network" "network" {
  name                    = "my-network"
  auto_create_subnetworks = false
}

# Create a subnet for the load balancer
resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  network       = google_compute_network.network.self_link
  ip_cidr_range = "10.0.0.0/24"
}

# Create an instance template
resource "google_compute_instance_template" "template" {
  name        = "nginx-template"
  machine_type = var.instance_type

  disk {
    source_image = "debian-cloud/debian-10"
  }

  network_interface {
    network = google_compute_network.network.self_link
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    service nginx start
    EOF

  metadata {
    ssh-keys = "your-ssh-key"
  }
}

# Create an instance group manager
resource "google_compute_instance_group_manager" "group_manager" {
  name             = "nginx-group-manager"
  base_instance_name = "nginx-instance"
  template         = google_compute_instance_template.template.self_link
  target_size      = 2
}

# Create a TCP health check
resource "google_compute_health_check" "health_check" {
  name                = "http-health-check"
  check_interval_sec  = 10
  timeout_sec         = 5
  tcp_health_check {
    port = 80
  }
}

# Create a backend service
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

# Create a URL map
resource "google_compute_url_map" "url_map" {
  name            = "url-map"
  default_service = google_compute_backend_service.backend_service.self_link
}

# Create a target HTTP proxy
resource "google_compute_target_http_proxy" "target_http_proxy" {
  name    = "target-http-proxy"
  url_map = google_compute_url_map.url_map.self_link
}

# Create a forwarding rule
resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name       = "forwarding-rule"
  target     = google_compute_target_http_proxy.target_http_proxy.self_link
  port_range = "80"
}
