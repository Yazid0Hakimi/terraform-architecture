 terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  
  tags = {
    Name        = "WebServer"
    Environment = var.environment
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web-security-group"
  description = "Security group for web server"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "web-sg"
  }
}

resource "aws_s3_bucket" "logs" {
  bucket = "my-app-logs-${var.environment}"
  
  tags = {
    Name        = "Application Logs"
    Environment = var.environment
  }
}