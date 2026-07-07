output "o1_frontend_public_ip" {
  value = module.frontend_instance.public_ip
}

output "o1_backend_public_ip" {
  value = module.backend_instance.public_ip
}

output "o1_mongo_public_ip" {
  value = module.database_instance.public_ip
}

output "o2_frontend_private_ip" {
  value = module.frontend_instance.private_ip
}

output "o2_backend_private_ip" {
  value = module.backend_instance.private_ip
}

output "o2_mongo_private_ip" {
  value = module.database_instance.private_ip
}

output "o3_load_balancer_dns" {
  value = module.load_balancer.dns_name
}

output "o4_mongo_nat_gateway_public_ip" {
  value = module.network.nat_gateway_public_ip
}