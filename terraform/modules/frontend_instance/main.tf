resource "aws_instance" "frontend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  private_ip             = var.private_ip
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.iam_instance_profile

  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    sed -i "s/__BACKEND_PRIVATE_IP__/${var.backend_private_ip}/g" /etc/nginx/sites-available/default
    systemctl restart nginx
  EOF

  user_data_replace_on_change  = true

  tags = {
    Name = "mean-frontend"
  }
}