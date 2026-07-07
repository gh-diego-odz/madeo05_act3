resource "aws_instance" "mongo" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  private_ip             = var.private_ip
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.iam_instance_profile

  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    systemctl restart mongod
    sleep 5

    mongosh <<MONGOSHELL
    use ${var.mongo_db}
    db.createUser({
      user: "${var.mongo_user}",
      pwd: "${var.mongo_password}",
      roles: [{ role: "readWrite", db: "${var.mongo_db}" }]
    })
    MONGOSHELL

    sed -i "s/#security:/security:\n  authorization: enabled/" /etc/mongod.conf
    systemctl restart mongod
  EOF

  user_data_replace_on_change  = true

  tags = {
    Name = "mean-mongo"
  }
}