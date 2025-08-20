provider "aws" {
  region = var.region
}

# VPC
resource "aws_vpc" "vault_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.name}-vpc"
  }
}

# Subnet
resource "aws_subnet" "vault_subnet" {
  vpc_id                  = aws_vpc.vault_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
  tags = {
    Name = "${var.name}-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "vault_gw" {
  vpc_id = aws_vpc.vault_vpc.id
  tags = {
    Name = "${var.name}-igw"
  }
}

# Route Table
resource "aws_route_table" "vault_rt" {
  vpc_id = aws_vpc.vault_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vault_gw.id
  }
}

resource "aws_route_table_association" "vault_rta" {
  subnet_id      = aws_subnet.vault_subnet.id
  route_table_id = aws_route_table.vault_rt.id
}

# Security Group
resource "aws_security_group" "vault_sg" {
  vpc_id = aws_vpc.vault_vpc.id
  name   = "${var.name}-sg"

  ingress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8201
    to_port     = 8201
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg"
  }
}

# Generate SSH Key Pair for AWS Vault
resource "tls_private_key" "aws_vault_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "aws_vault_key_pair" {
  key_name   = "${var.name}-key"
  public_key = tls_private_key.aws_vault_key.public_key_openssh
}

# Save the private key to a local file (optional)
resource "local_file" "aws_vault_private_key" {
  content  = tls_private_key.aws_vault_key.private_key_pem
  filename = "${path.module}/aws_vault_key.pem"
  file_permission = "0600"
}

# EC2 Instance
resource "aws_instance" "vault_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.vault_subnet.id
  vpc_security_group_ids = [aws_security_group.vault_sg.id]
  key_name               = aws_key_pair.aws_vault_key_pair.key_name

  user_data = file("vault.sh")

  tags = {
    Name = "${var.name}-vault"
  }
}
