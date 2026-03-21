resource "aws_lb" "backend_alb" {
  name               = "${var.project_name}-${env}" #roboshop-dev
  internal           = true
  load_balancer_type = "application"
  security_groups    = [local.backend_alb_sg_id]
  subnets            = local.private_subnet_ids
  
  #keeping it as false, just to delete using terraform while practice
  enable_deletion_protection = false

  tags = merge(
     local.common_tags,
     {
        Name = "${var.project_name}-${env}-backend_alb"
     }
  )
}

resource "aws_lb_listener" "backend_alb" {
  load_balancer_arn = aaws_lb.backend_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "<h>Hi, Iam from HTTP Backend ALB</h>"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = "*.backend-alb-${var.env}.${var.domain_name}"  #*.backend-alb-dev.gaddam.online
  type    = "A"

  alias {
    name                   = aws_lb.backend_alb.dns_name
    zone_id                = aws_lb.backend_alb.zone_id
    evaluate_target_health = true
  }
}
  