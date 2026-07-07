variable "region" {
  type    = string
}

variable "availability_zone_a" {
  type = string
}

variable "availability_zone_b" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_a_cidr" {
  type = string
}

variable "public_subnet_b_cidr" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}

variable "frontend_private_ip" {
  type = string
}

variable "backend_private_ip" {
  type = string
}

variable "database_private_ip" {
  type = string
}

variable "mongo_user" {
  type = string
}

variable "mongo_password" {
  type      = string
  sensitive = true
}

variable "mongo_db" {
  type = string
}
