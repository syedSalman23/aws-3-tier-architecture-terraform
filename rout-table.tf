#create a route table for public
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-rt"
  }
}

#create a route table for private
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table" "db-rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "db-rt"
  }
}


resource "aws_route_table_association" "public" {
  count = 2

  subnet_id      = aws_subnet.public-sub[count.index].id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "private" {
  count = 2

  subnet_id      = aws_subnet.private-sub[count.index].id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "db" {
  count = 2

  subnet_id      = aws_subnet.db-sub[count.index].id
  route_table_id = aws_route_table.db-rt.id
}

#
#resource "aws_route_table" "main" {
#  count  = 2
#  vpc_id = aws_vpc.main.id
#
#  route {
#    cidr_block = "0.0.0.0/0"
#
#    gateway_id = count.index == 0 ? aws_internet_gateway.gw.id : null
#
#    nat_gateway_id = count.index == 1 ? aws_nat_gateway.nat.id : null
#  }
#
#  tags = {
#    Name = count.index == 0 ? "public-rt" : "private-rt"
#  }
#}
