locals {
  ami_id = data.aws_ami.amidevops.id
  common_tags = {
    Project = var.project_name
    Environment = var.env
    Terraform = "true"
    database_subnet_id = data.aws_ssm_parameter.database_subnet_ids.value
    mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_ids.value
  }
}


