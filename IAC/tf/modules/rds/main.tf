# RDS SUBNET GROUP
resource "aws_db_subnet_group" "main" {
  name_prefix = "${lower(var.project_name)}-rds-"
  subnet_ids  = var.private_subnets

  tags = {
    Name = "${lower(var.project_name)}-${lower(var.environment)}-rds-subnet-group"
  }
}


# RDS INSTANCE (PostgreSQL - Multi-AZ)
resource "aws_db_instance" "main" {
  identifier        = "${lower(var.project_name)}-${lower(var.environment)}-db"
  engine            = "postgres"
  engine_version    = "17.6"
  instance_class    = var.db_instance_class
  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  deletion_protection                 = var.environment == "prod" ? true : false
  iam_database_authentication_enabled = true
  auto_minor_version_upgrade          = true
  copy_tags_to_snapshot               = true

  db_name  = var.db_name
  username = "postgres"
  password = var.db_password

  # Performance Insights
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  performance_insights_kms_key_id       = aws_kms_key.rds.arn

  parameter_group_name = aws_db_parameter_group.main.name

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_security_group]

  # Multi-AZ para alta disponibilidad
  multi_az = true

  # Backups automáticos
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "mon:04:00-mon:05:00"

  # Performance y logs
  enabled_cloudwatch_logs_exports = ["postgresql"]
  monitoring_interval             = 60
  monitoring_role_arn             = aws_iam_role.rds_monitoring.arn

  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.project_name}-${var.environment}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  tags = {
    Name = "${var.project_name}-${var.environment}-rds"
  }
}

resource "aws_db_parameter_group" "main" {
  name_prefix = "${lower(var.project_name)}-"
  family      = "postgres17"

  parameter {
    name  = "log_statement"
    value = "all"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "0"
  }

  tags = {
    Name = "${var.project_name}-parameter-group"
  }
}

resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS Performance Insights"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

# IAM ROLE para RDS Monitoring (CloudWatch)
resource "aws_iam_role" "rds_monitoring" {
  name_prefix = "${var.project_name}-rds-monitoring-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
