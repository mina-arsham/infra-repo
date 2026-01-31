output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.main.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.main.arn
}

output "bucket_region" {
  description = "The AWS region where the bucket is created"
  value       = aws_s3_bucket.main.region
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = aws_s3_bucket.main.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The bucket region-specific domain name"
  value       = aws_s3_bucket.main.bucket_regional_domain_name
}

output "versioning_enabled" {
  description = "Whether versioning is enabled"
  value       = "true"
}

output "encryption_type" {
  description = "The type of encryption used"
  value       = "AES256"
}

output "environment" {
  description = "The deployment environment"
  value       = "dev"
}

output "project_name" {
  description = "The project name"
  value       = "aaa"
}

output "bucket_policy_type" {
  description = "The type of bucket policy applied"
  value       = "specific_accounts"
}

output "bucket_policy_applied" {
  description = "Whether a bucket policy was applied"
  value       = true
}

output "mfa_delete_enabled" {
  description = "Whether MFA delete is enabled"
  value       = "false"
}

output "tags" {
  description = "All tags applied to the bucket"
  value       = local.common_tags
}
