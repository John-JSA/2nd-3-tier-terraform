variable "vpc_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "apci_frontend_subnet_az2a_id" {
  type = string
}

variable "apci_frontend_subnet_az2b_id" {
  type = string
}



#variable "ssl_policy" {
  #type = string
#}

#variable "certificate_arn" {
 # type = string
#}