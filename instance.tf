provider "aws" {
  region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket = "assignsachin"
    key    = "s3://assignsachin/sachin/remote.tfstate"
    region = "us-east-1"
  }
}


resource "aws_vpc" "sachin_admin" {
  cidr_block       = "10.20.0.0/16"

  tags = {
    Name = "vpc"
  }
}

resource "aws_internet_gateway" "IGW" {
    vpc_id =  aws_vpc.sachin_admin.id
tags = {
    Name = "IGW"
  }

}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.sachin_admin.id
  cidr_block = "10.20.1.0/24"
  availability_zone = "us-east-1a"


  tags = {
    Name = "public1"
  }
}

resource "aws_subnet" "main2" {
  vpc_id     = aws_vpc.sachin_admin.id
  cidr_block = "10.20.2.0/24"
  availability_zone = "us-east-1b"


  tags = {
    Name = "public2"
  }
}

resource "aws_subnet" "main3" {
  vpc_id     = aws_vpc.sachin_admin.id
  cidr_block = "10.20.11.0/24"
  availability_zone = "us-east-1a"


  tags = {
    Name = "backend1"
  }
}

resource "aws_subnet" "main4" {
  vpc_id     = aws_vpc.sachin_admin.id
  cidr_block = "10.20.12.0/24"
  availability_zone = "us-east-1b"


  tags = {
    Name = "backend2"
  }
}

resource "aws_subnet" "main5" {
  vpc_id     = aws_vpc.sachin_admin.id
  cidr_block = "10.20.13.0/24"
  availability_zone = "us-east-1a"


  tags = {
    Name = "db1"
  }
}

resource "aws_subnet" "main6" {
  vpc_id     = aws_vpc.sachin_admin.id
  cidr_block = "10.20.14.0/24"
  availability_zone = "us-east-1b"


  tags = {
    Name = "db2"
  }
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.sachin_admin.id

  

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table" "rt_private1" {
  vpc_id = aws_vpc.sachin_admin.id



  tags = {
    Name = "private_rt1"
  }
}

resource "aws_route_table" "rt_private2" {
  vpc_id = aws_vpc.sachin_admin.id



  tags = {
    Name = "private_rt2"
  }
}

resource "aws_route_table_association" "assn1" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "assn2" {
  subnet_id      = aws_subnet.main2.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "assn3" {
  subnet_id      = aws_subnet.main3.id
  route_table_id = aws_route_table.rt_private1.id
}

resource "aws_route_table_association" "assn4" {
  subnet_id      = aws_subnet.main4.id
  route_table_id = aws_route_table.rt_private1.id
}

resource "aws_route_table_association" "assn5" {
  subnet_id      = aws_subnet.main5.id
  route_table_id = aws_route_table.rt_private2.id
}

resource "aws_route_table_association" "assn6" {
  subnet_id      = aws_subnet.main6.id
  route_table_id = aws_route_table.rt_private2.id
}

resource "aws_route_table_association" "intgw" {
  gateway_id     = aws_internet_gateway.IGW.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "project_eip"
  }
}
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.main.id

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_route_table_association" "nt1" {
  gateway_id     = "nat-05c63272a06b5e66d"
  route_table_id = aws_route_table.rt_private1.id
}


