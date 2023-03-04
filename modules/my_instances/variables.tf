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

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "ssh_key_name" {
  type    = string
  default = ""
}

variable "bastion_security_group_id" {
  type    = string
  default = ""
}

variable "nat_server_security_group_id" {
  type    = string
  default = ""
}

variable "subnet_bastion_id" {
  type    = string
  default = ""
}

variable "subnet_nat_server_id" {
  type    = string
  default = ""
}

variable "subnet_postgresql_proxy_id" {
  type    = string
  default = ""
}

variable "create_postgresql_proxy_profile" {
  type    = bool
  default = true
}

variable "ami_id" {
  type    = string
  default = null
}
