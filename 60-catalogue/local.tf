locals {
  ami_id = data.aws_ami.amidevops.id
  private_subnet_id = split(",",data.aws_ssm_parameter.private_subnet_ids.value)[0]
  catalogue_sg_id = data.aws_ssm_parameter.catalogue_sg_id.value
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = {
    Project = var.project_name
    Environment = var.env
    Terraform = "true"
    Description = "tags for catalogue instance"
  }
}
