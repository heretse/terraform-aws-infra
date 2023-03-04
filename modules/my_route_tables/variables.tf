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

variable "igw_id" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "subnet_public_a_id" {
  type    = string
  default = ""
}

variable "subnet_public_c_id" {
  type    = string
  default = ""
}

variable "subnet_public_d_id" {
  type    = string
  default = ""
}

variable "subnet_application_a_id" {
  type    = string
  default = ""
}

variable "subnet_application_c_id" {
  type    = string
  default = ""
}

variable "subnet_application_d_id" {
  type    = string
  default = ""
}

variable "subnet_intra_a_id" {
  type    = string
  default = ""
}

variable "subnet_intra_c_id" {
  type    = string
  default = ""
}

variable "subnet_intra_d_id" {
  type    = string
  default = ""
}

variable "subnet_persistence_a_id" {
  type    = string
  default = ""
}

variable "subnet_persistence_c_id" {
  type    = string
  default = ""
}

variable "subnet_persistence_d_id" {
  type    = string
  default = ""
}

variable "subnet_nat_server_id" {
  type    = string
  default = ""
}

variable "nat_server_eip_assoc_eni_id" {
  type    = string
  default = ""
}
