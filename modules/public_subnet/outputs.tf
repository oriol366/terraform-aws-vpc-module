output "id" {
    value = aws_subnet.subnet.id
    description = "The id of the subnet."
}

output "nat_gw_id" {
    value = aws_nat_gateway.public.id
    description = "The id of the NAT gateway."
}