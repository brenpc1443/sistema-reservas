hcl
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "hotel-reservas-frontend"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = {
    Name = "Frontend React - Sistema de Reservas"
    Environment = "production"
  }
}

# Bloqueo de versiones y acceso público
resource "aws_s3_bucket_public_access_block" "frontend_block" {
  bucket = aws_s3_bucket.frontend_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

output "s3_frontend_url" {
  value = aws_s3_bucket.frontend_bucket.website_endpoint
}