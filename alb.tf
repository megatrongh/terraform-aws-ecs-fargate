resource "aws_lb" "main" {
  name               = "example_alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.example_sg_alb.id]
  subnets            = aws_subnet.public.*.id
  enable_deletion_protection = false
}
 
resource "aws_alb_target_group" "main" {
  name        = "example_alb_target_group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.example_vpc.id
  target_type = "ip"
 
  health_check {
   healthy_threshold   = "3"
   interval            = "30"
   protocol            = "HTTP"
   matcher             = "200"
   timeout             = "3"
   path                = var.health_check_path
   unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main.id
  port              = 80
  protocol          = "HTTP"
 
 default_action {
    target_group_arn = example_alb_target_group.main.id
    type             = "forward"
  }
}