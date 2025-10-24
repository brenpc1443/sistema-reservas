output "nueva_reserva_arn" {
  description = "ARN del tópico SNS para nuevas reservas"
  value       = aws_sns_topic.nueva_reserva.arn
}

output "nueva_reserva_name" {
  description = "Nombre del tópico SNS para nuevas reservas"
  value       = aws_sns_topic.nueva_reserva.name
}

output "reserva_cancelada_arn" {
  description = "ARN del tópico SNS para reservas canceladas"
  value       = aws_sns_topic.reserva_cancelada.arn
}

output "pago_completado_arn" {
  description = "ARN del tópico SNS para pagos completados"
  value       = aws_sns_topic.pago_completado.arn
}
