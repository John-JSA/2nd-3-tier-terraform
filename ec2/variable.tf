
variable "vpc_id" {
  type = string
}

variable "bastion_sg_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "ec2_ami" {
  type = string
}

variable "instance_type" {
  type = string
}


variable "apci_frontend_subnet_az2a_id" {
type = string
}

variable "key_name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "apci_backend_subnet_az2a_id" {
  type = string
}

variable "apci_backend_subnet_az2b_id" {
  type = string
}

variable "apci_main_vpc_id" {
  type = string
}
  
variable "image_id" {
  type = string
}