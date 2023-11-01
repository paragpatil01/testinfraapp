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