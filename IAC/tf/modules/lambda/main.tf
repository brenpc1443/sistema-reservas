
# IAM ROLE PARA LAMBDA
resource "aws_iam_role" "lambda_role" {
  name_prefix = "${var.project_name}-lambda-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Permitir VPC execution
resource "aws_iam_role_policy" "lambda_vpc_execution" {
  name_prefix = "${var.project_name}-lambda-vpc-"
  role        = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:AssignPrivateIpAddresses",
          "ec2:UnassignPrivateIpAddresses"
        ]
        Resource = "*"
      }
    ]
  })
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Permitir SQS
resource "aws_iam_role_policy" "lambda_sqs_policy" {
  name_prefix = "${var.project_name}-lambda-sqs-"
  role        = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = var.sqs_queue_arn
      }
    ]
  })
}

# Permitir SNS
resource "aws_iam_role_policy" "lambda_sns_policy" {
  name_prefix = "${var.project_name}-lambda-sns-"
  role        = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = "*"
      }
    ]
  })
}

# Permitir SES (Simple Email Service)
resource "aws_iam_role_policy" "lambda_ses_policy" {
  name_prefix = "${var.project_name}-lambda-ses-"
  role        = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_s3_policy" {
  name_prefix = "${var.project_name}-lambda-s3-"
  role        = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ]
        Resource = "arn:aws:s3:::*/*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_logs_policy" {
  name_prefix = "${var.project_name}-lambda-logs-"
  role        = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  name_prefix = "${var.project_name}-lambda-dynamodb-"
  role        = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = "*"
      }
    ]
  })
}

# Permitir CloudWatch Logs
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# LAMBDA - EMAIL SENDER

# SNS DLQ para Lambda
resource "aws_sns_topic" "lambda_dlq" {
  name_prefix = "${var.project_name}-lambda-dlq-"
  tags = {
    Name = "${var.project_name}-lambda-dlq"
  }
}

resource "aws_lambda_function" "email_sender" {
  filename      = "${path.module}/lambda_email_sender.zip"
  function_name = "${var.project_name}-${var.environment}-email-sender"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  timeout       = 30
  memory_size   = 256

  reserved_concurrent_executions = 100

  dead_letter_config {
    target_arn = aws_sns_topic.lambda_dlq.arn
  }

  vpc_config {
    subnet_ids         = var.private_subnets
    security_group_ids = [var.lambda_security_group_id]
  }

  environment {
    variables = {
      SES_REGION = "us-east-1"
    }
  }

  # KMS para env vars
  kms_key_arn = aws_kms_key.lambda.arn

  tracing_config {
    mode = "Active" # X-Ray tracing
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-email-sender"
  }
}

# KMS para Lambda env vars
resource "aws_kms_key" "lambda" {
  description             = "KMS key for Lambda environment variables"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

# LAMBDA - INVOICE GENERATOR
resource "aws_lambda_function" "invoice_generator" {
  filename      = "${path.module}/lambda_invoice_generator.zip"
  function_name = "${var.project_name}-${var.environment}-invoice-generator"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  timeout       = 60
  memory_size   = 512

  vpc_config {
    subnet_ids         = var.private_subnets
    security_group_ids = [var.lambda_security_group_id]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-invoice-generator"
  }
}


# EVENT SOURCE MAPPING - SQS A LAMBDA
resource "aws_lambda_event_source_mapping" "sqs_to_invoice_generator" {
  event_source_arn                   = var.sqs_queue_arn
  function_name                      = aws_lambda_function.invoice_generator.function_name
  batch_size                         = 10
  maximum_batching_window_in_seconds = 5
}

resource "aws_sns_topic_subscription" "nueva_reserva_lambda" {
  topic_arn = var.sns_nueva_reserva_arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.email_sender.arn
}

resource "aws_sns_topic_subscription" "pago_completado_lambda" {
  topic_arn = var.sns_pago_completado_arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.invoice_generator.arn
}

# Lambda Permissions
resource "aws_lambda_permission" "allow_sns_email_sender" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.email_sender.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_nueva_reserva_arn
}

resource "aws_lambda_permission" "allow_sns_invoice_generator" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.invoice_generator.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_pago_completado_arn
}
