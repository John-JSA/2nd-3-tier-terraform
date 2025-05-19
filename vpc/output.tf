output "vpc_id" {
  value = aws_vpc.apci_main_vpc.id
}

output "apci_frontend_subnet_az2a_id" {
  value = aws_subnet.apci_frontend_subnet_az2a.id
}

output "apci_frontend_subnet_az2b_id" {
  value = aws_subnet.apci_frontend_subnet_az2b.id
}

output "apci_db_subnet_az2a_id" {
  value = aws_subnet.apci_bd_subnet_az2a.id   # aws_subnet" "apci_bd_subnet_az2a
}

output "apci_db_subnet_az2b_id" {
  value = aws_subnet.apci_db_subnet_az2b.id
}

output "apci_backend_subnet_az2a_id" {
  value = aws_subnet.apci_backend_subnet_az2a.id
}

output "apci_backend_subnet_az2b_id" {
  value = aws_subnet.apci_backend_subnet_az2b.id
}


output "apci_main_vpc_id" {
  value = aws_vpc.apci_main_vpc.id
}


