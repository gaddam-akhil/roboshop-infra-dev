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

data "aws_ssm_parameter" "cart_sg_id" {
  name = "/${var.project_name}/${var.env}/cart_sg_id"
}

data "aws_ssm_parameter" "shipping_sg_id" {
  name = "/${var.project_name}/${var.env}/shipping_sg_id"
}

data "aws_ssm_parameter" "payment_sg_id" {
  name = "/${var.project_name}/${var.env}/payment_sg_id"
}

data "aws_ssm_parameter" "frontend_sg_id" {
  name = "/${var.project_name}/${var.env}/frontend_sg_id"
}

data "aws_ssm_parameter" "redis_sg_id" {
  name = "/${var.project_name}/${var.env}/redis_sg_id"
}

data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.project_name}/${var.env}/mysql_sg_id"
}

data "aws_ssm_parameter" "rabbitmq_sg_id" {
  name = "/${var.project_name}/${var.env}/rabbitmq_sg_id"
}

data "aws_ssm_parameter" "backend_alb_sg_id" {
  name = "/${var.project_name}/${var.env}/backend_alb_sg_id"
}

data "aws_ssm_parameter" "frontend_alb_sg_id" {
  name = "/${var.project_name}/${var.env}/frontend_alb_sg_id"
}