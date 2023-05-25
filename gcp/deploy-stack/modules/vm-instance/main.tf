variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "GCP region for resources"
  type        = string
}

variable "zone" {
  description = "GCP zone for resources"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the VM instances"
  type        = string
}

resource "google_compute_instance_template" "template" {
  name        = "vm-instance-template"
  machine_type = var.instance_type

  # Adjust disk/image configurations as needed
  disk {
    source_image = "debian-cloud/debian-10"
  }

  network_interface {
    network = "default"
  }

  # Modify metadata and startup script as required
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
