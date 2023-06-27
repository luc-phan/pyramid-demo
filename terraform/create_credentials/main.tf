module "common" {
  source = "../common"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = module.common.awscli_admin_profile
  region = module.common.aws_region
}

resource "aws_iam_user" "demo_user" {
  name = module.common.aws_demo_username
}

resource "aws_iam_access_key" "demo_access_key" {
  user = aws_iam_user.demo_user.name
}

output "secret_key" {
  value     = aws_iam_access_key.demo_access_key.secret
  sensitive = true
}

output "access_key" {
  value = aws_iam_access_key.demo_access_key.id
}

resource "aws_iam_role" "demo_role" {
  name = module.common.aws_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "${aws_iam_user.demo_user.arn}"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "demo_policy" {
  name = module.common.aws_policy_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "demo_attachment" {
  name       = module.common.aws_demo_attachment_name
  policy_arn = aws_iam_policy.demo_policy.arn
  roles      = [aws_iam_role.demo_role.name]
}
