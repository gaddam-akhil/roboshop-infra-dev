resource "aws_route53_record" "mongodb" {
  zone_id = var.zone_id
  name    = "mongodb-${var.env}.${var.domain_name}" #mongodb-dev.gaddam.online
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "redis" {
  zone_id = var.zone_id
  name    = "redis-${var.env}.${var.domain_name}" #redis-dev.gaddam.online
  type    = "A"
  ttl     = 1
  records = [aws_instance.redis.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "mysql" {
  zone_id = var.zone_id
  name    = "mysql-${var.env}.${var.domain_name}" #mysql-dev.gaddam.online
  type    = "A"
  ttl     = 1
  records = [aws_instance.mysql.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "rabbitmq" {
  zone_id = var.zone_id
  name    = "rabbitmq-${var.env}.${var.domain_name}" #rabbitmq-dev.gaddam.online
  type    = "A"
  ttl     = 1
  records = [aws_instance.rabbitmq.private_ip]
  allow_overwrite = true
}