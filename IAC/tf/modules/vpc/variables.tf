variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block de la VPC"
  type        = string
}

variable "tags" {
  description = "Tags a aplicar a los recursos"
  type        = map(string)
  default     = {}
}
