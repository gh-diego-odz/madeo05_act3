packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.2.8"
    }
  }
}

source "amazon-ebs" "app_frontend" {
  ami_name                    = "app-frontend-{{timestamp}}"
  instance_type               = "t3.small"
  region                      = "mx-central-1"
  source_ami                  = "ami-013867b1fe0dec2e7"
  ssh_username                = "ubuntu"
  associate_public_ip_address = true

  tags = {
    Name = "app-frontend"
  }
}

build {
  name    = "app-frontend"
  sources = ["source.amazon-ebs.app_frontend"]

  provisioner "file" {
    source      = "../../app-frontend/dist/browser"
    destination = "/tmp/app-dist"
  }

  provisioner "file" {
    source      = "nginx.conf"
    destination = "/tmp/nginx.conf"
  }

  provisioner "shell" {
    script = "setup.sh"
  }
}