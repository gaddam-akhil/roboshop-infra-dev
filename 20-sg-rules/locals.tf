locals {
    my_ip = "${chomp(data.http.my_public_ipv4.response_body)}/32"
}

locals {
  bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value
}

locals {
  mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id.value
}

locals {
  catalogue_sg_id = data.aws_ssm_parameter.catalogue_sg_id.value
}

locals {
  user_sg_id = data.aws_ssm_parameter.user_sg_id.value
}

locals {
  redis_sg_id = data.aws_ssm_parameter.redis_sg_id.value
}