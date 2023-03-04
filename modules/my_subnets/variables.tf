locals {
  subnets = yamldecode(file("${var.subnet_path}"))["subnets"]
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
  type    = string
  description = "Department name"
  default = "SRE"
}

variable "environment" {
  type        = string
  description = "Environment"
  default     = null
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "vpc_cidr" {
  type    = string
  default = ""
}

variable "subnet_path" {
  type        = string
  description = "Subnet path"
  default     = ""
}
