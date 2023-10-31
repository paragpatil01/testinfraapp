terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = "var.aws_region"
}

resource "aws_instance" "this" {
  ami                     = "ami-0287a05f0ef0e9d9a"
  instance_type           = "var.instance_type"
  key_name = "myawslogin"
  tags = {
    name = "testinfra"
  }
  
}

