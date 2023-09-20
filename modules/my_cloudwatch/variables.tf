variable "aws_region" {
  description = "aws region"
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

variable "cloudwatch_path" {
  description = "Cloudwatch path"
  default     = ""
}
