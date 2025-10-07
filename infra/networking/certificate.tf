hcl
resource "aws_acm_certificate" "ssl_cert" {
  domain_name       = "hotelreserva.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Certificado SSL Hotel Reservas"
  }
}