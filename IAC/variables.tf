variable "aws_region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "sistema-reservas"
  type        = string
  default     = "sistema-reserva-hotel"
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "El environment debe ser: dev, staging o prod"
  }
}

variable "vpc_cidr" {
  description = "CIDR block para la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# RDS - BD
variable "db_name" {
  description = "Base de Datos - sistema reservas"
  type        = string
  default     = "hoteldb"
}

variable "db_username" {
  description = "usuario admin"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "db_password" {
  description = "Contraseña del usuario de RDS (mínimo 8 caracteres)"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "La contraseña debe tener al menos 8 caracteres"
  }
}

variable "db_instance_class" {
  description = "instancia RDS"
  type        = string
  default     = "db.t3.micro"
}

# EC2 - SistemaBackend
variable "backend_image" {
  description = "Imagen Docker del backend monolítico"
  type        = string
  default     = "hotel-backend:latest"
}

variable "instance_type" {
  description = "instancia EC2"
  type        = string
  default     = "t3.small"
}

variable "min_instances" {
  description = "Mínimo de instancias EC2 (requerido: mínimo 2)"
  type        = number
  default     = 2

  validation {
    condition     = var.min_instances >= 2
    error_message = "Mínimo 2 instancias requeridas para alta disponibilidad"
  }
}

variable "max_instances" {
  description = "Máximo de instancias EC2 (auto-scaling)"
  type        = number
  default     = 6
}

variable "desired_instances" {
  description = "Número deseado de instancias EC2"
  type        = number
  default     = 2
}

# TAGS GLOBALES
variable "tags" {
  description = "Tags globales para todos los recursos"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Project   = "SistemaReservaHotel"
  }
}
