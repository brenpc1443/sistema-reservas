# modules/ecs/outputs.tf
output "service_url" {
  description = "URL del servicio"
  value       = "http://${aws_lb.main.dns_name}"
}

output "ecs_security_group_id" {
  description = "ID del security group de ECS"
  value       = aws_security_group.ecs.id
}

output "alb_dns_name" {
  description = "DNS name del ALB"
  value       = aws_lb.main.dns_name
}

output "ecs_cluster_name" {
  description = "Nombre del cluster ECS"
  value       = aws_ecs_cluster.main.name
}