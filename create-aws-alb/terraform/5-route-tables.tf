resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.this.id

  route {
    gateway_id = aws_internet_gateway.this.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "public_subnet_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = aws_vpc.this.id

  route {
    nat_gateway_id = aws_nat_gateway.this.id
    cidr_block     = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "private_subnet_route_table_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_subnet_route_table.id
}
