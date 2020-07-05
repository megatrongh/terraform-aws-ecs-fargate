resource "aws_security_group" "example_sg_alb" {
  name        = "example_sg_alb"
  vpc_id = aws_vpc.example_vpc.id
 
  ingress {
   protocol         = "tcp"
   from_port        = 80
   to_port          = 80
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }
 
  ingress {
   protocol         = "tcp"
   from_port        = 443
   to_port          = 443
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }
 
  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }

tags = {
    Name        = "example-sg-alb-tag"
    Environment = "production"
  }

}

resource "aws_security_group" "example_sg_ecs_tasks" {
  name   = "example_sg_ecs_tasks"
  vpc_id = aws_vpc.example_vpc.id
 
  ingress {
   protocol         = "tcp"
   from_port        = var.host_port
   to_port          = var.container_port
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }
 
  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "example-sg-ecs_tasks-tag"
    Environment = "production"
  }
}