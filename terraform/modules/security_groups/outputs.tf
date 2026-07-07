output "lb_sg_id" {
  value = aws_security_group.lb.id
}

output "frontend_sg_id" {
  value = aws_security_group.frontend.id
}

output "backend_sg_id" {
  value = aws_security_group.backend.id
}

output "mongo_sg_id" {
  value = aws_security_group.mongo.id
}
