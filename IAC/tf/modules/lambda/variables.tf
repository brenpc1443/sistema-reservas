variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "private_subnets" {
  description = "IDs de subnets privadas para Lambda"
  type        = list(string)
}

variable "lambda_security_group_id" {
  description = "ID del security group para Lambda"
  type        = string
}

variable "sqs_queue_arn" {
  description = "ARN de la cola SQS"
  type        = string
  default     = "*"
}

variable "sns_topic_arn" {
  description = "ARN del tópico SNS"
  type        = string
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
}

variable "sns_pago_completado_arn" {
  type = string
}

variable "sns_nueva_reserva_arn" {
  description = "ARN del tópico SNS para nuevas reservas"
  type        = string
}
