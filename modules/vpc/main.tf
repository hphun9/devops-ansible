resource "aws_vpc" "this" {
    cidr_block           = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags = merge(var.tags, { Name = "${var.name}-vpc" })
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.this.id
    tags   = merge(var.tags, { Name = "${var.name}-igw" })
}

data "aws_availability_zones" "az" {}

resource "aws_subnet" "public" {
    for_each = { for idx, cidr in var.public_subnets : idx => cidr }
    vpc_id                  = aws_vpc.this.id
    cidr_block              = each.value
    availability_zone       = data.aws_availability_zones.az.names[tonumber(each.key)]
    map_public_ip_on_launch = true
    tags = merge(var.tags, { Name = "${var.name}-public-${each.key}", Tier = "public" })
}

resource "aws_subnet" "private" {
    for_each = { 
        for idx, 
        cidr in var.private_subnets : idx => cidr 
    }
    vpc_id            = aws_vpc.this.id
    cidr_block        = each.value
    availability_zone = data.aws_availability_zones.az.names[tonumber(each.key)]
    tags = merge(var.tags, { Name = "${var.name}-private-${each.key}", Tier = "private" })
}

resource "aws_eip" "nat" { 
    domain = "vpc" 
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.id
    subnet_id     = element([for s in aws_subnet.public : s.id], 0)
    tags          = merge(var.tags, { Name = "${var.name}-nat" })
    depends_on    = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.this.id
    route { 
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id 
    }
    tags = merge(var.tags, { Name = "${var.name}-rt-public" })
}

resource "aws_route_table_association" "public" {
    for_each       = aws_subnet.public
    subnet_id      = each.value.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.this.id
    route { 
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id 
    }
    tags = merge(var.tags, { Name = "${var.name}-rt-private" })
}

resource "aws_route_table_association" "private" {
    for_each       = aws_subnet.private
    subnet_id      = each.value.id
    route_table_id = aws_route_table.private.id
}
