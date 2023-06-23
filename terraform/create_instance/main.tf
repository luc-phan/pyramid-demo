module "common" {
  source      = "../common"
}

variable "region" {
  type    = string
  default = "eu-west-3"
}

variable "instance_name" {
  type    = string
  default = "demo-instance"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  profile = module.common.aws_profile
  region = var.region
}

data "aws_ami" "demo" {
  most_recent = true

  filter {
    name   = "name"
    values = [module.common.ami_mask]
  }

  owners = [module.common.aws_account]
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.demo.id
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}
