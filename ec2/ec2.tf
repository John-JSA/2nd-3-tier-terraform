# BASTION SECURITY GROUP
resource "aws_security_group" "apci_bastion_sg" {
  name        = "apci-bastion-sg"
  description = "Allow ssh traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "bastion_host_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.apci_bastion_sg.id
  cidr_ipv4         = "0.0.0.0/24"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.apci_bastion_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# BASTION HOST
resource "aws_instance" "bastion_host" {
  ami                         = var.ec2_ami
  instance_type               = var.instance_type
  subnet_id                   = var.apci_frontend_subnet_az2a_id
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.apci_bastion_sg.id]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-bastion-host"
  })
}

# PRIVATE SERVER SECURITY GROUP
resource "aws_security_group" "apci_private_server_sg" {
  name        = "apci-private-server-sg"
  description = "Allow ssh traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "apci_private_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_private_ssh" {
  security_group_id             = aws_security_group.apci_private_server_sg.id
  referenced_security_group_id = aws_security_group.apci_bastion_sg.id
  from_port                     = 22
  ip_protocol                   = "tcp"
  to_port                       = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.apci_private_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# PRIVATE SERVER AZ2A
resource "aws_instance" "apci_private_server_az2a" {
  ami                         = var.ec2_ami
  instance_type               = var.instance_type
  subnet_id                   = var.apci_backend_subnet_az2a_id
  associate_public_ip_address = false
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.apci_private_server_sg.id]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-server-az2a"
  })
}

# PRIVATE SERVER AZ2B
resource "aws_instance" "apci_private_server_az2b" {
  ami                         = var.ec2_ami
  instance_type               = var.instance_type
  subnet_id                   = var.apci_backend_subnet_az2b_id
  associate_public_ip_address = false
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.apci_private_server_sg.id]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-server-az2b"
  })
}
