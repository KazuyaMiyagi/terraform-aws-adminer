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

module "adminer" {
  source                   = "../../"
  aws_region               = data.aws_region.current.name
  image                    = "adminer:standalone"
  desired_count            = 1
  adminer_subnets          = [aws_subnet.private_0.id, aws_subnet.private_1.id]
  adminer_security_groups  = [aws_security_group.adminer.id]
  adminer_target_group_arn = aws_lb_target_group.adminer.arn
  adminer_log_group_name   = "/ecs/adminer"
}
