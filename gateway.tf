# Create internet gateway
resource "aws_internet_gateway" "example_gw" {
  vpc_id = aws_vpc.example_vpc.id
}

# Create NAT gateway for private subnets
resource "aws_eip" "example_nat" {
  count = length(var.private_subnets)
  vpc   = true
}

resource "aws_nat_gateway" "example_nat_gw" {
  count         = length(var.private_subnets)
  allocation_id = element(aws_eip.example_nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on    = [aws_internet_gateway.example_gw]
}
 
