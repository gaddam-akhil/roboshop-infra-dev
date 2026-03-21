locals {
  ami_id = data.aws_ami.amidevops.id
  common_tags = {
    Project = var.project_name
    Environment = var.env
    Terraform = "true"
  }

  #database subnet of 1a AZ
    database_subnet_id = split(",",data.aws_ssm_parameter.database_subnet_ids.value)[0]
    mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_ids.value
    redis_sg_id = data.aws_ssm_parameter.redis_sg_ids.value
    mysql_sg_id = data.aws_ssm_parameter.mysql_sg_ids.value
    mysql_name_iam = join("-",  [for name in [var.project_name, var.env, "mysql"] : title(name)])
    mysql_name_policy = join("-",  [for name in [var.project_name, var.env, "mysql"] : title(name)])
    rabbitmq_sg_id = data.aws_ssm_parameter.rabbitmq_sg_ids.value
}


