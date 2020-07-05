# route table for public subnet
resource "aws_route_table" "example_public_route_table" {
  vpc_id = aws_vpc.example_vpc.id
}

resource "aws_route" "example_public_route" {
  route_table_id         = aws_route_table.example_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.example_gw.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.example_public_route_table.id
}


#route table for private subnet
resource "aws_route_table" "example_private_route_table" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.example_vpc.id
}
 
resource "aws_route" "example_private_route" {
  count                  = length(compact(var.private_subnets))
  route_table_id         = element(aws_route_table.example_private_route_table.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.example_nat_gw.*.id, count.index)
}
 
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.example_private_route_table.*.id, count.index)
}

