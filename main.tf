resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = merge(
    var.tags,
    {
      "Name" = "${var.prefix}-vpc"
    }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "public_subnet" {
  source            = "./modules/public_subnet"
  count             = min(3, var.vpc_az_count)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  igw_id            = aws_internet_gateway.igw.id
  tags              = var.tags
  prefix            = var.prefix
}

module "private_subnet" {
  source            = "./modules/private_subnet"
  count             = min(3, var.vpc_az_count)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + min(3, var.vpc_az_count))
  nat_gw_id         = module.public_subnet[count.index].nat_gw_id
  tags              = var.tags
  prefix            = var.prefix
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-public-rtb"
    }
  )
}

resource "aws_route_table_association" "public_rtb_a" {
  count          = min(3, var.vpc_az_count)
  route_table_id = aws_route_table.public_rtb.id
  subnet_id      = module.public_subnet[count.index].id
}

resource "aws_network_acl" "public_acl" {
  vpc_id = aws_vpc.vpc.id

  subnet_ids = [for s in module.public_subnet : s.id]

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-public-acl"
    }
  )
}

resource "aws_network_acl" "private_acl" {
  vpc_id = aws_vpc.vpc.id

  subnet_ids = [for s in module.private_subnet : s.id]

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-private-acl"
    }
  )
}