# También necesitamos corregir el main.tf para que la referencia al módulo frontend sea correcta
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

# Módulo de VPC
module "vpc" {
  source = "./modules/vpc"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
}

# Módulo de Base de Datos
module "database" {
  source = "./modules/rds"
  
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  db_name         = var.db_name
  db_username     = var.db_username
  db_password     = var.db_password
  db_instance_class = var.db_instance_class
  environment     = var.environment
  project_name    = var.project_name
}

# Módulo de ECS para Backend
module "backend" {
  source = "./modules/ecs"
  
  vpc_id           = module.vpc.vpc_id
  public_subnets   = module.vpc.public_subnets
  private_subnets  = module.vpc.private_subnets
  database_url     = module.database.database_url
  service_name     = "backend"
  container_image  = var.backend_image
  container_port   = 3000
  environment      = var.environment
  project_name     = var.project_name
  alb_security_group_id = module.vpc.alb_security_group_id
}

# Módulo de S3 para Frontend
module "frontend" {
  source = "./modules/s3-cloudfront"
  
  project_name = var.project_name
  environment  = var.environment
  domain_name  = var.domain_name
}