terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

variable "region" {
  type    = string
  default = "eu-west-3"
}

variable "user_name" {
  type    = string
  default = "demo-user"
}

variable "role_name" {
  type    = string
  default = "demo-role"
}

variable "policy_name" {
  type    = string
  default = "demo-policy"
}

variable "attachment_name" {
  type    = string
  default = "demo-attachment"
}

provider "aws" {
  region = var.region
}

resource "aws_iam_user" "demo_user" {
  name = var.user_name
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
  name = var.role_name

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
  name = var.policy_name

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
  name       = var.attachment_name
  policy_arn = aws_iam_policy.demo_policy.arn
  roles      = [aws_iam_role.demo_role.name]
}
