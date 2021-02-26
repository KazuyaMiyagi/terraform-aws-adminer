module "this" {
  source           = "../../"
  aws_region       = data.aws_region.current.name
  platform_version = "LATEST"
  cluster_name     = "adminer-cluster"
  service_name     = "adminer-service"
  task_family_name = "adminer-taskdef"
  image            = "adminer:standalone"
  cpu              = "256"
  memory           = "512"
  desired_count    = 1
  autoscaling_settings = {
    scale-in : {
      name         = "adminer_cluster_adminer_service_scale_in"
      schedule     = "cron(0 12 ? * * *)"
      max_capacity = 0
      min_capacity = 0
    },
    scale-out : {
      name         = "adminer_cluster_adminer_service_scale_out"
      schedule     = "cron(0 0 ? * MON-FRI *)"
      max_capacity = 2
      min_capacity = 1
    }
  }
  adminer_subnets          = data.aws_subnet_ids.default.ids
  adminer_security_groups  = [aws_security_group.adminer.id]
  adminer_target_group_arn = aws_lb_target_group.adminer.arn
  adminer_log_group_name   = "/ecs/adminer"
}

# https://www.terraform.io/docs/providers/aws/d/caller_identity.html
# account data
data "aws_caller_identity" "current" {}

# https://www.terraform.io/docs/providers/aws/d/region.html
# region data
data "aws_region" "current" {}

# https://www.terraform.io/docs/providers/aws/d/availability_zones.html
# availability_zones data
data "aws_availability_zones" "available" {}

# https://www.terraform.io/docs/providers/aws/d/elb_service_account.html
# elb service account data
data "aws_elb_service_account" "main" {}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
data "aws_vpc" "default" {
  default = true
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group
data "aws_security_group" "default" {
  name = "default"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group" "lb" {
  name   = "lb"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lb"
  }
}

resource "aws_security_group" "adminer" {
  name   = "adminer"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "adminer"
  }
}

resource "aws_lb" "adminer" {
  name               = "adminer"
  load_balancer_type = "application"
  internal           = false

  subnets = data.aws_subnet_ids.default.ids

  security_groups = [
    aws_security_group.lb.id
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
  vpc_id      = data.aws_vpc.default.id

  health_check {
    path    = "/"
    matcher = "200"
  }

  depends_on = [
    aws_lb.adminer
  ]
}
