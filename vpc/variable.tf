variable "vpc_cidr_block" {
  type = string
}

variable "tags" {
  type = map(string)
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

variable "apci_frontend_subnet_az2a_id" {
  type = string
}
  
variable "apci_frontend_subnet_az2b_id" {
  type = string
}


variable "apci_db_subnet_az2a_id" {
  type = string
  }

variable "apci_db_subnet_az2b_id" {
  type = string
  }

variable "apci_backend_subnet_az2a_id" {
  type = string
}
