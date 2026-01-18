resource "aws_vpc" "project_vpc" {
  cidr_block = var.cidr_block_vpc

  tags = {
    name = "project-vpc"
  }
}

resource "aws_subnet" "pub_sb_1" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.cidr_block_pub_sb_1
  availability_zone = var.pub_sub_1_az

  tags = {
    name = "public-sb-1"
  }
}

resource "aws_subnet" "pub_sb_2" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.cidr_block_pub_sb_2
  availability_zone = var.pub_sub_2_az

  tags = {
    name = "public-sb-2"
  }
}

resource "aws_subnet" "priv_sb_1" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.cidr_block_pri_sb_1
  availability_zone = var.priv_sub_1_az

  tags = {
    name = "private-sb-1"
  }
}

resource "aws_subnet" "priv_sb_2" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.cidr_block_pri_sb_2
  availability_zone = var.priv_sub_2_az

  tags = {
    name = "private-sb-2"
  }
}

resource "aws_internet_gateway" "project_igw" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    name = "igw"
  }
}

resource "aws_eip" "project_eip" {
  tags = {
    name = "eip"
  }
}

resource "aws_nat_gateway" "project_nat" {
  availability_mode = "regional"
  vpc_id            = aws_vpc.project_vpc.id
  tags = {
    name = "nat"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.project_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.project_nat.id
  }
  tags = {
    name = "private-rt"
  }
}

resource "aws_route_table_association" "private_rt_assoc_1" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.priv_sb_1.id
}

resource "aws_route_table_association" "private_rt_assoc_2" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.priv_sb_2.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.project_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project_igw.id
  }
  tags = {
    name = "public-rt"
  }
}

resource "aws_route_table_association" "public_rt_assoc_1" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.pub_sb_1.id
}

resource "aws_route_table_association" "public_rt_assoc_2" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.pub_sb_2.id
}