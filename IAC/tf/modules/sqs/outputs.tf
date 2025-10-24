output "pagos_procesados_url" {
  description = "URL de la cola SQS para pagos procesados"
  value       = aws_sqs_queue.pagos_procesados.url
}

output "pagos_procesados_arn" {
  description = "ARN de la cola SQS para pagos procesados"
  value       = aws_sqs_queue.pagos_procesados.arn
}

output "pagos_procesados_dlq_arn" {
  description = "ARN de la Dead Letter Queue para pagos"
  value       = aws_sqs_queue.pagos_procesados_dlq.arn
}

output "emails_url" {
  description = "URL de la cola SQS para emails"
  value       = aws_sqs_queue.emails.url
}

output "emails_arn" {
  description = "ARN de la cola SQS para emails"
  value       = aws_sqs_queue.emails.arn
}

output "emails_dlq_arn" {
  description = "ARN de la Dead Letter Queue para emails"
  value       = aws_sqs_queue.emails_dlq.arn
}
