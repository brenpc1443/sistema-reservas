hcl
resource "aws_route53_zone" "main_zone" {
  name = "hotelreserva.com"
}

resource "aws_route53_record" "frontend_record" {
  zone_id = aws_route53_zone.main_zone.zone_id
  name    = "www.hotelreserva.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.frontend_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.frontend_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

output "domain_name" {
  value = "https://www.hotelreserva.com"
}