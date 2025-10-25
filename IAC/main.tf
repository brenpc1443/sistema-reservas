terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC Y NETWORKING
module "vpc" {
  source = "./tf/modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
}

# RDS - BASE DE DATOS
module "rds" {
  source = "./tf/modules/rds"

  vpc_id             = module.vpc.vpc_id
  private_subnets    = module.vpc.private_subnets
  rds_security_group = module.vpc.rds_security_group_id

  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  db_instance_class = var.db_instance_class

  project_name = var.project_name
  environment  = var.environment
}

# SQS - COLAS DE MENSAJES
module "sqs" {
  source = "./tf/modules/sqs"

  project_name = var.project_name
  environment  = var.environment
}

# SNS - SERVICIO DE NOTIFICACIONES
module "sns" {
  source = "./tf/modules/sns"

  project_name = var.project_name
  environment  = var.environment
}

# LAMBDA - FUNCIONES ASINCRÓNICAS
module "lambda" {
  source = "./tf/modules/lambda"

  vpc_id                   = module.vpc.vpc_id
  private_subnets          = module.vpc.private_subnets
  lambda_security_group_id = module.vpc.lambda_security_group_id

  sqs_queue_arn           = module.sqs.pagos_procesados_arn
  sns_topic_arn           = module.sns.nueva_reserva_arn
  sns_pago_completado_arn = module.sns.pago_completado_arn
  sns_nueva_reserva_arn   = module.sns.nueva_reserva_arn


  project_name = var.project_name
  environment  = var.environment
}

# EC2 - (CON ASG)
module "ec2_monolith" {
  source = "./tf/modules/ec2-monolith"

  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets

  ec2_security_group_id = module.vpc.ec2_security_group_id
  alb_security_group_id = module.vpc.alb_security_group_id

  database_url      = module.rds.database_url
  sqs_pagos_url     = module.sqs.pagos_procesados_url
  sns_nueva_reserva = module.sns.nueva_reserva_arn
  sqs_queue_arn     = module.sqs.pagos_procesados_arn

  backend_image    = var.backend_image
  instance_type    = var.instance_type
  min_size         = var.min_instances
  max_size         = var.max_instances
  desired_capacity = var.desired_instances

  project_name = var.project_name
  environment  = var.environment
}

# S3 + CLOUDFRONT - FRONTEND
module "frontend" {
  source = "./tf/modules/s3-cloudfront"

  project_name = var.project_name
  environment  = var.environment
}

# OUTPUTS
output "alb_dns_name" {
  description = "DNS del Application Load Balancer (Backend)"
  value       = module.ec2_monolith.alb_dns_name
}

output "cloudfront_url" {
  description = "URL de CloudFront (Frontend)"
  value       = module.frontend.cloudfront_url
}

output "rds_endpoint" {
  description = "Endpoint de RDS"
  value       = module.rds.rds_endpoint
}

output "sqs_pagos_procesados_url" {
  description = "URL de la cola SQS para pagos procesados"
  value       = module.sqs.pagos_procesados_url
}

output "sns_nueva_reserva_arn" {
  description = "ARN del tópico SNS para nuevas reservas"
  value       = module.sns.nueva_reserva_arn
}
