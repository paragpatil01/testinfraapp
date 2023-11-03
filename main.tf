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
  ami                     = "ami-0287a05f0ef0e9d9a"
  instance_type           =  var.instance_type
  key_name                = "myawslogin"
  security_groups         = [ aws_security_group.TF_SG.name ]
  tags                    = {
    name = "testinfra"
  }
  
}



resource "aws_security_group" "TF_SG" {
  name        = "security group using terraform"
  description = "security group using terraform"
  vpc_id      = "vpc-04f8494e3a0202cbb"

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "TF_SG"
  }
}

resource "aws_lb_target_group" "front" {
  name = "application-front"
  port = 80
  protocol = "HTTP"
  vpc_id = "vpc-04f8494e3a0202cbb"
  health_check {
    healthy_threshold = 5
    interval = 30
    matcher = 200
    path = "/index.html"
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 2
  }

}
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.front.arn
  target_id        = aws_instance.demo.id
  port             = 80
}

resource "aws_security_group" "elb" {
  name        = "security group for elb terraform"
  description = "security group for elb terraform"
  vpc_id      = "vpc-04f8494e3a0202cbb"

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "elb"
  }
}

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.elb.name ]
  subnets            = ["subnet-01c61efbc979db1a5","subnet-0574b864a53f1d4bf"]
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"
  

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front.arn
  }
}