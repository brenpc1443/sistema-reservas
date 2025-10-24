output "rds_endpoint" {
  description = "Endpoint de la base de datos RDS"
  value       = aws_db_instance.main.endpoint
}

output "database_url" {
  description = "URL de conexión a la base de datos (sensible)"
  value       = "postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.main.endpoint}/${var.db_name}"
  sensitive   = true
}

output "db_instance_id" {
  description = "ID de la instancia RDS"
  value       = aws_db_instance.main.id
}

output "db_address" {
  description = "Dirección del endpoint RDS (sin puerto)"
  value       = aws_db_instance.main.address
}
