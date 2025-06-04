variable "project_id" {
  description = "Your Google Cloud project ID"
  type        = string
  default     = "jsonprettifier"
}

variable "region" {
  description = "GCP region to deploy to"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Environment name (dev, qa, prod)"
  type        = string
  default     = "dev"
}
