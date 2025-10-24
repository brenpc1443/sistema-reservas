output "email_sender_arn" {
  description = "ARN de la función Lambda para envío de emails"
  value       = aws_lambda_function.email_sender.arn
}

output "email_sender_name" {
  description = "Nombre de la función Lambda para envío de emails"
  value       = aws_lambda_function.email_sender.function_name
}

output "invoice_generator_arn" {
  description = "ARN de la función Lambda para generación de facturas"
  value       = aws_lambda_function.invoice_generator.arn
}

output "invoice_generator_name" {
  description = "Nombre de la función Lambda para generación de facturas"
  value       = aws_lambda_function.invoice_generator.function_name
}
