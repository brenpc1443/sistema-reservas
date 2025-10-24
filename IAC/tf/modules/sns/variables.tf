variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
}

variable "lambda_email_sender_arn" {
  description = "ARN de la función Lambda que envía emails"
  type        = string
  default     = ""
}

variable "lambda_invoice_generator_arn" {
  description = "ARN de la función Lambda que genera facturas"
  type        = string
  default     = ""
}
