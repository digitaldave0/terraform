variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
  default     = "your-project-id"
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone for resources"
  type        = string
  default     = "us-central1-a"
}

variable "instance_type" {
  description = "Instance type for the VM instances"
  type        = string
  default     = "n1-standard-1"
}

variable "subnet_name" {
  description = "Name of the subnet for the load balancer"
  type        = string
  default     = "lb-subnet"
}
