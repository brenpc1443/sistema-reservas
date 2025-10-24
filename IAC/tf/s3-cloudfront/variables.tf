variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
}

variable "domain_name" {
  description = "Nombre de dominio para el frontend"
  type        = string
  default     = ""
}