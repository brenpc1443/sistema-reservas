hcl
# ==============================
# Archivo: infra/cicd/jenkins.tf
# ==============================

provider "aws" {
  region = "us-east-1"
}

# Security Group para Jenkins
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Permite acceso HTTP/HTTPS a Jenkins"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP acceso a Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ⚠️ En producción, restringir a IPs seguras
  }

  ingress {
    description = "SSH"
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

# Instancia EC2 para Jenkins
resource "aws_instance" "jenkins_server" {
  ami                    = "ami-0c55b159cbfafe1f0" # Amazon Linux 2
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.private_1.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  key_name               = "llave-jenkins" # Reemplaza con tu keypair

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

