variable "vpc_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "apci_alb_sg_id" {
  type = string
}

variable "image_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "apci_frontend_subnet_az2a_id" {
  type = string
}

variable "apci_frontend_subnet_az2b_id" {
  type = string
}

variable "apci_target_group_arn" {
  type = string
}



