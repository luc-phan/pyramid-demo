module "common" {
  source = "../common"
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
  profile = module.common.awscli_ec2_profile
  region  = module.common.aws_region
}

data "aws_ami" "demo" {
  most_recent = true

  filter {
    name   = "name"
    values = [module.common.ami_mask]
  }

  owners = [module.common.aws_account]
}

resource "aws_vpc" "demo" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Demo VPC"
  }
}

resource "aws_subnet" "demo" {
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = "10.0.0.0/16"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "demo" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name = "Demo Internet Gateway"
  }
}

resource "aws_default_route_table" "demo" {
  default_route_table_id = aws_vpc.demo.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo.id
  }
}

resource "aws_security_group" "demo" {
  name   = "demo-security-group"
  vpc_id = aws_vpc.demo.id

  dynamic "ingress" {
    for_each = module.common.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = module.common.cidrs_allowed
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "demo" {
  key_name   = "demo"
  public_key = module.common.demo_key_pair
}

resource "aws_instance" "demo" {
  ami                    = data.aws_ami.demo.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.demo.id
  vpc_security_group_ids = [aws_security_group.demo.id]
  key_name               = "demo"

  tags = {
    Name = module.common.aws_instance_name
  }
}

resource "aws_route53_zone" "demo" {
  name = module.common.domain
}

resource "aws_route53_record" "demo" {
  zone_id = aws_route53_zone.demo.zone_id
  name    = ""
  type    = "A"
  ttl     = "300"
  records = [aws_instance.demo.public_ip]
}
