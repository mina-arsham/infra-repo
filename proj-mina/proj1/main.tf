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
  region = "eu-west-1"
}

# Generate a unique bucket name
# DEBUG: what Backstage is passing to Terraform
# {"team":"cloud","bsg":"true"}
locals {
  bucket_name = "proj1-dev-${random_string.bucket_suffix.result}"
  
  common_tags = merge(
    {
      Name        = local.bucket_name
      Environment = "dev"
      Owner       = "mina.aaa@gmail.com"
      CostCenter  = "engineering"
      ManagedBy   = "Terraform"
      Project     = "proj1"
    },
    {"team":"cloud","bsg":"true"}

  )
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
    status     = Enabled
    mfa_delete = Disabled
  }
}

# Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = false
  }
}

# Block Public Access
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
