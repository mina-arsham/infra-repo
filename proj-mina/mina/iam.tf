resource "aws_iam_role" "main" {
  name = "mina-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789111:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Project   = "mina"
    ManagedBy = "backstage"
  }
}
