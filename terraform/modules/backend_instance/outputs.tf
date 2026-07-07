output "public_ip" {
  value = aws_instance.backend.public_ip
}

output "private_ip" {
  value = aws_instance.backend.private_ip
}

output "instance_id" {
  value = aws_instance.backend.id
}
