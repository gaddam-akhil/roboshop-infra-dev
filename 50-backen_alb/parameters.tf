# resource "aws_ssm_parameter" "catalogue" {
#   name  = "${var.project_name}-${var.env}-backend_alb_listener_arn"
#   type  = "String"
#   value = aws_lb_listener.backend_alb.arn
# }

resource "aws_ssm_parameter" "backend_alb_listener_arn" {
  name  = "/${var.project_name}/${var.env}/backend_alb_listener_arn"
  type  = "String"
  # Use .backend_alb here to match the listener resource you just showed me
  value = aws_lb_listener.backend_alb.arn 
}