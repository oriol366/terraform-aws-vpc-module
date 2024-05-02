resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc_id
  availability_zone       = var.availability_zone
  cidr_block              = var.cidr_block
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-subnet-public-${var.availability_zone}"
    }
  )
}

resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [var.igw_id]

  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "public" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet.id

  tags = {
    Name = "nat-gateway"
  }
}