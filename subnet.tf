#create a subnet
#resource "aws_subnet" "main" {
#  vpc_id     = aws_vpc.main.id
#  cidr_block = "10.0.1.0/24"
#
#  tags = {
#    Name = "Main"
#  }
#}


# Example data lookup for a subnet using a valid filter
# If you need multiple subnets, use count

locals {
  az = ["ap-south-1a", "ap-south-1b"]
}

resource "aws_subnet" "public-sub" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = local.az[count.index]
  map_public_ip_on_launch = true
  count                   = 2

  tags = {
    Name = "public-sub-${count.index + 1}"
  }
}

resource "aws_subnet" "private-sub" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 2}.0/24"
  availability_zone = local.az[count.index]
  count             = 2

  tags = {
    Name = "private-sub-${count.index + 1}"
  }
}

resource "aws_subnet" "db-sub" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 4}.0/24"
  availability_zone = local.az[count.index]
  count             = 2

  tags = {
    Name = "db-sub-${count.index + 1}"
  }
}
