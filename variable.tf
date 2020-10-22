variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = ""
}

variable "image" {
  description = "Container image and tag"
  type        = string
  default     = "adminer:standalone"
}

variable "desired_count" {
  description = "Adminer container count"
  type        = number
  default     = 0
}

variable "adminer_subnets" {
  description = "Subnet ID list to be attached to the adminer"
  type        = list(string)
  default     = []
}

variable "adminer_security_groups" {
  description = "Security group list to be attached the adminer"
  type        = list(string)
  default     = []
}

variable "adminer_target_group_arn" {
  description = "Target group to be attached the adminer"
  type        = string
  default     = ""
}

variable "adminer_log_group_name" {
  type        = string
  description = "adminer log group name"
  default     = "/ecs/adminer"
}
