output "vpc_id" {
  description = "ID de la VPC"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "IDs de subnets públicas"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "IDs de subnets privadas"
  value       = aws_subnet.private[*].id
}

output "alb_security_group_id" {
  description = "ID del security group del ALB"
  value       = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  description = "ID del security group de EC2"
  value       = aws_security_group.ec2.id
}

output "rds_security_group_id" {
  description = "ID del security group de RDS"
  value       = aws_security_group.rds.id
}

output "lambda_security_group_id" {
  description = "ID del security group de Lambda"
  value       = aws_security_group.lambda.id
}

output "nat_gateway_ids" {
  description = "IDs de los NAT Gateways"
  value       = aws_nat_gateway.nat[*].id
}