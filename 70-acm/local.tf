locals {
  common_tags = {
    Project = var.project_name
    Environment = var.env
    Terraform = "true"
    Description = "tags for acm"
  }
}
