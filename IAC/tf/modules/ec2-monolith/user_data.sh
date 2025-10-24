#!/bin/bash
set -e

# ============================================================
# ACTUALIZAR SISTEMA
# ============================================================
yum update -y
yum install -y curl wget git

# ============================================================
# INSTALAR DOCKER
# ============================================================
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# ============================================================
# INSTALAR DOCKER COMPOSE
# ============================================================
curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# ============================================================
# INSTALAR CLOUDWATCH AGENT
# ============================================================
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U ./amazon-cloudwatch-agent.rpm

# ============================================================
# CREAR DIRECTORIO DE LA APLICACIÓN
# ============================================================
mkdir -p /app
cd /app

# ============================================================
# CREAR ARCHIVO .env PARA EL BACKEND
# ============================================================
cat > .env << EOF
NODE_ENV=production
DATABASE_URL="${database_url}"
SQS_PAGOS_URL="${sqs_pagos_url}"
SNS_NUEVA_RESERVA_ARN="${sns_nueva_reserva}"
PORT=3000
EOF

# ============================================================
# CREAR DOCKER COMPOSE PARA EL BACKEND
# ============================================================
cat > docker-compose.yml << 'COMPOSE'
version: '3.9'

services:
  backend:
    image: ${backend_image}
    container_name: hotel-backend
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=${DATABASE_URL}
      - SQS_PAGOS_URL=${SQS_PAGOS_URL}
      - SNS_NUEVA_RESERVA_ARN=${SNS_NUEVA_RESERVA_ARN}
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    logging:
      driver: awslogs
      options:
        awslogs-group: /aws/ec2/backend
        awslogs-region: us-east-1
        awslogs-stream-prefix: ecs

COMPOSE

# ============================================================
# CREAR CLOUDWATCH LOG GROUP
# ============================================================
aws logs create-log-group --log-group-name /aws/ec2/backend 2>/dev/null || true

# ============================================================
# INICIAR APLICACIÓN
# ============================================================
cd /app
export $(cat .env | xargs)
docker-compose up -d

# ============================================================
# LOGS
# ============================================================
echo "Backend iniciado correctamente" > /var/log/backend-startup.log
date >> /var/log/backend-startup.log