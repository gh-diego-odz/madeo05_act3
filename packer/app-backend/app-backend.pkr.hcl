packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.2.8"
    }
  }
}

source "amazon-ebs" "app_backend" {
  ami_name                    = "app-backend-{{timestamp}}"
  instance_type               = "t3.small"
  region                      = "mx-central-1"
  source_ami                  = "ami-013867b1fe0dec2e7"
  ssh_username                = "ubuntu"
  associate_public_ip_address = true

  tags = {
    Name = "app-backend"
  }
}

build {
  name    = "app-backend"
  sources = ["source.amazon-ebs.app_backend"]

  provisioner "file" {
    source      = "../../app-backend/dist"
    destination = "/tmp/app-backend"
  }

  provisioner "file" {
    source      = "../../app-backend/package.json"
    destination = "/tmp/app-backend/package.json"
  }

  provisioner "file" {
    source      = "../../app-backend/package-lock.json"
    destination = "/tmp/app-backend/package-lock.json"
  }

  provisioner "shell" {
    script = "setup.sh"
  }
}
