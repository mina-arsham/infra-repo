# DEBUG: Passed values
# Project: new-template
# Environment: dev
# Policy Type: read_only
# Accounts: ["123456789012","987654321012"]
# Additional tag: {"Team":"cloud"}
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Generate a unique bucket name
locals {
  bucket_name = "new-template-dev-${random_string.bucket_suffix.result}"
  
  common_tags = merge(
    {
      Name        = local.bucket_name
      Environment = "dev"
      Owner       = "mina.aaa@gmail.com"
      CostCenter  = "engineering"
      ManagedBy   = "Terraform"
      Project     = "new-template"
    },
    {"Team":"cloud"}
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
    status     = "Enabled"
    mfa_delete = "Enabled"
  }
}

# Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
    bucket_key_enabled = true
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

################################
# S3 Bucket Policy (Optional)
################################

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.bucket_policy.json
  depends_on = [aws_s3_bucket_public_access_block.main]
}

data "aws_iam_policy_document" "bucket_policy" {

################################
# Read-Only (Public GetObject)
################################

  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.main.arn}/*"
    ]
  }

################################
# Cross-Account Access
################################

}
