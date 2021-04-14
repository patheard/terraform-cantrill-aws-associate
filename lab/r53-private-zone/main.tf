resource "aws_route53_zone" "private_zone" {
  name = var.domain_name

  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "www_primary" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 60
  records = ["1.1.1.1"]

  weighted_routing_policy {
    weight = 75
  }

  set_identifier = "one"
}

resource "aws_route53_record" "www_secondary" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 60
  records = ["2.2.2.2"]

  weighted_routing_policy {
    weight = 25
  }

  set_identifier = "two"
}
