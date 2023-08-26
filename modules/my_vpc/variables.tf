locals {
  vpcs = yamldecode(file("${var.vpc_path}"))["vpcs"]
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
  type    = string
  description = "Project name"
  default = ""
}

variable "department_name" {
  type        = string
  description = "Department name"
  default     = "SRE"
}

variable "vpc_path" {
  type        = string
  description = "VPC path"
  default     = ""
}
