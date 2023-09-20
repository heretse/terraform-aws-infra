locals {
  s3_buckets = yamldecode(file("${var.s3_path}"))["buckets"]
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  description = "Profile in aws/config"
  default     = ""
}

variable "environment" {
  description = "environment"
  default     = ""
}

variable "s3_path" {
  type        = string
  description = "s3 path"
  default     = ""
}
