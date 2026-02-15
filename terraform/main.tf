provider "aws" {
  region = "ap-south-1"
}

# Security Group
resource "aws_security_group" "vm_sg" {
  name = "ansible-challenge-sg"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Netdata"
    from_port   = 19999
    to_port     = 19999
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Frontend - Amazon Linux
resource "aws_instance" "frontend" {
  ami           = "ami-0317b0f0a0144b137"
  instance_type = "t3.micro"

  key_name      = "ansible-challenge-key"
  vpc_security_group_ids = [aws_security_group.vm_sg.id]

  tags = {
    Name = "c8.local"
  }
}

# Backend - Ubuntu
resource "aws_instance" "backend" {
  ami           = "ami-019715e0d74f695be"
  instance_type = "t3.micro"

  key_name      = "ansible-challenge-key"
  vpc_security_group_ids = [aws_security_group.vm_sg.id]

  tags = {
    Name = "u21.local"
  }
}

output "frontend_ip" {
  value = aws_instance.frontend.public_ip
}

output "backend_ip" {
  value = aws_instance.backend.public_ip
}
