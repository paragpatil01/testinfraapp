terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
}

resource "aws_instance" "demo" {
  ami                     = "ami-0fc5d935ebf8bc3bc"
  instance_type           =  var.instance_type
  key_name                = "awslogin"
  security_groups = [ "aws_security_group.TF_SG.name" ]
  tags                    = {
    name = "testinfra"
  }
  
}

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-testinfra-bucket"

  tags   = {
    Name        = "My testinfra bucket"
    
  }
}

# resource "aws_security_group" "TF_SG" {
#   name        = "security group using terraform"
#   description = "security group using terraform"
#   vpc_id      = "vpc-04f8494e3a0202cbb"

#   ingress {
#     description      = "HTTP"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
#   ingress {
#     description      = "SSH"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "TF_SG"
#   }
# }