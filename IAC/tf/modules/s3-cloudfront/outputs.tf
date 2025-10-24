output "s3_bucket_name" {
  description = "Nombre del bucket S3 para frontend"
  value       = aws_s3_bucket.frontend.id
}

output "s3_bucket_arn" {
  description = "ARN del bucket S3"
  value       = aws_s3_bucket.frontend.arn
}

output "cloudfront_domain_name" {
  description = "Nombre de dominio de CloudFront"
  value       = aws_cloudfront_distribution.frontend.domain_name
}

output "cloudfront_url" {
  description = "URL completa de CloudFront"
  value       = "https://${aws_cloudfront_distribution.frontend.domain_name}"
}

output "cloudfront_distribution_id" {
  description = "ID de la distribución CloudFront"
  value       = aws_cloudfront_distribution.frontend.id
}

output "oai_iam_arn" {
  description = "ARN del Origin Access Identity"
  value       = aws_cloudfront_origin_access_identity.oai.iam_arn
}
