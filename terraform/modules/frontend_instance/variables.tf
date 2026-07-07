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

variable "backend_private_ip" {
  type = string
}

variable "private_ip" {
  type = string
}

variable "iam_instance_profile" {
  type = string
}