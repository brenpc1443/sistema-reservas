
resource "aws_s3_bucket" "frontend" {
  bucket = "${var.project_name}-${var.environment}-frontend"

  tags = {
    Name        = "${var.project_name}-${var.environment}-frontend"
    Environment = var.environment
    Project     = var.project_name
  }
}

