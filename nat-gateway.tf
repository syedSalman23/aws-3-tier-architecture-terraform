resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-sub[0].id

  tags = {
    Name = "gw NAT"
  }
}
