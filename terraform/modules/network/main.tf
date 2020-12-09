resource "aws_vpc" "hanra_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = merge(var.resource_tags, {
    "Name" = "${var.resource_prefix}-vpc"
  })
}

resource "aws_subnet" "hanra_public_subnet_1" {
  vpc_id            = aws_vpc.hanra_vpc.id
  cidr_block        = "10.0.0.0/18"
  availability_zone = "eu-central-1a"

  tags = merge(var.resource_tags, {
    "Name" = "${var.resource_prefix}-public-1a"
  })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.hanra_vpc.id
}

resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = aws_vpc.hanra_vpc.default_route_table_id

// Route to local is created implicitly

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(var.resource_tags, {
    "Name" = "${var.resource_prefix}-default-route-table"
  })
}