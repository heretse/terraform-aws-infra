locals {
  streams = yamldecode(file("${var.stream_path}"))["streams"]
}

variable "aws_region" {
  description = "AWS region"
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  description = "AWS profile"
  default     = ""
}

variable "project_name" {
  type        = string
  description = "Project name"
  default     = ""
}

variable "department_name" {
  type        = string
  description = "Department name"
  default     = "SRE"
}

variable "stream_path" {
  type        = string
  description = "The path of streams"
  default     = ""
}
