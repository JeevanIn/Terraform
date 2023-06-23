resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = merge(var.tags, var.vpc_tags)
}

resource "aws_subnet" "main" {
  count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  availability_zone = var.az[count.index]
  cidr_block = var.public_subnet_cidr[count.index]
  tags = merge(var.tags, 
               { "Name" = var.public_subnet_cidr_names[count.index]})
}


resource "aws_subnet" "app" {
  count = length(var.app_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  availability_zone = var.az[count.index]
  cidr_block = var.app_subnet_cidr[count.index]
  tags = merge(var.tags, 
               { "Name" = var.app_subnet_cidr_names[count.index]})
}

resource "aws_subnet" "db" {
  count = length(var.db_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  availability_zone = var.az[count.index]
  cidr_block = var.db_subnet_cidr[count.index]
  tags = merge(var.tags,
               { "Name" = var.db_subnet_cidr_names[count.index]})
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = var.igw
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = var.public-Rt

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  
  tags = var.private-Rt

  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
}



resource "aws_eip" "nat-eip" {
  vpc      = true
  tags =  var.nat-eip
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.main[0].id
  tags = var.nat_tag
}

resource "aws_route_table_association" "web" {
  count = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.main[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "app" {
  count = length(var.app_subnet_cidr)
  subnet_id      = element(aws_subnet.app[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "db" {
  count = length(var.db_subnet_cidr)
  subnet_id      = element(aws_subnet.db[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_db_subnet_group" "database" {
  name       = lookup(var.tags, "Name")
  subnet_ids = aws_subnet.db[*].id
  tags = var.tags
  
}

