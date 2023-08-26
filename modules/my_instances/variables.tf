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

variable "bastion_security_group_ids" {
  type    = list(string)
  default = []
}

variable "nat_server_security_group_ids" {
  type    = list(string)
  default = []
}

variable "subnet_bastion_id" {
  type    = string
  default = ""
}

variable "subnet_nat_server_id" {
  type    = string
  default = ""
}

variable "create_nat_server_instance" {
  type    = bool
  default = true
}

variable "create_postgresql_proxy_profile" {
  type    = bool
  default = true
}

variable "bastion_ami_id" {
  type    = string
  default = null
}

variable "nat_server_ami_id" {
  type    = string
  default = null
}
variable "bastion_user_data" {
  type    = string
  default = null
}

variable "bastion_launch_template" {
  type    = map(any)
  default = null
}

variable "bastion_ami" {
  type = map(any)
}

variable "nat_server_launch_template" {
  type    = map(any)
  default = null
}
