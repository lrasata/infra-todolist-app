provider "aws" {
  region = "eu-central-1"
}

data "aws_availability_zones" "available" {}

# dynamically fetch AMI IDS
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_vpc" "default" {
  default = true
}

# Find a subnet that belongs to the default VPC and is marked as the default for its availability zone.
data "aws_subnet" "default" {
  # get subnets which belongs to this vpc
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  # get one of the auto-created subnets, which is always usable (i.e., public by default).
  filter {
    name   = "default-for-az"
    values = ["true"]
  }

  filter {
    name   = "availability-zone"
    values = [data.aws_availability_zones.available.names[0]]
  }
}

resource "aws_instance" "app_server" {
  count         = var.instance_count
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  subnet_id              = data.aws_subnet.default.id # required for ec2 instance
  vpc_security_group_ids = [aws_security_group.allow_ssh_http_https.id]

  associate_public_ip_address = true

  tags = {
    Name = var.instance_name
  }

  # EC2 won’t respond to HTTP unless it has a web server running
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl enable httpd
              sudo systemctl start httpd
              echo "Hello from Terraform EC2" > /var/www/html/index.html
              EOF
}

resource "aws_security_group" "allow_ssh_http_https" {
  name        = "allow_ssh_http_https"
  description = "Allow SSH HTTP HTTPS inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open HTTP for everyone
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open HTTPS for everyone
  }

  egress {
    from_port   = 0             # From any port
    to_port     = 0             # To any port
    protocol    = "-1"          # All protocols (TCP, UDP, ICMP, etc.)
    cidr_blocks = ["0.0.0.0/0"] # To anywhere on the internet
  }
}

