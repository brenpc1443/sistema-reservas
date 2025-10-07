hcl
resource "aws_apigatewayv2_api" "hotel_api" {
  name          = "hotel-reservas-api"
  protocol_type = "HTTP"
  description   = "API Gateway para el sistema de reservas de habitaciones"
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.hotel_api.api_endpoint
}