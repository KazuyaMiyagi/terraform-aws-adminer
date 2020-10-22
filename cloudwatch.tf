resource "aws_cloudwatch_log_group" "adminer" {
  name = var.adminer_log_group_name
}
