resource "aws_instance" "backend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  private_ip             = var.private_ip
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.iam_instance_profile

  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    cat <<ENV > /opt/app/.env
    MONGO_USER=${var.mongo_user}
    MONGO_PASSWORD=${var.mongo_password}
    MONGO_HOST=${var.mongo_host}
    MONGO_DB=${var.mongo_db}
    ENV
    chmod 600 /opt/app/.env
    chown ubuntu:ubuntu /opt/app/.env
    cd /opt/app
    sudo -u ubuntu pm2 start server.js --name backend
    sudo -u ubuntu pm2 save
  EOF

  user_data_replace_on_change  = true

  tags = {
    Name = "mean-backend"
  }
}