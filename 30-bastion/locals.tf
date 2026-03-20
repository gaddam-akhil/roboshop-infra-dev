locals {
  ami_id = data.aws_ami.amidevops.id
  common_tags ={
    Project = var.project
    Environment = var.environment
    Terraform = "true"
  }
  # This splits the string into a list and then selects the first element [0]
  public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_id.value)[0]
  bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value
}

