output "public_ip" {
  value = aws_instance.frontend.public_ip
}

output "private_ip" {
  value = aws_instance.frontend.private_ip
}

output "instance_id" {
  value = aws_instance.frontend.id
}
