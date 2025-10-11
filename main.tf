terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# -------------------------------------------------------------
# VPC Y SUBRED
# -------------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "hotel-vpc"
  }
}

# Internet Gateway para acceso a Internet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "hotel-igw"
  }
}

# Tabla de rutas pública
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "hotel-public-rt"
  }
}

# Subred (pública)
resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true  # permite IP pública automática

  tags = {
    Name = "hotel-public-subnet-1"
  }
}

# Asociar tabla de rutas pública con la subred
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.public_rt.id
}

# -------------------------------------------------------------
# SECURITY GROUP PARA JENKINS
# -------------------------------------------------------------
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Permite acceso HTTP/HTTPS y SSH a Jenkins"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP acceso a Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ En producción, restringir IPs
  }

  ingress {
    description = "SSH acceso"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-sg"
  }
}

# -------------------------------------------------------------
# INSTANCIA EC2 PARA JENKINS
# -------------------------------------------------------------
resource "aws_instance" "jenkins_server" {
  ami                    = "ami-0c55b159cbfafe1f0" # Amazon Linux 2
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.private_1.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  key_name               = "llave-jenkins" #  reemplaza por tu key pair

  associate_public_ip_address = true # asegura IP pública visible

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install docker -y
    service docker start
    usermod -aG docker ec2-user
    docker run -d -p 8080:8080 -p 50000:50000 \
      -v jenkins_home:/var/jenkins_home \
      --name jenkins \
      jenkins/jenkins:lts
  EOF

  tags = {
    Name = "jenkins-server"
  }
}

# -------------------------------------------------------------
# OUTPUTS
# -------------------------------------------------------------
output "jenkins_public_ip" {
  description = "IP pública de la instancia Jenkins"
  value       = aws_instance.jenkins_server.public_ip
}
