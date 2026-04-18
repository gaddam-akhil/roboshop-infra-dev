locals {
 CachingDisabled = data.aws_cloudfront_cache_policy.CachingDisabled.id
 CachingOptimized = data.aws_cloudfront_cache_policy" "CachingOptimized.id
 acm_certificate_arn = aws_ssm_parameter" "acm_certificate_arn.value
  common_tags = {
    Project = var.project_name
    Environment = var.env
    Terraform = "true"
  }
}
