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

variable "instance_type" {
  description = "aws instance type and class"
  type        = string
}


variable "allowed_ranges" {
  description = "Allowed ranges that can access the cluster"
  type        = list(any)
  default     = ["0.0.0.0/0"]
}

variable "ssh-inbound-range" {
  description = "CIDRs of address that are allowed to ssh in."
  type        = list(any)
}

variable "subnet_ids" {
  description = "List of subnet Ids"
  type        = list(any)
}

variable "template-file" {
  type    = string
  default = "cassandra.tmpl"
}

variable "config-file" {
  type    = string
  default = "/etc/dse/cassandra/cassandra.yaml"
}

variable "ami" {
  description = "Contains information to select desired AWS AMI"
}

variable "vpc_id" {
  description = "The id for the vpc"
  type        = string
  validation {
    condition     = length(var.vpc_id) >= 12 && substr(var.vpc_id, 0, 4) == "vpc-"
    error_message = "The VPC ids need to start with vpc- and is at least 12 characters."
  }
}

variable "private_ips" {
  type        = list(any)
  description = "List of ips for the cassandra nodes"
}

variable "ssh_key_name" {
  description = "The ssh key name for the cassandra nodes"
  type        = string
}

variable "cluster_name" {
  description = "The cluster name for the cassandra nodes"
  type        = string
}

variable "root_password" {
  description = "The Cassandra root password"
  type        = string
}

variable "concurrent_reads" {
  description = "Should be set to (16 * number_of_drives) in order to allow the operations to enqueue low enough in the stack that the OS and drives can reorder them."
  type        = number
  default     = 32
}

variable "concurrent_writes" {
  description = "The ideal number of `concurrent_writes` is dependent on the number of cores in your system; (8 * number_of_cores) is a good rule of thumb."
  type        = number
  default     = 32
}

variable "concurrent_counter_writes" {
  description = "Same as `concurrent_reads`, since counter writes read the current values before incrementing and writing them back."
  type        = number
  default     = 32
}

variable "memtable_flush_writers" {
  description = "`memtable_flush_writers` defaults to two for a single data directory. This means that two  memtables can be flushed concurrently to the single data directory."
  type        = number
  default     = 2
}

variable "concurrent_compactors" {
  description = "`concurrent_compactors` defaults to the smaller of (number of disks, number of cores), with a minimum of 2 and a maximum of 8."
  type        = number
  default     = 8
}

variable "volume_size" {
  description = "The volume size (GB) for the cassandra nodes"
  type        = number
  default     = 100
}
