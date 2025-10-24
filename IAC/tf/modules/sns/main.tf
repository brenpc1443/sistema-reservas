# SNS TOPIC - NUEVA RESERVA
# Cuando se crea una nueva reserva, se publica un evento aquí
# Múltiples servicios pueden suscribirse (emails, SMS, analíticas)
resource "aws_sns_topic" "nueva_reserva" {
  name_prefix                 = "${var.project_name}-nueva-reserva-"
  display_name                = "Nueva Reserva del Hotel"
  fifo_topic                  = false
  content_based_deduplication = false

  tags = {
    Name = "${var.project_name}-${var.environment}-nueva-reserva"
  }
}

# SNS TOPIC - RESERVA CANCELADA
resource "aws_sns_topic" "reserva_cancelada" {
  name_prefix  = "${var.project_name}-reserva-cancelada-"
  display_name = "Reserva Cancelada"

  tags = {
    Name = "${var.project_name}-${var.environment}-reserva-cancelada"
  }
}

# SNS TOPIC - PAGO COMPLETADO
resource "aws_sns_topic" "pago_completado" {
  name_prefix  = "${var.project_name}-pago-completado-"
  display_name = "Pago Completado"

  tags = {
    Name = "${var.project_name}-${var.environment}-pago-completado"
  }
}

# SNS SUBSCRIPTIONS PARA LAMBDA
# Lambda se suscribe a estos tópicos para procesar eventos

resource "aws_sns_topic_subscription" "nueva_reserva_lambda" {
  topic_arn = aws_sns_topic.nueva_reserva.arn
  protocol  = "lambda"
  endpoint  = var.lambda_email_sender_arn
}

resource "aws_sns_topic_subscription" "pago_completado_lambda" {
  topic_arn = aws_sns_topic.pago_completado.arn
  protocol  = "lambda"
  endpoint  = var.lambda_invoice_generator_arn
}

# SNS TOPIC POLICY (Permitir EC2 publicar)
resource "aws_sns_topic_policy" "nueva_reserva_policy" {
  arn = aws_sns_topic.nueva_reserva.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.nueva_reserva.arn
      }
    ]
  })
}
