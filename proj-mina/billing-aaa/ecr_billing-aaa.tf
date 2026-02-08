# DEBUG: Passed values
# Project: proj1
# serviceName: billing-aaa
# legalEntity: xyz Corporation
# teamName: vas
# scanOnPush: true

# ECR Repositories for vas - billing-aaa
# Generated: ${{ '' | now }}
# Description: {{ values.description }}

#########################################################################
## releases billing-aaa (prod/test environments)
#########################################################################
resource "aws_ecr_repository" "releases_billing_aaa" {
  name = "releases/billing-aaa"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = "true"
  }

  image_tag_mutability = "MUTABLE"

  tags = {
    Team        = "vas"
    Env         = "prod"
    Project     = "proj1"
    LegalEntity = "xyz Corporation"
    Terraform   = "true"
  }
}

resource "aws_ecr_repository_policy" "releases_billing_aaa_policy" {
  repository = aws_ecr_repository.releases_billing_aaa.name

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:DescribeImages",
        "ecr:DescribeRepositories",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:GetRepositoryPolicy",
        "ecr:InitiateLayerUpload",
        "ecr:ListImages",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::1234566779:root",
          "arn:aws:iam::9242912345:root",
          "arn:aws:iam::7123456799:root",
          "arn:aws:iam::4341235699:root",
          "arn:aws:iam::7712345699:root"
        ]
      },
      "Sid": "RepoPolicy-ReadWrite"
    }
  ],
  "Version": "2008-10-17"
}
POLICY
}

resource "aws_ecr_lifecycle_policy" "releases_billing_aaa_lifecycle_policy" {
  repository = aws_ecr_repository.releases_billing_aaa.name
  depends_on = [aws_ecr_repository.releases_billing_aaa]
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Image count more than 4",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 4
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}


#########################################################################
## Snapshots billing-aaa (dev/int environments)
#########################################################################
resource "aws_ecr_repository" "snapshots_billing_aaa" {
  name = "snapshots/billing-aaa"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = "true"
  }

  image_tag_mutability = "MUTABLE"

  tags = {
    Team        = "vas"
    Env         = "dev"
    Project     = "proj1"
    LegalEntity = "xyz Corporation"
    Terraform   = "true"
  }
}

resource "aws_ecr_repository_policy" "snapshots_billing_aaa_policy" {
  repository = aws_ecr_repository.snapshots_billing_aaa.name

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:DescribeImages",
        "ecr:DescribeRepositories",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:GetRepositoryPolicy",
        "ecr:InitiateLayerUpload",
        "ecr:ListImages",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::1234566779:root",
          "arn:aws:iam::9242912345:root",
          "arn:aws:iam::7123456799:root",
          "arn:aws:iam::4341235699:root",
          "arn:aws:iam::7712345699:root"
        ]
      },
      "Sid": "RepoPolicy-ReadWrite"
    }
  ],
  "Version": "2008-10-17"
}
POLICY
}

resource "aws_ecr_lifecycle_policy" "snapshots_billing_aaa_lifecycle_policy" {
  repository = aws_ecr_repository.snapshots_billing_aaa.name
  depends_on = [aws_ecr_repository.snapshots_billing_aaa]
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Image count more than 1",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
