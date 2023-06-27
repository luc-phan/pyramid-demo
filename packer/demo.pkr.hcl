variable "awscli_profile" {
  type    = string
  default = "default"
}

variable "ami_prefix" {
  type    = string
  default = "demo-ami"
}

variable "name_tag" {
  type    = string
  default = "demo-image"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  profile       = var.awscli_profile
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "eu-west-3"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230516"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

  ssh_username = "ubuntu"

  tags = {
    Name = var.name_tag
  }
}

build {
  name = "demo"

  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file" {
    destination = "/tmp/docker-bootstrap.sh"
    source      = "./files/docker-bootstrap.sh"
  }

  provisioner "file" {
    destination = "/tmp/demo-app.service"
    source      = "./files/demo-app.service"
  }

  provisioner "shell" {
    inline = [
      "sleep 60",
      ". /tmp/docker-bootstrap.sh",
      "git clone https://github.com/luc-phan/pyramid-demo.git",
      "cd pyramid-demo/docker",
      "cp .env.example .env",
      "sg docker 'docker-compose build'",
      "sudo mv /tmp/demo-app.service /etc/systemd/system/demo-app.service",
      "sudo systemctl enable demo-app"
    ]
  }
}
