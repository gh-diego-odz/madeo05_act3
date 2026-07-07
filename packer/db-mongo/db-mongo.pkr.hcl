packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.2.8"
    }
  }
}

source "amazon-ebs" "db_mongo" {
  ami_name                    = "db-mongo-{{timestamp}}"
  instance_type               = "t3.small"
  region                      = "mx-central-1"
  source_ami                  = "ami-013867b1fe0dec2e7"
  ssh_username                = "ubuntu"
  associate_public_ip_address = true

  tags = {
    Name = "db-mongo"
  }
}

build {
  name    = "db-mongo"
  sources = ["source.amazon-ebs.db_mongo"]

  provisioner "shell" {
    script = "setup.sh"
  }
}