variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = ""
}

variable "platform_version" {
  description = "ECS Service platform version"
  default     = "1.4.0"
  type        = string
}

variable "cluster_name" {
  description = "The name of ecs cluster"
  default     = "adminer-cluster"
  type        = string
}

variable "service_name" {
  description = "The name of ecs service"
  default     = "adminer-service"
  type        = string
}

variable "task_family_name" {
  description = "The name of ecs task definition"
  default     = "adminer-taskdef"
  type        = string
}

variable "image" {
  description = "Container image and tag"
  type        = string
  default     = "adminer:standalone"
}

variable "cpu" {
  description = "Container cpu units"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Container memory size"
  type        = string
  default     = "512"
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
