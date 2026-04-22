########################################
# VPC
########################################
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.app_name}-vpc"
  }
}

########################################
# Public Subnets (2 AZs)
########################################
resource "aws_subnet" "public" {
  count = 2

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-public-subnet-${count.index}"
  }
}

########################################
# Internet Gateway
########################################
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-igw"
  }
}

########################################
# Route Table
########################################
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-public-rt"
  }
}

########################################
# Default Route (Internet Access)
########################################
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

########################################
# Route Table Association
########################################
resource "aws_route_table_association" "public_assoc" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

########################################
# Availability Zones Data Source
########################################
data "aws_availability_zones" "available" {}