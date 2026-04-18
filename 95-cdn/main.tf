resource "aws_cloudfront_distribution" "roboshop" {
  origin {
    # https://frontend-dev.gaddam.online
    domain_name              = "frontend-${var.env}.${domain_name}"
    origin_id                = "frontend-${var.env}.${domain_name}"
     
     custom_origin_config {
        http_port              = 80  // Required to be set but not used
        https_port             = 443
        origin_protocol_policy = "https-only" # Use "http-only" if no SSL on ALB
        origin_ssl_protocols   = ["TLSv1.2","TLSv1.1"]
    }
  
  }

  enabled             = true
  is_ipv6_enabled     = false

  # CDN URL https://roboshop-dev.gaddam.online
  aliases = ["${var.project_name}-${var.env}.${domain_name}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "frontend-${var.env}.${domain_name}"

    viewer_protocol_policy = "https-only"
    cache_policy_id = local.CachingDisabled
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/media/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "frontend-${var.env}.${domain_name}"

    viewer_protocol_policy = "https-only"
    cache_policy_id = local.CachingOptimized
    }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/images/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "frontend-${var.env}.${domain_name}"

    viewer_protocol_policy = "https-only"
    cache_policy_id = local.CachingOptimized
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      #locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = merge(
     local.common_tags,
     {
        Name = "${var.project_name}-${var.env}-cdn"
     }
  )

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.my_domain.arn
    ssl_support_method  = "sni-only"
  }
}

# Create Route53 records for the CloudFront distribution aliases

resource "aws_route53_record" "cloudfront" {
  zone_id  = var.zone_id
  name     = "${var.project_name}-${var.env}.${domain_name}"
  type     = "A"

# CDN details
  alias {
    name                   = aws_cloudfront_distribution.roboshop.domain_name
    zone_id                = aws_cloudfront_distribution.roboshop.hosted_zone_id
    evaluate_target_health = false
  }
 allow_overwrite = true
}