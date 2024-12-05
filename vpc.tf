# instance vpc block
resource "aws_vpc" "main" {
  cidr_block       = "172.120.0.0/16"
  instance_tenancy = "default"
  tags = {
    name = "utc-app"
    Team = "cloud team"
  }
}
# private subnet 
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-east-1a"
  cidr_block        = "172.120.1.0/24"
  tags = {
    name = "utc-private_sub_1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "us-east-1b"
  cidr_block        = "172.120.2.0/24"
  tags = {
    name = "utc-private_sub_2"
  }
}

# Public subnet
resource "aws_subnet" "Public1" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "us-east-1a"
  cidr_block              = "172.120.3.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    name = "utc-public_sub_1"
  }
}

resource "aws_subnet" "Public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.120.4.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = "true"
  tags = {
    name = "utc-public_subnet_2"
  }
}
#internet gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main.id
  tags = {
    name = "utc_IGW"
  }
}

# Créer une Elastic IP pour la NAT Gateway
resource "aws_eip" "nat" {
  vpc = true
}
# Nat Gateway
resource "aws_nat_gateway" "NAT_gatway" {
  subnet_id     = aws_subnet.Public2.id
  allocation_id = aws_eip.nat.id
  tags = {
    name = "utc_NAT_GATEWAY"
  }
}
# Publique table route 
resource "aws_route_table" "Pubtable_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_route_table" "Pritable_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT_gatway.id
  }
}
#private route association
resource "aws_route_table_association" "private_sub_1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.Pritable_rt.id

}
resource "aws_route_table_association" "private_sub_2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.Pritable_rt.id
}

# public route association
resource "aws_route_table_association" "public_sub_1" {
  subnet_id      = aws_subnet.Public1.id
  route_table_id = aws_route_table.Pubtable_rt.id
}
resource "aws_route_table_association" "public_sub_2" {
  subnet_id      = aws_subnet.Public2.id
  route_table_id = aws_route_table.Pubtable_rt.id
}