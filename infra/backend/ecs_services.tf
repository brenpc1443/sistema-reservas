hcl
# ECS Cluster
resource "aws_ecs_cluster" "hotel_cluster" {
  name = "hotel-reservas-cluster"
}

# Ejemplo: Servicio de reservas
resource "aws_ecs_task_definition" "reservas_task" {
  family                   = "reservas-service"
  network_mode              = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "reservas"
      image     = "123456789012.dkr.ecr.us-east-1.amazonaws.com/reservas_service:latest"
      essential = true
      portMappings = [{
        containerPort = 80
        hostPort      = 80
      }]
    }
  ])
}

resource "aws_ecs_service" "reservas_service" {
  name            = "reservas-service"
  cluster         = aws_ecs_cluster.hotel_cluster.id
  task_definition = aws_ecs_task_definition.reservas_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.private_1.id]
    assign_public_ip = false
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.reservas_tg.arn
    container_name   = "reservas"
    container_port   = 80
  }
}