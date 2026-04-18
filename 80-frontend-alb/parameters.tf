# resource "aws_ssm_parameter" "frontend_alb_listener_arn" {
#   name  = "${var.project_name}-${var.env}-frontend_alb_listener_arn"
#   type  = "String"
#   value = aws_lb_listener.frontend_alb_HTTPS.arn
# }

resource "aws_ssm_parameter" "frontend_alb_listener_arn" {
  # Change hyphens to slashes and add the leading slash
  name  = "/${var.project_name}/${var.env}/frontend_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.frontend_alb_HTTPS.arn
}
