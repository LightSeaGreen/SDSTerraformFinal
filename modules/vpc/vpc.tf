resource "aws_vpc" "nextcloud_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "Nextcloud app VPC"
  }
}

# Public subnet
resource "aws_subnet" "nextcloud_app_subnet" {
  vpc_id            = aws_vpc.nextcloud_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "Nextcloud app public subnet"
  }
}

# Private subnet
resource "aws_subnet" "nextcloud_db_to_app_subnet" {
  vpc_id            = aws_vpc.nextcloud_vpc.id
  cidr_block        = var.private_inner_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "Nextcloud db-app (inner) private subnet"
  }
}

resource "aws_subnet" "nextcloud_db_to_rt_subnet" {
  vpc_id            = aws_vpc.nextcloud_vpc.id
  cidr_block        = var.private_outer_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "Nextcloud db-rt (outer) private subnet"
  }
}

# Internet gateway
resource "aws_internet_gateway" "nextcloud_vpc_igw" {
  vpc_id = aws_vpc.nextcloud_vpc.id

  tags = {
    Name = "Nextcloud internet gateway"
  }
}

# Route table app-side
resource "aws_route_table" "nextcloud_rt" {
  vpc_id = aws_vpc.nextcloud_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nextcloud_vpc_igw.id
  }

  tags = {
    Name = "Nextcloud route table app-side"
  }
}

resource "aws_route_table_association" "nextcloud_rt_assoc" {
  subnet_id      = aws_subnet.nextcloud_app_subnet.id
  route_table_id = aws_route_table.nextcloud_rt.id
}

# Route table db-side
resource "aws_nat_gateway" "db_nat" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.nextcloud_app_subnet.id

  tags = {
    Name = "Nextcloud gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.nextcloud_vpc_igw]
}

resource "aws_route_table" "db_rt" {
  vpc_id = aws_vpc.nextcloud_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.db_nat.id
  }

  tags = {
    Name = "Nextcloud route table db-side"
  }
}

resource "aws_route_table_association" "db_rt_assoc" {
  subnet_id      = aws_subnet.nextcloud_db_to_rt_subnet.id
  route_table_id = aws_route_table.db_rt.id
}
