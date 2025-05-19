variable "vpc_cidr_block" {
  type = string
}

variable "frontend_cidr_block" {
  type = list(string)
}

variable "availability_zone" {
  type = list(string)
}

variable "backend_cidr_block" {
  type = list(string)
}

#variable "ssl_policy" {
# type = string
#}

#variable "certificate_arn" {
#type = string
#}

variable "image_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "region" {
 type =  string
}

variable "account_id" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "db_username" {
  type = string
}

variable "parameter_group_name" {
  type = string
}

variable "bastion_sg_id" {
  type = string
}

variable "ec2_ami" {
  type = string
}