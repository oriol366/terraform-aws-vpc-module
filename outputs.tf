output "vpc_id" {
    value = aws_vpc.vpc.id
    description = "The id of the VPC."
}

output "public_subnet_ids" {
    value = [for s in module.public_subnet : s.id]
    description = "List of IDs for the public subnets."
}

output "private_subnet_ids" {
    value = [for s in module.private_subnet : s.id]
    description = "List of IDs for the private subnets."
}

output "internet_gateway_id" {
    value = aws_internet_gateway.igw.id
    description = "The ID of the Internet Gateway"
}