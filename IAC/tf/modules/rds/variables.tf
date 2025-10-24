variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "private_subnets" {
  description = "Lista de IDs de subnets privadas para RDS"
  type        = list(string)
}

variable "rds_security_group" {
  description = "ID del security group de RDS"
  type        = string
}

variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "hoteldb"
}

variable "db_username" {
  description = "Usuario maestro de RDS"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Contraseña del usuario maestro"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Tipo de instancia RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
}