# DEBUG: Passed values
# Project: fxb
# serviceName: service1-m-n
# legalEntity: abcd Group GmbH
# teamName: te
# scanOnPush: true

# ECR Repositories for te - service1-m-n
# Generated: ${{ '' | now }}
# Description: {{ values.description }}

#########################################################################
## releases service1-m-n (prod/test environments)
#########################################################################
resource "aws_ecr_repository" "releases_service1_m_n" {
  name = "releases/{{ values.serviceName }}"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = "true"
  }

  image_tag_mutability = "{{ values.defaultMutability | default('IMMUTABLE') }}"

  tags = {
    Team        = "te"
    Env         = "prod"
    Project     = "fxb"
    LegalEntity = "abcd Group GmbH"
    Terraform   = "true"
  }
}

resource "aws_ecr_repository_policy" "releases_service1_m_n_policy" {
  repository = aws_ecr_repository.releases_service1_m_n.name

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

resource "aws_ecr_lifecycle_policy" "releases_service1_m_n_lifecycle_policy" {
  repository = aws_ecr_repository.releases_service1_m_n.name
  depends_on = [aws_ecr_repository.releases_service1_m_n]
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
## Snapshots service1-m-n (dev/int environments)
#########################################################################
resource "aws_ecr_repository" "snapshots_service1_m_n" {
  name = "snapshots/service1-m-n"

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = "true"
  }

  image_tag_mutability = "IMMUTABLE"

  tags = {
    Team        = "{{ values.teamName }}"
    Env         = "dev"
    Project     = "fxb"
    LegalEntity = "abcd Group GmbH"
    Terraform   = "true"
  }
}

resource "aws_ecr_repository_policy" "snapshots_service1_m_n_policy" {
  repository = aws_ecr_repository.snapshots_service1_m_n.name

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

resource "aws_ecr_lifecycle_policy" "snapshots_service1_m_n_lifecycle_policy" {
  repository = aws_ecr_repository.snapshots_service1_m_n.name
  depends_on = [aws_ecr_repository.snapshots_service1_m_n]
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
