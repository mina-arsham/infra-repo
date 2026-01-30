terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Generate a unique bucket name
locals {
  bucket_name = "proj2-dev-${random_string.bucket_suffix.result}"
  
  common_tags = {
    Name        = local.bucket_name
    Environment = "dev"
    Owner       = "mina.aaa@gmail.com"
    CostCenter  = "engineering"
    ManagedBy   = "Terraform"
    Project     = "proj2"
    CreatedAt   = timestamp()
  }
}

# Random suffix to ensure globally unique bucket name
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# S3 Bucket
resource "aws_s3_bucket" "main" {
  bucket = local.bucket_name
  
  tags = local.common_tags
}

# Versioning
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  
  versioning_configuration {
    status     = "true" == "true" ? "Enabled" : "Disabled"
    mfa_delete = "" == "true" && "true" == "true" ? "Enabled" : "Disabled"
  }
}

# Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" == "AES256" ? "AES256" : "aws:kms"
    }
    bucket_key_enabled = "AES256" != "AES256"
  }
}

# Block Public Access
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = "true"
  block_public_policy     = "true"
  ignore_public_acls      = "true"
  restrict_public_buckets = "true"
}

# Bucket Policy
# resource "aws_s3_bucket_policy" "main" {
#   bucket = aws_s3_bucket.main.id

#
#   policy = data.aws_iam_policy_document.bucket_policy.json
#
  
#   depends_on = [aws_s3_bucket_public_access_block.main]
# }

#

# # Data source for generating bucket policies based on type
# data "aws_iam_policy_document" "bucket_policy" {

#

#

  # Require SSL/TLS (Deny non-HTTPS) - Applied to all policy types except custom
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"
    principals {
      type        = "{{ '*' }}"
      identifiers = ["{{ '*' }}"]
    }
    actions = [
      "{{ 's3:*' }}"
    ]
    resources = [
      aws_s3_bucket.main.arn,
      "${aws_s3_bucket.main.arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
