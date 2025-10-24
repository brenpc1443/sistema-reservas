# 7. Corregir variables del módulo RDS
variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "private_subnets" {
  description = "Lista de IDs de subnets privadas"
  type        = list(string)
}

variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
}

variable "db_username" {
  description = "Usuario de la base de datos"
  type        = string
}

variable "db_password" {
  description = "Contraseña de la base de datos"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Clase de instancia de RDS"
  type        = string
  default     = "db.t3.micro"
}