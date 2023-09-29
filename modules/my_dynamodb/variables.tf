locals {
  tables = yamldecode(file("${var.config_path}"))["tables"]
}

variable "aws_region" {
  description = "AWS region"
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  description = "AWS profile"
  default     = ""
}

variable "config_path" {
  type        = string
  description = "table path"
  default     = ""
}
