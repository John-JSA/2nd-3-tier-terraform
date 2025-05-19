resource "aws_vpc" "apci_main_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-vpc"
  })
}

#internet gateway ---------------------------------------------------------------
resource "aws_internet_gateway" "apci-igw" {
  vpc_id = aws_vpc.apci_main_vpc.id

 tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-igw"
  })
}

#frontend-subnets -----------------------------------------------
resource "aws_subnet" "apci_frontend_subnet_az2a" {
  vpc_id     = aws_vpc.apci_main_vpc.id
  cidr_block = var.frontend_cidr_block[0]
  availability_zone = var.availability_zone[0]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-frontend-subnet-az2a"
  })
}

resource "aws_subnet" "apci_frontend_subnet_az2b" {
  vpc_id     = aws_vpc.apci_main_vpc.id
  cidr_block = var.frontend_cidr_block[1]
  availability_zone = var.availability_zone[1]

   tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-frontend-subnet-az2b"
  })
}

# PRIVATE SUBNET---------------------------------------

resource "aws_subnet" "apci_backend_subnet_az2a" {
  vpc_id     = aws_vpc.apci_main_vpc.id
  cidr_block = var.backend_cidr_block[0]
  availability_zone = var.availability_zone[0]

 tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-backend-subnet-az2a"
  })
}


resource "aws_subnet" "apci_backend_subnet_az2b" {
  vpc_id     = aws_vpc.apci_main_vpc.id
  cidr_block = var.backend_cidr_block[1]
  availability_zone = var.availability_zone[1]

   tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-backend-subnet-az2b"
  })
}

# CREATING PUBLIC ROUTE TABLE--------------------------------------------- 
resource "aws_route_table" "apci_public_rt" {
  vpc_id = aws_vpc.apci_main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.apci-igw.id
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-rt"
  })
}

# CREATING PUBLIC ROUTE TABLE SUBNET ASSOCIATION ----------------------------------------
#1
resource "aws_route_table_association" "apci_public_subnet_az2a" {
  subnet_id      = aws_subnet.apci_frontend_subnet_az2a.id
  route_table_id = aws_route_table.apci_public_rt.id
}

#2

resource "aws_route_table_association" "apci_public_subnet_az2b" {
  subnet_id      = aws_subnet.apci_frontend_subnet_az2b.id
  route_table_id = aws_route_table.apci_public_rt.id
}



# CREATING ELISTIC IP ADDRESS FOR NAT GATEWAY IN AZ2a ----------------------------------------
resource "aws_eip" "apci_eip_az2a" {
  domain   = "vpc"


   tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-eip-az2a"
  })
}

# CREATING A NAT GATEWAY ############################################################
resource "aws_nat_gateway" "apci_nat_gateway_az2a" {
  allocation_id = aws_eip.apci_eip_az2a.id
  subnet_id     = aws_subnet.apci_backend_subnet_az2a.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-gw-az2a"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.apci_eip_az2a, aws_subnet.apci_backend_subnet_az2a]
}
# PRIVATE ROUTE TABLE az2a ####################################################################
resource "aws_route_table" "apci_private_rt_az2a" {
  vpc_id = aws_vpc.apci_main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.apci_nat_gateway_az2a.id
  }

   tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-rt-az2a"
  })
}

#PRIVATE SUBNET ASSOCIATION az2a ##################################################
resource "aws_route_table_association" "apci_private-subnet_association_az2a" {
  subnet_id      = aws_subnet.apci_backend_subnet_az2a.id
  route_table_id = aws_route_table.apci_private_rt_az2a.id
}

# CREATING ELISTIC IP ADDRESS FOR NAT GATEWAY IN AZ2b ----------------------------------------
resource "aws_eip" "apci_eip_az2b" {
  domain   = "vpc"


   tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-eip-az2b"
  })
}

# CREATING A NAT GATEWAY ############################################################
resource "aws_nat_gateway" "apci_nat_gateway_az2b" {
  allocation_id = aws_eip.apci_eip_az2b.id
  subnet_id     = aws_subnet.apci_backend_subnet_az2b.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-gw-az2b"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.apci_eip_az2b, aws_subnet.apci_backend_subnet_az2b]
}

# PRIVATE ROUTE TABLE az2b ####################################################################
resource "aws_route_table" "apci_private_rt_az2b"{
  vpc_id = aws_vpc.apci_main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.apci_nat_gateway_az2b.id
  }

   tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-rt-az2b"
  })
}

#PRIVATE SUBNET ASSOCIATION az2b ##################################################
resource "aws_route_table_association" "apci_private-subnet_association_az2b" {
  subnet_id      = aws_subnet.apci_backend_subnet_az2b.id
  route_table_id = aws_route_table.apci_private_rt_az2b.id
}


#DATABASE SUBNET #################################################################
resource "aws_subnet" "apci_bd_subnet_az2a" {
  vpc_id     = aws_vpc.apci_main_vpc.id
  cidr_block = var.backend_cidr_block[2]
  availability_zone = var.availability_zone[0]

 tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-subnet-az2a"
  })
}


resource "aws_subnet" "apci_db_subnet_az2b" {
  vpc_id     = aws_vpc.apci_main_vpc.id
  cidr_block = var.backend_cidr_block[3]
  availability_zone = var.availability_zone[1]

 tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-subnet-az2b"
  })
}