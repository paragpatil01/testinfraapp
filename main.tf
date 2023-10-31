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
  ami                     = "ami-0dcc1e21636832c5d"
  instance_type           = "var.instance_type"
  key_name = "myawslogin"
  tags = {
    name = "testinfra"
  }
  
}