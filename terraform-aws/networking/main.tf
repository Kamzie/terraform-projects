# --- Networking/main.tf ---

# Fetch the list of available availability zones in the region
data "aws_availability_zones" "availability" {}

# Generate a random number for resource tagging
resource "random_integer" "random" {
  min = 1
  max = 100
}

# Shuffle the available AZs to randomly assign them to subnets
resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.availability.names
  result_count = var.max_subnets
}

# Create a VPC with DNS support enabled
resource "aws_vpc" "mtc_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "mtc_vpc-${random_integer.random.result}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create public subnets using count
resource "aws_subnet" "mtc_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]


  tags = {
    Name = "mtc_public-${count.index + 1}"
  }
}

# Create private subnets using count
resource "aws_subnet" "mtc_private_subnet" {
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.az_list.result[count.index]


  tags = {
    Name = "mtc_private-${count.index + 1}"
  }
}

# Create an Internet Gateway for public access
resource "aws_internet_gateway" "mtc_internet_gateway" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "mtc_igw"
  }
}

# Create a route table for public subnets and associate with IGW
resource "aws_route_table" "mtc_public_rt" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "mtc_public_rt"
  }
}

# Define the default route for public subnets to allow outbound traffic
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.mtc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mtc_internet_gateway.id
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "mtc_public_assoc" {
  count          = var.public_sn_count
  route_table_id = aws_route_table.mtc_public_rt.id
  subnet_id      = aws_subnet.mtc_public_subnet.*.id[count.index]
}

# Create a default route table for private subnets
resource "aws_default_route_table" "mtc_private_rt" {
  default_route_table_id = aws_vpc.mtc_vpc.default_route_table_id

  tags = {
    Name = "mtc_private_rt"
  }
}

# Define security groups for public and RDS resources
resource "aws_security_group" "mtc_sg" {
  for_each = var.security_groups

  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.mtc_vpc.id

  # Define ingress (incoming) rules dynamically for each security group
  dynamic "ingress" {
    for_each = each.value.ingress

    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  # Define egress (outgoing) rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define a DB subnet group for RDS resources
resource "aws_db_subnet_group" "mtc_rds_subnetgroup" {
  count      = var.db_subnet_group ? 1 : 0
  name       = "mtc_rds_subnetgroup"
  subnet_ids = aws_subnet.mtc_private_subnet.*.id

  tags = {
    Name = "mtc_rds_sng"
  }
}


