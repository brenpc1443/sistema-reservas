# 8. Corregir outputs del módulo RDS
output "rds_endpoint" {
  description = "Endpoint de RDS"
  value       = aws_db_instance.main.endpoint
}

output "database_url" {
  description = "URL de conexión a la base de datos"
  value       = "postgresql://${var.db_username}:${var.db_password}@${aws_db_instance.main.endpoint}/${var.db_name}"
  sensitive   = true
}

output "rds_security_group_id" {
  description = "ID del security group de RDS"
  value       = aws_security_group.rds.id
}