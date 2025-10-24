output "alb_dns_name" {
  description = "DNS name del Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN del ALB"
  value       = aws_lb.main.arn
}

output "target_group_arn" {
  description = "ARN del target group"
  value       = aws_lb_target_group.monolith.arn
}

output "asg_name" {
  description = "Nombre del Auto Scaling Group"
  value       = aws_autoscaling_group.monolith.name
}

output "asg_arn" {
  description = "ARN del Auto Scaling Group"
  value       = aws_autoscaling_group.monolith.arn
}

output "launch_template_id" {
  description = "ID del Launch Template"
  value       = aws_launch_template.monolith.id
}
