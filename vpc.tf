# Create a VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = var.cidr_block
}
