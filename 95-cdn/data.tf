data "aws_cloudfront_cache_policy" "CachingDisabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_cache_policy" "CachingOptimized" {
  name = "Managed-CachingOptimized"
}

 data "aws_ssm_parameter" "acm_certificate_arn" {
  name  = "/${var.project_name}/${var.env}/frontend_alb_certificate_arn"
}