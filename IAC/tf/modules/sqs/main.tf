# SQS QUEUE - PAGOS PROCESADOS
# Cuando se procesa un pago en el monolito, se envía a esta cola
# para que Lambda procese la facturación y confirmaciones de forma asincrónica
resource "aws_sqs_queue" "pagos_procesados" {
  name_prefix                = "${var.project_name}-pagos-"
  delay_seconds              = 0
  message_retention_seconds  = 1209600 # 14 días
  visibility_timeout_seconds = 300     # 5 minutos

  # Dead Letter Queue para reintentos fallidos
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.pagos_procesados_dlq.arn
    maxReceiveCount     = 3
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-pagos-procesados"
  }
}

# Dead Letter Queue para pagos fallidos
resource "aws_sqs_queue" "pagos_procesados_dlq" {
  name_prefix               = "${var.project_name}-pagos-dlq-"
  message_retention_seconds = 1209600 # 14 días

  tags = {
    Name = "${var.project_name}-${var.environment}-pagos-dlq"
  }
}

# SQS QUEUE - NOTIFICACIONES DE EMAIL
# Cola para procesar envíos de emails de forma asincrónica
resource "aws_sqs_queue" "emails" {
  name_prefix                = "${var.project_name}-emails-"
  delay_seconds              = 0
  message_retention_seconds  = 604800 # 7 días
  visibility_timeout_seconds = 60     # 1 minuto

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.emails_dlq.arn
    maxReceiveCount     = 5
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-emails"
  }
}

resource "aws_sqs_queue" "emails_dlq" {
  name_prefix               = "${var.project_name}-emails-dlq-"
  message_retention_seconds = 604800

  tags = {
    Name = "${var.project_name}-${var.environment}-emails-dlq"
  }
}
