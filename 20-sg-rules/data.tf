data "http" "my_public_ipv4" {
  url = "https://ipv4.icanhazip.com"
}

output "my_ip_address_chomped" {
  value = chomp(data.http.my_public_ipv4.response_body)
}

data "aws_ssm_parameter" "bastion_sg_id" {
  name = "/${var.project_name}/${var.env}/bastion_sg_id"
}

data "aws_ssm_parameter" "mongodb_sg_id" {
  name = "/${var.project_name}/${var.env}/mongodb_sg_id"
}

data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${var.project_name}/${var.env}/catalogue_sg_id"
}

data "aws_ssm_parameter" "user_sg_id" {
  name = "/${var.project_name}/${var.env}/user_sg_id"
}