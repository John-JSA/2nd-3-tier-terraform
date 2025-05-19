variable "apci_db_subnet_az2a_id" {
  type = string
  }

  variable "apci_db_subnet_az2b_id" {
  type = string
  }

  variable "tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "region" {
  type = string
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

variable "bastion_host_id" {
  type = string
}