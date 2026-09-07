# =========================================
# PUBLIC ALB
# =========================================

resource "aws_lb" "public" {

  name               = "public-alb-tf"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.public_alb_sg.id
  ]

  subnets = [
    aws_subnet.public-sub[0].id,
    aws_subnet.public-sub[1].id
  ]

  tags = {
    Name = "public-alb"
  }
}

# Public ALB listener
resource "aws_lb_listener" "frontend_listener" {

  load_balancer_arn = aws_lb.public.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_target_group.arn
  }
}


# =========================================
# INTERNAL ALB
# =========================================

resource "aws_lb" "int-alb-tf" {

  name               = "int-alb-tf"
  internal           = true
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.internal_alb_sg.id
  ]

  subnets = [
    aws_subnet.private-sub[0].id,
    aws_subnet.private-sub[1].id
  ]

  tags = {
    Name = "internal-alb"
  }
}

# Internal ALB listener
resource "aws_lb_listener" "backend_listener" {

  load_balancer_arn = aws_lb.int-alb-tf.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_target_group.arn
  }
}