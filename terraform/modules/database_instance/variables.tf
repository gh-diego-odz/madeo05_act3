variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
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

variable "private_ip" {
  type = string
}

variable "iam_instance_profile" {
  type = string
}