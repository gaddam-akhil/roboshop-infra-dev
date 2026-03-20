data "aws_ami" "amidevops" {
  most_recent      = true
  owners           = ["973714476881"]

  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ssm_parameter" "database_subnet_ids" {
  name = "/${var.project_name}/${var.env}/database_subnet_id"
}

data "aws_ssm_parameter" "mongodb_sg_ids" {
  name = "/${var.project_name}/${var.env}/mongodb_sg_id"
}

data "aws_ssm_parameter" "redis_sg_ids" {
  name = "/${var.project_name}/${var.env}/redis_sg_id"
}