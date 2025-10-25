variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "public_subnets" {
  description = "IDs de subnets públicas para el ALB"
  type        = list(string)
}

variable "sqs_queue_arn" {
  description = "ARN de la cola SQS para pagos"
  type        = string
}

variable "private_subnets" {
  description = "IDs de subnets privadas para EC2"
  type        = list(string)
}

variable "ec2_security_group_id" {
  description = "ID del security group para EC2"
  type        = string
}

variable "alb_security_group_id" {
  description = "ID del security group para ALB"
  type        = string
}

variable "database_url" {
  description = "URL de conexión a la base de datos"
  type        = string
  sensitive   = true
}

variable "sqs_pagos_url" {
  description = "URL de la cola SQS para pagos"
  type        = string
}

variable "sns_nueva_reserva" {
  description = "ARN del tópico SNS para nuevas reservas"
  type        = string
}

variable "backend_image" {
  description = "Imagen Docker del backend"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t3.small"
}

variable "min_size" {
  description = "Mínimo de instancias en ASG"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Máximo de instancias en ASG"
  type        = number
  default     = 6
}

variable "desired_capacity" {
  description = "Número deseado de instancias"
  type        = number
  default     = 2
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
}
