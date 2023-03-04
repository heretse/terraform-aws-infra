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

variable "vpc_id" {
  type    = string
  default = ""
}

variable "bastion_instance_id" {
  type    = string
  default = ""
}

variable "nat_server_instance_id" {
  type    = string
  default = ""
}
