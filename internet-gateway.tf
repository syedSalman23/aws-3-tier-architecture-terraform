#This creates an Internet Gateway (IGW) and attaches it to the VPC.
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

#This is used to attach an existing Internet Gateway to a VPC.
#resource "aws_internet_gateway_attachment" "example" {
#  internet_gateway_id = aws_internet_gateway.example.id
#  vpc_id              = aws_vpc.example.id
#}