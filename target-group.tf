# -------------------------
# Frontend Target Group
# -------------------------

resource "aws_lb_target_group" "frontend_target_group" {

  name     = "frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  tags = {
    Name = "frontend-target-group"
  }
}

resource "aws_lb_target_group_attachment" "frontend_target_attached" {

  count            = 2
  target_group_arn = aws_lb_target_group.frontend_target_group.arn
  target_id        = aws_instance.frontend[count.index].id
  port             = 80
}


# -------------------------
# Backend Target Group
# -------------------------

resource "aws_lb_target_group" "backend_target_group" {

  name     = "backend-tg"
  port     = 4000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path = "/transaction"
  }

  tags = {
    Name = "backend-target-group"
  }
}

resource "aws_lb_target_group_attachment" "backend_target_attached" {

  count            = 2
  target_group_arn = aws_lb_target_group.backend_target_group.arn
  target_id        = aws_instance.backend[count.index].id
  port             = 4000
}