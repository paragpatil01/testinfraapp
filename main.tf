terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
}

resource "aws_instance" "demo" {
  ami                     = "ami-0fc5d935ebf8bc3bc"
  instance_type           =  var.instance_type
  key_name                = "myawslogin"
  tags                    = {
    name = "testinfra"
  }
  
}

