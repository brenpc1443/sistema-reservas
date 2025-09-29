output "s3_bucket_name" {
  description = "Nombre del bucket S3"
  value       = aws_s3_bucket.frontend.bucket
}

output "cloudfront_url" {
  description = "URL de CloudFront"
  value       = "https://cloudfront.example.com"  # Placeholder por ahora
}