resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, 0)

  availability_zone = "us-east-2a"

  map_public_ip_on_launch = true
}

// Created only for ALB (since it requires 2 public subnets)
resource "aws_subnet" "extra_public_subnet" {
  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, 2)

  availability_zone = "us-east-2b"

  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, 1)

  availability_zone = "us-east-2b"

  depends_on = [
    aws_nat_gateway.this
  ]
}
