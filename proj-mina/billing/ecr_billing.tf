# DEBUG: Passed values
# Project: fxb
# serviceName: billing
# legalEntity: abcd Group GmbH
# teamName: team-a
# scanOnPush: true

# ECR Repositories for team-a - billing
# Generated: ${{ '' | now }}
# Description: {{ values.description }}

#########################################################################
## releases billing (prod/test environments)
#########################################################################
resource "aws_ecr_repository" "releases_billing" {
  name = "releases/billing"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = "true"
  }

  image_tag_mutability = "IMMUTABLE"

  tags = {
    Team        = "team-a"
    Env         = "prod"
    Project     = "fxb"
    LegalEntity = "abcd Group GmbH"
    Terraform   = "true"
  }
}

resource "aws_ecr_repository_policy" "releases_billing_policy" {
  repository = aws_ecr_repository.releases_billing.name

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

resource "aws_ecr_lifecycle_policy" "releases_billing_lifecycle_policy" {
  repository = aws_ecr_repository.releases_billing.name
  depends_on = [aws_ecr_repository.releases_billing]
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Image count more than 5",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 5
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
## Snapshots billing (dev/int environments)
#########################################################################
resource "aws_ecr_repository" "snapshots_billing" {
  name = "snapshots/billing"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = "true"
  }

  image_tag_mutability = "IMMUTABLE"

  tags = {
    Team        = "team-a"
    Env         = "dev"
    Project     = "fxb"
    LegalEntity = "abcd Group GmbH"
    Terraform   = "true"
  }
}

resource "aws_ecr_repository_policy" "snapshots_billing_policy" {
  repository = aws_ecr_repository.snapshots_billing.name

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

resource "aws_ecr_lifecycle_policy" "snapshots_billing_lifecycle_policy" {
  repository = aws_ecr_repository.snapshots_billing.name
  depends_on = [aws_ecr_repository.snapshots_billing]
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Image count more than 5",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 5
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
