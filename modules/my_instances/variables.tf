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
  type        = string
  description = "The instance type of Bastion Server and NAT Server"
  default     = "t3.small"
}

variable "ssh_key_name" {
  type        = string
  description = "The SSH key of Bastion Server and NAT Server"
  default     = ""
}

variable "bastion_security_group_ids" {
  type        = list(string)
  description = "The security groups of Bastion Server"
  default     = []
}

variable "nat_server_security_group_ids" {
  type        = list(string)
  description = "The security groups of NAT Server"
  default     = []
}

variable "subnet_bastion_id" {
  type        = string
  description = "The subnet id of Bastion Server"
  default     = ""
}

variable "subnet_nat_server_id" {
  type        = string
  description = "The subnet id of NAT Server"
  default     = ""
}

variable "create_nat_server_instance" {
  type        = bool
  description = "Condition for creating NAT Server or not"
  default     = true
}

variable "bastion_ami_id" {
  type        = string
  description = "Specific AMI id for Bastion Server"
  default     = null
}

variable "nat_server_ami_id" {
  type        = string
  description = "Specific AMI id for NAT Server"
  default     = null
}
variable "bastion_user_data" {
  type        = string
  description = "The user data of Bastion Server"
  default     = null
}

variable "bastion_launch_template" {
  type        = map(any)
  description = "The launch template of Bastion Server"
  default     = null
}

variable "bastion_ami" {
  type        = map(any)
  description = "The AMI search criteria of Bastion Server"
  default     = null
}

variable "nat_server_launch_template" {
  type        = map(any)
  description = "The launch template of NAT Server"
  default     = null
}
