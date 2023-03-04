variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  type        = string
  description = "Profile in aws/config"
  default     = "nxd-dev"
}

variable "department_name" {
  type    = string
  description = "Department Name"
  default = ""
}

variable "project_name" {
  type    = string
  description = "Project Name"
  default = ""
}

variable "environment" {
  type        = string
  description = "Environment"
  default     = ""
}

variable "ssh_key_name" {
  type    = string
  default = ""
}
