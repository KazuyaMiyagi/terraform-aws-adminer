resource "aws_lb" "adminer" {
  name               = "adminer"
  load_balancer_type = "application"
  internal           = false

  subnets = [
    aws_subnet.public_0.id,
    aws_subnet.public_1.id
  ]

  security_groups = [
    aws_security_group.lb.id
  ]

  access_logs {
    bucket  = aws_s3_bucket.lb.id
    enabled = true
  }

  depends_on = [
    aws_s3_bucket.lb,
    aws_s3_bucket_policy.lb
  ]
}

resource "aws_lb_listener" "adminer_http" {
  load_balancer_arn = aws_lb.adminer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.adminer.arn
    type             = "forward"
  }

  depends_on = [
    aws_lb.adminer
  ]
}

resource "aws_lb_target_group" "adminer" {
  name        = "adminer"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    path    = "/"
    matcher = "200"
  }

  depends_on = [
    aws_lb.adminer
  ]
}
